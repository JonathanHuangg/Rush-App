import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rush_app/widgets/common/rusher_registration_widgets.dart';

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
                    return getDropDown(index, formsList[index].items, formsList, frats, this);
                  case FormType.text:
                    return getTextWidget(index, formsList);
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
}