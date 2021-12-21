import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  static Future<void> sendPost() async {
    print('Sending...');

    final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': 'test',
          'body': 'bodeh',
          'userID': 100
        }));

    print(response.statusCode);
    print(response.body);
  }
}
