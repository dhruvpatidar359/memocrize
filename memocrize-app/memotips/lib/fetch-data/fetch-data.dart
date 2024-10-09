import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:memotips/fetch-data/download-data.dart';

void fetchData() async {

  var request = http.Request(
    'GET',
    Uri.parse('https://memocrize.onrender.com/fetch/snapshot'),
  );

  // Set headers if needed
  request.headers.addAll({
    'Content-Type': 'application/json',
  });

  // Set the body of the request
  request.body = jsonEncode({
    "userId": "someshsp25",
  });

  try {
    // Send the request and wait for the response
    http.StreamedResponse response = await request.send();

    // Parse the response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      var parsedData = jsonDecode(responseBody);
      print('Parsed Data: $parsedData');
      downloadFiles(parsedData);
    } else {
      print('Failed to fetch data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}