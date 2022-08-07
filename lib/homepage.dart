// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project2/connection/database_connection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';

import 'Model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // get the data from textfield
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  // db is the object of class DatabaseConnection
  late DatabaseConnection db;
  //Future<List<User>>? is the function to get data as a list
  // listUser variable of Future<List<User>>?
  Future<List<User>>? listUser;

  @override
  // initstate use for process the data into screen after refresh or open the app
  void initState() {
    super.initState();
    print('Start state');
    db = DatabaseConnection();
    db.initializeUserDB().whenComplete(() async {
      setState(() {
        listUser = db.getUser();
      });
      print(listUser!.then((value) => value.first.name.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite '),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                hintText: '  Input User ID',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                hintText: '  Input Username',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseConnection()
                  .insertUser(User(
                      id: int.parse(controller1.text), name: controller2.text))
                  .whenComplete(() {
                print('insert success');
              });
            },
            //color: Colors.blue,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Container(
            height: 400,
            width: double.infinity,
            child: FutureBuilder(
              future: listUser,
              // snapshot is the object of AsyncSnapshot<List<User>>, that we create in order to show the error info
              builder: (context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return snapshot.hasError
                    ? const Center(
                        child: Icon(
                          Icons.info,
                          color: Colors.red,
                          size: 28,
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var item = snapshot.data![index];
                          return InkWell(
                            onLongPress: () async {
                              await DatabaseConnection()
                                  .deleteuser(item.id)
                                  .whenComplete(() {
                                setState(() {
                                  print('Delete Success');
                                });
                              });
                            },
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(item.id.toString()),
                                ),
                                title: Text(item.name.toString()),
                                //subtitle: Text(item.name),
                              ),
                            ),
                          );
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}
