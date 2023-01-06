import 'package:chatrooms/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddUserPage extends StatelessWidget {

  final textController = TextEditingController();
  final ageController = TextEditingController();
  final bdayController = TextEditingController();

/*  Future createUser({required String name, required int age, required DateTime bday}) async{
    final docUser = FirebaseFirestore.instance.collection('Users').doc();//id generated automatically
    final user = User(
      id: docUser.id,
      name: name,
      age: age,
      birthday: bday,
    );
    final json = user.toJson();
    // Create document and write data to Firebase
    await docUser.set(json);
  }*/
  //or You can pass an object user to this createUser function
  Future createUser(User user) async{
    final docUser = FirebaseFirestore.instance.collection('Users').doc();//id generated automatically
    user.id = docUser.id;
    final json = user.toJson();
    // Create document and write data to Firebase
    await docUser.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add User"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15,),
              TextField(
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              TextField(
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: ageController,
                decoration: InputDecoration(
                  hintText: 'Enter age',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,

              ),
              const SizedBox(height: 15,),
              DateTimeField(
                controller: bdayController,
                decoration: InputDecoration(
                  hintText: 'Enter birthday',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                format: DateFormat("yyyy-MM-dd"),

                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                },
              ),
              const SizedBox(height: 15,),
              ElevatedButton(
                  onPressed: () {
                    final user = User(
                        name: textController.text,
                        age: int.parse(ageController.text),
                        birthday: DateTime.parse(bdayController.text)
                    );
                    createUser(user);
                    //createUser(name: textController.text, age: int.parse(ageController.text), bday: DateTime.parse(bdayController.text));
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 20,  // Elevation
                    shadowColor: Colors.grey[300], //
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Create", style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        ),


      ),
    );
  }
}
