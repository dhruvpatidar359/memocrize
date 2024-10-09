import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

Future<void> downloadFiles(Map<String, dynamic> jsonData) async {
  // Parse the JSON data
  final Map<String, dynamic> parsedData = jsonData;

  // Get the internal storage directory to save files
  final Directory? internalStorageDir = await getExternalStorageDirectory();

  if (internalStorageDir == null) {
    print('Unable to access internal storage.');
    return;
  }

  // Iterate over each key (collection) in the parsed data
  for (String collection in parsedData.keys) {
    final List<dynamic> files = parsedData[collection];

    // Create a directory for each collection in the internal storage
    final appDocDir = await getApplicationDocumentsDirectory();
    final collectionsDir = Directory('${appDocDir.path}/Collections/${collection}');
    if (!await collectionsDir.exists()) {
      await collectionsDir.create(recursive: true);
    }

    // Download each file for the collection
    for (var file in files) {
      final String fileName = file['data']['fileName'];
      final String fileUrl = file['data']['fileUrl'];
      final String filePath;
      if(file['data']['datatype'] == 'text'){
        filePath = p.join(collectionsDir.path, fileName + '.txt');
      }
      else{
        filePath = p.join(collectionsDir.path, fileName+ '.jpeg');
      }


      try {
        // Send HTTP request to download the file
        final http.Response response = await http.get(Uri.parse(fileUrl));

        // Check if the response is successful
        if (response.statusCode == 200) {
          // Save the file locally
          final File localFile = File(filePath);
          await localFile.writeAsBytes(response.bodyBytes);
          print('Downloaded: $fileName for $collection');
        } else {
          print('Failed to download $fileName: ${response.statusCode}');
        }
      } catch (e) {
        print('Error downloading $fileName for $collection: $e');
      }
    }
  }

  print('All files downloaded to: ${internalStorageDir.path}');
}
