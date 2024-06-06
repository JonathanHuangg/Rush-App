import 'package:flutter/material.dart';
export 'package:rush_app/widgets/common/rusher_registration_widgets.dart';

TextFormField getTextWidget(int index, List<DynamicModel> formsList) {
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

DropdownButtonFormField<ItemModel> getDropDown(int index, List<ItemModel> listItems, 
  List<DynamicModel> formsList, List<ItemModel> frats, State state) {
  return DropdownButtonFormField<ItemModel>(
    value: formsList[index].selectedItem,
    items: listItems.map<DropdownMenuItem<ItemModel>>((ItemModel value) {
      return DropdownMenuItem<ItemModel>(
        value: value,
        child: Text(value.name),
      );
    }).toList(),
    onChanged: (value) {
      state.setState(() {
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
