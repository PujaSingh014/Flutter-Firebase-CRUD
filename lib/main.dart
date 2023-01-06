import 'package:chatrooms/AddUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

/*
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final textController = TextEditingController();
  Future createUser({required String name}) async{
    final docUser = FirebaseFirestore.instance.collection('Users').doc('my-id');
    final json = {
      'name': name,
      'age': 21,
      'birthday': DateTime(2001, 5, 14),
    };
    // Create document and write data to Firebase
    await docUser.set(json);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CRUD"),
        ),
        body: TextField(
          controller: textController,
          decoration: InputDecoration(
          hintText: 'Enter a message',
          suffixIcon: IconButton(
            onPressed: () {
              final name = textController.text;
              createUser(name: name);
            },
            icon: Icon(Icons.add),
          ),
        ),
        ),

      ),
    );
  }
}
*/
class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'age' : age,
      'birthday': birthday,
    };
  static User fromJson(Map<String, dynamic>json) => User(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    birthday: (json['birthday'] as Timestamp).toDate(),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  Future<User?> readSingleUser() async{
    //Get Single document by ID
    final docUser = FirebaseFirestore.instance.collection('Users').doc('AwN9QlstFtOh7P2EApdr');
    final snapshot = await docUser.get();
    if(snapshot.exists) {
      return User.fromJson(snapshot.data()!); //Why using !??
    }
  }
  Stream<List<User>> readUsers() => FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) =>
     snapshot.docs.map((doc)=> User.fromJson(doc.data())).toList());

Widget buildUser(User user) => ListTile(
  leading: CircleAvatar(child: Text('${user.age}'),),
  title: Text(user.name),
  subtitle: Text(user.birthday.toIso8601String()),
);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CRUD"),
        ),
      //Reading Single User
        body: Column(
          children: [
            FutureBuilder<User?>(
              future: readSingleUser(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text("Something went wrong! ${snapshot.error}");
                }
                else if(snapshot.hasData){
                  final user = snapshot.data;
                  return user!=null?buildUser(user):Center(child: Text('No User'));
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),

            //Update Data
            SizedBox(height: 15,),
            ElevatedButton(
                onPressed: () {
                 final docUser = FirebaseFirestore.instance.collection('users').doc('AwN9QlstFtOh7P2EApdr');
                 //Update Specific fields
                  docUser.update({
                    'name': 'Noorshaba',
                    //'name': FieldValue.delete(), ->Deletes the field
                  }
                  );
                  //If you have nested values in document u can use dot notation like 'city.name':'Sydney'

                  //Replace with new data
                /*  docUser.set({
                    'name': 'Noor',
                  });*/
                },
                style: ElevatedButton.styleFrom(
                  elevation: 20,  // Elevation
                  shadowColor: Colors.grey[300], //
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Update", style: TextStyle(fontSize: 20),)
            ),

            //For deleting data
            SizedBox(height: 15,),
/*            ElevatedButton(
                onPressed: () {
                  final docUser = FirebaseFirestore.instance.collection('users').doc('AwN9QlstFtOh7P2EApdr');
                  docUser.delete();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 20,  // Elevation
                  shadowColor: Colors.grey[300], //
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Delete", style: TextStyle(fontSize: 20),)
            ),*/
          ],
        ),






/*      If you don't want real time data changes u can use here FutureBuilder,
        after doing future u will see the changes when u perform hot reload*/
      //Reading All Users
/*        body: StreamBuilder<List<User>>(
          stream: readUsers(),
          //future: readUsers().first, //Why first?
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error}");
            }
            else if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(
                children: users.map(buildUser).toList(),
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          }
        ),*/
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddUserPage()));
              },
        );
      }),

      ),
    );
  }
}
