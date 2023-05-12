import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/folder_selector/folder_selector.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';
import 'package:flutter_downloader/utils/progress_indicator.dart';

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
                      ref.set(downloadUrlCreator,
                          youtubeUrlController.text.trimRight());

                      ref.read(mediaDownloaderCreator);
                    }
                  },
                  child: const Text('Download'),
                )),
            Watcher((context, ref, child) => MaterialButton(
                  onPressed: () {
                    ref.read(folderSelectorCreator);
                  },
                  child: const Icon(Icons.folder),
                ))
          ],
        ),
        //TODO: #4 add indicator for status of download. @anadreau
        Watcher((context, ref, child) => Container(
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(ref.watch(statusCreator)),
            ))),
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
