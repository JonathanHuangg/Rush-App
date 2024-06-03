import 'dart:ui';

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
  text,
  dropdown,
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

DropdownButtonFormField getDropDown(index, List<ItemModel> listItems) {
  return DropdownButtonFormField<ItemModel>(
    value: formsList[index].selectedItem,

    // maps each itemModel in listItems to DropDownMenuItem<ItemModel> and turn to list
    items: listItems.map<DropdownMenuItem<ItemModel>>((ItemModel value) {
      return DropdownMenuItem<ItemModel>(
        value: value,
        child: Text(value.name),
      );
    }).toList(),

    // changes when selected value in menu changes
    // goal is to dynamically change the Fraternities dropdown when the school is selected
    onChanged: (value) {
      setState(() {
        formsList[index].selectedItem = value; // gets updated on every click
        if (formsList[index].controlName == "School") {
          
          // filters the frats list to get when they match the Georgia Tech tag (assuming other schools adopt)
          var filteredFrats = frats 
            .where((element) => value?.id == element.parentId)
            .toList();
          
          // this is to remove any EXISTING fraternity list (eg: if I first select UGA and then GT)
          if (formsList.any((element) => element.controlName == "Fraternities")) {
            formsList[index + 1].selectedItem = null;
            var existingitem = formsList
              .firstWhere((element) => element.controlName == "Fraternities");
            formsList.remove(existingitem);
          }

          if (filteredFrats.isNotEmpty) {
            formsList.insert( 
              index + 1,
              DynamicModel("Fraternities", FormType.Dropdown, items: filteredFrats)
            );
          }
        }
      });
    },

    validator: (value) => value == null ? 'Field required' : null,
    decoration: InputDecoration(
      labelText: formsList[index].controlName,
      border: const OutlineInputBorder( 
        borderRadius: BorderRadius.all(Radius.circular(14.0))
      )
    )
  );
}
