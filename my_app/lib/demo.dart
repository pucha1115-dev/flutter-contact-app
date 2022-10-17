import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(String id) async {
  final response = await http.get(
    Uri.parse('http://192.168.8.100:8000/contacts/$id'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Album> updateAlbum(
    String id, String contactName, String contactNumber) async {
  final response = await http.put(
    Uri.parse('http://192.168.8.100:8000/contacts/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'ContactName': contactName,
      'ContactNumber': contactNumber
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update album.');
  }
}

class Album {
  final int contactId;
  final String contactName;
  final String contactNumber;

  const Album(
      {required this.contactId,
      required this.contactName,
      required this.contactNumber});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      contactId: json['ContactId'],
      contactName: json['ContactName'],
      contactNumber: json['ContactNumber'],
    );
  }

  //Map<String, dynamic> toJson() => {
  //'contactId': contactId,
  // 'contactName': contactName,
  // 'contactNumber': contactNumber,
  //};
}

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final TextEditingController _controllerContactName = TextEditingController();
  final TextEditingController _controllerContactNumber =
      TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum('23');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data!.contactName),
                      Text(snapshot.data!.contactNumber),
                      TextField(
                        controller: _controllerContactName,
                        decoration: const InputDecoration(
                          hintText: 'Enter Contact Name',
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
                            _futureAlbum = updateAlbum(
                                snapshot.data!.contactId.toString(),
                                _controllerContactName.text,
                                _controllerContactNumber.text);
                          });
                        },
                        child: const Text('Update Data'),
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
      ),
    );
  }
}
