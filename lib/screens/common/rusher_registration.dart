import 'dart:developer';
import 'package:flutter/material.dart';

// Referenced from https://www.syncfusion.com/blogs/post/dynamic-forms-in-flutter

// Declare as mutable state
class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({Key? key}) : super(key: key);

  @override
  DynamicFormPageState createState() => DynamicFormPageState();
}

// State class is where all of the logic is created with the build method
class DynamicFormPageState extends State<DynamicFormPage> {
  List<DynamicModel> formsList = [];

  List<ItemModel> schools = [
    ItemModel(0, "Georgia Tech"),
    ItemModel(1, "LocalSchoolTest1"),
    ItemModel(2, "LocalSchoolTest2")
  ];

  List<ItemModel> frats = [
    ItemModel(0, "Delta Sigma Phi"),
    ItemModel(1, "LocalFratTest1"),
    ItemModel(2, "LocalTestFrat2")
  ];

  @override 
  void initState() {
    super.initState();
    setUpForms();
  }

  void setUpForms() {
    formsList.add(DynamicModel("Greek Affiliation", FormType.dropdown, items: frats));

    DynamicModel dynamicModel = DynamicModel("Name", FormType.text, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.notEmpty, "Please provide a name"));
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.textLength, "Please keep the name under 50 characters", textLength: 50));
    formsList.add(dynamicModel);

    dynamicModel = DynamicModel("Phrase", FormType.text, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(ValidatorType.notEmpty, "Please provide the phrase given by the rush chair"));
    formsList.add(dynamicModel);
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Registration',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // form fields
          Expanded(
            child: ListView.builder(
              itemCount: formsList.length,
              itemBuilder: (context, index) {
                switch (formsList[index].formType) {
                  case FormType.dropdown:
                    return getDropDown(index, formsList[index].items);
                  case FormType.text:
                    return getTextWidget(index);
                  default:
                    return Container();
                }
              },
            ),
          ),

          // Arrow Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  log("Hi");
                },
                child: const Icon(Icons.arrow_forward),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField getTextWidget(int index) {
    return TextFormField(
      decoration: InputDecoration(
        helperText: formsList[index].controlName,
        labelText: formsList[index].controlName,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLines: null,
      validator: (text) {
        var selectedField = formsList[index];

        // return error message if text is empty
        if (selectedField.isRequired && selectedField.validators.any((element) => element.type == ValidatorType.notEmpty) && (text == null || text.isEmpty)) {
          return selectedField.validators.firstWhere((element) => element.type == ValidatorType.notEmpty).errorMessage;
        }

        // return error if text length too large
        if (selectedField.validators.any((element) => element.type == ValidatorType.textLength)) {
          var validator = selectedField.validators.firstWhere((element) => element.type == ValidatorType.textLength);
          int? len = text?.length;

          if (len != null && len > validator.textLength) {
            return validator.errorMessage;
          }
        }
        return null;
      },
      onChanged: (text) {
        formsList[index].value = text;
      },
    );
  }

  DropdownButtonFormField<ItemModel> getDropDown(int index, List<ItemModel> listItems) {
    return DropdownButtonFormField<ItemModel>(
      value: formsList[index].selectedItem,
      items: listItems.map<DropdownMenuItem<ItemModel>>((ItemModel value) {
        return DropdownMenuItem<ItemModel>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          formsList[index].selectedItem = value;
          if (formsList[index].controlName == "School") {
            var filteredFrats = frats.where((element) => value?.id == element.parentId).toList();
            if (formsList.any((element) => element.controlName == "Fraternities")) {
              formsList[index + 1].selectedItem = null;
              var existingitem = formsList.firstWhere((element) => element.controlName == "Fraternities");
              formsList.remove(existingitem);
            }
            if (filteredFrats.isNotEmpty) {
              formsList.insert(index + 1, DynamicModel("Fraternities", FormType.dropdown, items: filteredFrats));
            }
          }
        });
      },
      validator: (value) => value == null ? 'Field required' : null,
      decoration: InputDecoration(
        labelText: formsList[index].controlName,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
      ),
    );
  }
}

class DynamicModel {
  String controlName;
  FormType formType;
  String value;
  List<ItemModel> items;
  ItemModel? selectedItem;
  bool isRequired;
  List<DynamicFormValidator> validators;

  DynamicModel(this.controlName, this.formType, {
    this.items = const [],
    this.value = '',
    this.selectedItem,
    this.isRequired = true,
    this.validators = const [],
  });
}

class DynamicFormValidator {
  ValidatorType type;
  String errorMessage;
  int textLength;

  DynamicFormValidator(this.type, this.errorMessage, {this.textLength = 0});
}

class ItemModel {
  int id;
  int parentId;
  String name;

  ItemModel(this.id, this.name, {this.parentId = 0});
}

enum ValidatorType {
  notEmpty,
  textLength,
  phoneNumber,
}

enum FormType {
  text,
  dropdown,
}
