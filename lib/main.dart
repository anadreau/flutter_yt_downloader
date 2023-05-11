import 'dart:developer';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/folder_selector/folder_selector.dart';

void main() {
  runApp(CreatorGraph(child: const DownloaderApp()));
}

class DownloaderApp extends StatelessWidget {
  const DownloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextFormField(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    log('Download pressed');
                  },
                  child: const Text('Download'),
                ),
                Watcher((context, ref, child) => MaterialButton(
                      onPressed: () {
                        log('Folder pressed');
                        ref.read(folderSelectorCreator);
                      },
                      child: const Icon(Icons.folder),
                    ))
              ],
            ),
          ],
        ),
      ),
    )));
  }
}
