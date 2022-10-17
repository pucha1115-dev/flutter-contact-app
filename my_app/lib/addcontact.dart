import 'package:flutter/material.dart';
import 'contact.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerContactNumber =
      TextEditingController();

  Future<Contact>? _futureContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child:
                (_futureContact == null) ? buildColumn() : buildFutureBuilder(),
          ),
        ],
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controllerContactName,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        TextField(
          controller: _controllerContactNumber,
          decoration: const InputDecoration(hintText: 'Enter Contact Number'),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _futureContact = createContact(
                    _controllerContactName.text, _controllerContactNumber.text);
              });
            },
            child: const Text('Add Contact'),
          ),
        ),
      ],
    );
  }

  FutureBuilder<Contact> buildFutureBuilder() {
    return FutureBuilder<Contact>(
      future: _futureContact,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const Text('Successfully Added'),
              Text('''
                    Name: ${snapshot.data!.contactName}
                    Contact Number: ${snapshot.data!.contactNumber}
              '''),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
