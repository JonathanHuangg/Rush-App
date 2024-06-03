import 'package:flutter/material.dart';
// Referenced from https://www.syncfusion.com/blogs/post/dynamic-forms-in-flutter
class DynamicModel {
  String controlName; // uniquely identifies field (text boxes and stuff)
  FormType formType; // reference enum
  String value; // current value of form
  List<ItemModel> items; // holds the items in dropdown
  ItemModel? selectedItem; // keeps track of which item is selected
  bool isRequired; // self explanatory
  List<DynamicFormValidator> validators; // ex: check if empty, valid address, etc

  DynamicModel(this.controlName, this.formType, {
    this.items = const[],
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

enum FormType 
{
  Text,
  Multiline, 
  Dropdown, 
  AutoComplete, 
  RTE,
  DatePicker 
}

TextFormField getTextWidget(int index) {
  return TextFormField(

    // add parts to textForm field
    decoration: InputDecoration( 
      helperText: dynamicFormsList[index].hintText, // text below input field
      labelText: formsList[index].controlName, // label text for input field (like the light gray one)
      border: const OutlineInputBorder( // self explanatory
        borderRadius: BorderRadius.all(Radius.circular(14.0))
      )
    ),

    keyboardType: TextInputType.text,
    maxLines: null,
    validator: (text) {
      var selectedField = formsList[index];

      // return error message if text is empty

      if (selectedField.isRequired && selectedField.validators.any((element) => element.type == ValidatorType.notEmpty) && (text == null || text.isEmpty)) {
        return selectedField.validators.firstWhere(
          (element) => element.type == ValidatorType.notEmpty)
          .errorMessage;
      } 

      // return error if text length too large

      if (selectedField.validators.any((element) => element.type == ValidatorType.textLength)) {
        var validator = selectedField.validators.firstWhere(
          (element) => element.type == ValidatorType.textLength
        );

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