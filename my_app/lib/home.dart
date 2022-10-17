import 'package:flutter/material.dart';
import 'package:my_app/addcontact.dart';
import 'package:my_app/contact.dart';
import 'package:my_app/delete.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/update.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Future<List<Contact>> contacts;
  final contactListKey = GlobalKey<_HomePage>();

  @override
  void initState() {
    super.initState();
    setState(() {
      contacts = getContactList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: SizedBox(
              height: 200.0,
              child: Center(
                  child: FutureBuilder<List<Contact>>(
                      future: contacts,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = snapshot.data[index];
                            return Card(
                                child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                data.contactName,
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                data.contactNumber,
                                style: const TextStyle(fontSize: 15),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        String id = data.contactId.toString();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DeleteContact(id: id);
                                        }));
                                      },
                                      child: Icon(CupertinoIcons.trash),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        String id = data.contactId.toString();
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UpdateContact(id: id);
                                        }));
                                      },
                                      child: Icon(CupertinoIcons.pencil),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                        );
                      })),
            )),
            Container(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddContact()),
                    );
                  },
                  child: const Text('Add Contact')),
            ),
          ],
        ),
      ),
    );
  }
}
