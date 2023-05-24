
//work in progress
// Get the URL of the media you want to download.
  import 'dart:io';

import 'package:http/http.dart';

const String url = 'https://example.com/media.mp4';

  // Create a new `HttpClient` object.
  final HttpClient client = HttpClient();

  // Create a new `StreamedResponse` object from the `HttpClient` object.
  final StreamedResponse response = await client.get(Uri.parse(url));

  // Create a new `File` object to save the media to.
  final File file = File('media.mp4');

  // Write the data from the `StreamedResponse` object to the `File` object.
  await response.pipe(file.openWrite Function() Function );

  // Close the `File` object.
  await file.close();