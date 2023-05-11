import 'dart:developer';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/folder_selector/folder_selector.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';

void main() {
  runApp(CreatorGraph(child: const DownloaderApp()));
}

class DownloaderApp extends StatefulWidget {
  const DownloaderApp({super.key});

  @override
  State<DownloaderApp> createState() => _DownloaderAppState();
}

class _DownloaderAppState extends State<DownloaderApp> {
  var formKey = GlobalKey<FormFieldState>();

  final youtubeUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          key: formKey,
          controller: youtubeUrlController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a valid YouTube URL.';
            }
            try {
              Uri.parse(value).host;
            } catch (e) {
              return 'Invalid YouTube URL';
            }
            if (!value.contains('youtube.com/')) {
              return 'Invalid YouTube URL';
            }

            return null;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Watcher((context, ref, child) => MaterialButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      log('form validated');
                      ref.set(downloadUrlCreator,
                          youtubeUrlController.text.trimRight());
                      log('Download pressed');
                      ref.read(mediaDownloaderCreator);
                    }
                  },
                  child: const Text('Download'),
                )),
            Watcher((context, ref, child) => MaterialButton(
                  onPressed: () {
                    log('Folder pressed');
                    ref.read(folderSelectorCreator);
                  },
                  child: const Icon(Icons.folder),
                ))
          ],
        ),
        Expanded(
          child: Watcher((context, ref, child) {
            return ListView(
              children: [
                const Center(child: Text('output')),
                for (var item in ref.watch(resultCreator)) Text(item),
              ],
            );
          }),
        ),
      ],
    )));
  }
}

//TODO: #2 @anadreau Add text form field to input yt url to download