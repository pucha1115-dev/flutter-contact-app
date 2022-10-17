import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Contact>> getContactList() async {
  final response =
      await http.get(Uri.parse('http://192.168.8.100:8000/contacts'));

  final items = json.decode(response.body).cast<Map<String, dynamic>>();
  List<Contact> contacts = items.map<Contact>((json) {
    return Contact.fromJson(json);
  }).toList();

  return contacts;
}

Future<Contact> getContactDetails(String id) async {
  //final Id = int.parse(id);

  final response =
      await http.get(Uri.parse('http://192.168.8.100:8000/contacts/$id'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Contact.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load contact');
  }
}

Future<Contact> createContact(String contactName, String contactNumber) async {
  final response = await http.post(
    Uri.parse('http://192.168.8.100:8000/contacts/'),
    headers: <String, String>{
      //'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'ContactName': contactName,
      'ContactNumber': contactNumber,
    }),
  );

  if (response.statusCode == 200) {
    return Contact.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to add');
  }
}

Future<Contact> updateContact(
    String id, String contactName, String contactNumber) async {
  final response = await http.put(
    Uri.parse('http://192.168.8.100:8000/contacts/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'ContactName': contactName,
      'ContactNumber': contactNumber,
    }),
  );

  if (response.statusCode == 200) {
    print(response.body);
    return Contact.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to uddate.');
  }
}

Future<Contact> deleteContact(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://192.168.8.100:8000/contacts/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    print(response.body);
    return Contact.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a "200 OK response",
    // then throw an exception.
    throw Exception('Failed to delete contact.');
  }
}

class Contact {
  final int contactId;
  final String contactName;
  final String contactNumber;

  Contact(
      {required this.contactId,
      required this.contactName,
      required this.contactNumber});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
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
