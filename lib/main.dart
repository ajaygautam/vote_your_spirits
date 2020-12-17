import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            child: Text(doc['votes'].toString()),
          )
        ],
      ),
      onTap: () {
        print("TODO - increase votes here");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("bandnames").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading...");
            }
            print("Building list for ${snapshot.data.documents.length} names...");
            return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
              print("Building with isKeyboardVisible: $isKeyboardVisible");
              List<DocumentSnapshot> documents = snapshot.data.documents;
              List<Widget> spiritNameWidgets = documents.map((doc) => _buildListItem(context, doc)).toList();
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: EntryForm(),
                ),
              ]..addAll(spiritNameWidgets));
            });
          }),
    );
  }
}

class EntryForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
              enableSuggestions: true,
              autofillHints: [AutofillHints.name],
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              controller: _name,
              validator: (val) => val.isEmpty ? 'Please enter Name' : null,
              decoration: InputDecoration(hintText: 'Enter new Name')),
        ),
      ),
    );
  }
}
