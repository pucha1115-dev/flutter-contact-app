import 'package:flutter/material.dart';
import 'contact.dart';

class UpdateContact extends StatefulWidget {
  const UpdateContact({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerContactNumber =
      TextEditingController();
  late Future<Contact> _futureContact;

  @override
  void initState() {
    super.initState();
    _futureContact = getContactDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
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
                        Text('Name: ${snapshot.data!.contactName}'),
                        Text('Number: ${snapshot.data!.contactNumber}'),
                        TextField(
                          controller: _controllerContactName,
                          decoration: const InputDecoration(
                            hintText: 'Enter Name',
                          ),
                        ),
                        TextField(
                          controller: _controllerContactNumber,
                          decoration: const InputDecoration(
                            hintText: 'Enter Contact Name',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureContact = updateContact(
                                  snapshot.data!.contactId.toString(),
                                  _controllerContactName.text,
                                  _controllerContactNumber.text);
                              Navigator.pop(
                                context,
                              );
                            });
                          },
                          child: const Text('Update Contact'),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }
                return const CircularProgressIndicator();
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
