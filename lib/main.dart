import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey of Spirits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Possible spirits names'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(doc['name'])),
          Container(
            decoration: const BoxDecoration(color: Colors.red),
            padding: const EdgeInsets.all(10),
            child: Text(doc['votes '].toString()),
          )
        ],
      ),
      onTap: () {
        print("increase votes here");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("bandnames").snapshots(),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return const Text("Loading...");
          }
          return ListView.builder(
            itemExtent: 80,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        }
      ),
     );
  }
}
