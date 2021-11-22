// Copyright (c) 2021 Razeware LLC

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// Notwithstanding the foregoing, you may not use, copy, modify,
// merge, publish, distribute, sublicense, create a derivative work,
// and/or sell copies of the Software in any work that is designed,
// intended, or marketed for pedagogical or instructional purposes
// related to programming, coding, application development, or
// information technology. Permission for such use, copying,
// modification, merger, publication, distribution, sublicensing,
// creation of derivative works, or sale is expressly withheld.

// This project and source code may use libraries or frameworks
// that are released under various Open-Source licenses. Use of
// those libraries and frameworks are governed by their own
// individual licenses.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pet_medical/repository/data_repository.dart';

import 'models/pets.dart';
import 'add_vaccination.dart';
import 'vaccination_list.dart';
import 'widgets/text_field.dart';
import 'models/vaccination.dart';
import 'widgets/choose_chips.dart';

class PetDetail extends StatefulWidget {
  final Pet pet;

  const PetDetail({Key? key, required this.pet}) : super(key: key);

  @override
  _PetDetailState createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  final DataRepository repository = DataRepository();
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');
  late List<CategoryOption> animalTypes;
  late String name;
  late String type;
  String? notes;

  @override
  void initState() {
    type = widget.pet.type;
    name = widget.pet.name;
    animalTypes = [
      CategoryOption(type: 'cat', name: 'Cat', isSelected: type == 'cat'),
      CategoryOption(type: 'dog', name: 'Dog', isSelected: type == 'dog'),
      CategoryOption(type: 'other', name: 'Other', isSelected: type == 'other'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      height: double.infinity,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              UserTextField(
                name: 'Pet Name',
                initialValue: widget.pet.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input name';
                  }
                },
                inputType: TextInputType.name,
                onChanged: (value) => name = value ?? name,
              ),
              ChooseType(
                title: 'Animal Type',
                options: animalTypes,
                onOptionTap: (value) {
                  setState(() {
                    animalTypes.forEach((element) {
                      type = value.type;
                      element.isSelected = element.type == value.type;
                    });
                  });
                },
              ),
              const SizedBox(height: 20.0),
              UserTextField(
                name: 'notes',
                initialValue: widget.pet.notes ?? '',
                validator: (value) {},
                inputType: TextInputType.text,
                onChanged: (value) => notes = value,
              ),
              VaccinationList(pet: widget.pet, buildRow: buildRow),
              FloatingActionButton(
                onPressed: () {
                  _addVaccination(widget.pet, () {
                    setState(() {});
                  });
                },
                tooltip: 'Add Vaccination',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                      color: Colors.blue.shade600,
                      onPressed: () {
                        Navigator.of(context).pop();
                        repository.deletePet(widget.pet);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  MaterialButton(
                    color: Colors.blue.shade600,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop();
                        widget.pet.name = name;
                        widget.pet.type = type;
                        widget.pet.notes = notes ?? widget.pet.notes;

                        repository.updatePet(widget.pet);
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(Vaccination vaccination) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(vaccination.vaccination),
        ),
        Text(dateFormat.format(vaccination.date)),
        Checkbox(
          value: vaccination.done ?? false,
          onChanged: (newValue) {
            setState(() {
              vaccination.done = newValue;
            });
          },
        )
      ],
    );
  }

  void _addVaccination(Pet pet, Function callback) {
    showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return AddVaccination(pet: pet, callback: callback);
        });
  }
}
