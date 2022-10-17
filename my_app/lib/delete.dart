import 'package:flutter/material.dart';
import 'contact.dart';

class DeleteContact extends StatefulWidget {
  const DeleteContact({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<DeleteContact> createState() => _DeleteContactState();
}

class _DeleteContactState extends State<DeleteContact> {
  late Future<Contact> _futureContact;

  @override
  void initState() {
    _futureContact = getContactDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Contact'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder<Contact>(
              future: _futureContact,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Delete ${snapshot.data!.contactName}?',
                            style: const TextStyle(fontSize: 20)),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _futureContact = deleteContact(
                                    snapshot.data!.contactId.toString());
                              });
                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text('Confirm')),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          //ElevatedButton(
          //onPressed: () {
          //Navigator.pop(
          // context,
          //);
          //},
          //child: const Text('Back to Home')),
        ],
      ),
    );
  }
}
