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
import 'package:pet_medical/pet_room.dart';

import 'models/pets.dart';
import 'utils/pets_icons.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final TextStyle boldStyle;
  final splashColor = {
    'cat': Colors.pink[100],
    'dog': Colors.blue[100],
    'other': Colors.grey[100]
  };

  PetCard({Key? key, required this.pet, required this.boldStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(pet.name, style: boldStyle),
            ),
          ),
          _getPetIcon(pet.type)
        ],
      ),
      onTap: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute(
          builder: (context) => PetRoom(pet: pet),
        ),
      ),
      splashColor: splashColor[pet.type],
    ));
  }

  Widget _getPetIcon(String type) {
    Widget petIcon;
    if (type == 'cat') {
      petIcon = IconButton(
        icon: const Icon(
          Pets.cat,
          color: Colors.pinkAccent,
        ),
        onPressed: () {},
      );
    } else if (type == 'dog') {
      petIcon = IconButton(
        icon: const Icon(
          Pets.dog_seating,
          color: Colors.blueAccent,
        ),
        onPressed: () {},
      );
    } else {
      petIcon = IconButton(
        icon: const Icon(
          Icons.pets,
          color: Colors.blueGrey,
        ),
        onPressed: () {},
      );
    }
    return petIcon;
  }
}
