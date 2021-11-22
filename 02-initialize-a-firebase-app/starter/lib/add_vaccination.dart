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

import 'package:flutter/material.dart';

import 'models/pets.dart';
import 'widgets/text_field.dart';
import 'models/vaccination.dart';
import 'widgets/date_picker.dart';
import 'widgets/vaccinated_check_box.dart';

class AddVaccination extends StatefulWidget {
  final Pet pet;
  final Function callback;
  const AddVaccination({Key? key, required this.pet, required this.callback})
      : super(key: key);
  @override
  _AddVaccinationState createState() => _AddVaccinationState();
}

class _AddVaccinationState extends State<AddVaccination> {
  final _formKey = GlobalKey<FormState>();

  late Pet pet;
  var done = false;
  var vaccination = '';
  late DateTime vaccinationDate;

  @override
  void initState() {
    pet = widget.pet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Vaccination'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                UserTextField(
                  name: 'vaccination',
                  initialValue: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the Vaccination Name';
                    }
                  },
                  inputType: TextInputType.text,
                  onChanged: (value) {
                    if (value != null) {
                      vaccination = value;
                    }
                  },
                ),
                DatePicker(
                    name: 'Date',
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the Vaccination Date';
                    }
                    },
                    onChanged: (text) {
                      vaccinationDate = text;
                    }),
                VaccinatedCheckBox(
                    name: 'Given',
                    value: done,
                    onChanged: (text) {
                      done = text ?? done;
                    }),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop();
                  final newVaccination = Vaccination(vaccination,
                      date: vaccinationDate, done: done);
                  pet.vaccinations.add(newVaccination);
                }
                widget.callback();
              },
              child: const Text('Add')),
        ]);
  }
}
