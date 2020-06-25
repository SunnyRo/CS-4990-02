import 'package:TodoList/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.orange),
      home: LoginPage(),
    ));

class MyApp extends StatefulWidget {
  String uid;
  MyApp(this.uid);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String todoTitle = '';
  createTodos() {
    DocumentReference documentReference = Firestore.instance
        .collection("Users")
        .document(widget.uid)
        .collection("Tasks")
        .document(todoTitle);
    Map<String, String> todos = {"todoTitle": todoTitle};
    documentReference.setData(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference = Firestore.instance
        .collection("Users")
        .document(widget.uid)
        .collection("Tasks")
        .document(item);
    documentReference.delete().whenComplete(() {
      print("$todoTitle deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📅 Todos list"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  title: Text("Add Todo list"),
                  content: TextField(
                    onChanged: (String value) {
                      todoTitle = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        createTodos();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    )
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("Users")
              .document(widget.uid)
              .collection("Tasks")
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.data == null) return Text('');
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.documents[index];
                  return Dismissible(
                    onDismissed: (direction) {
                      deleteTodos(documentSnapshot["todoTitle"]);
                    },
                    key: Key(documentSnapshot["todoTitle"]),
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        title: Text(documentSnapshot["todoTitle"]),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    title: new Text(
                                        'Mark "${documentSnapshot["todoTitle"]}" as done?'),
                                    actions: <Widget>[
                                      new FlatButton(
                                          child: new Text('CANCEL'),
                                          onPressed: () =>
                                              Navigator.of(context).pop()),
                                      new FlatButton(
                                          child: new Text('MARK AS DONE'),
                                          onPressed: () {
                                            deleteTodos(
                                                documentSnapshot["todoTitle"]);
                                            Navigator.of(context).pop();
                                          })
                                    ]);
                              });
                        },
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            deleteTodos(documentSnapshot["todoTitle"]);
                          },
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
