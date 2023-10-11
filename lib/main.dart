import 'package:flutter/material.dart';
import 'package:flutter_downloader/folder_selector/folder_selector.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';
import 'package:flutter_downloader/utils/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  //TO-DO: #10 Implement Very_Good analysis.
  //TO-DO: #11 Add ability to check for and
  //install yt-dlp.exe if it is missing. @anadreau
  runApp(const ProviderScope(child: DownloaderApp()));
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
        restorationScopeId: 'neededForWindowsRelease',
        home: Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                  child: TextFormField(
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
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DownloadButton(
                      formKey: formKey,
                      youtubeUrlController: youtubeUrlController),
                  const SelectFolderButton()
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const StatusText(),
              const SizedBox(height: 15),
              const Center(child: Text('output')),
              const Padding(
                padding: EdgeInsets.fromLTRB(75, 0, 75, 15),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Expanded(
                flex: 1,
                child: ItemListView(),
              ),
            ],
          ),
        )));
  }
}

class SelectFolderButton extends ConsumerWidget {
  const SelectFolderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () {
        folderSelector(ref);
      },
      child: const Icon(Icons.folder),
    );
  }
}

class StatusText extends ConsumerWidget {
  const StatusText({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(ref.watch(statusProvider)),
        ));
  }
}

class ItemListView extends ConsumerWidget {
  const ItemListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        for (var item in ref.watch(resultProvider))
          Padding(
            padding: const EdgeInsets.fromLTRB(75, 0, 75, 15),
            child: Text(item),
          ),
      ],
    );
  }
}

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.formKey,
    required this.youtubeUrlController,
  });

  final GlobalKey<FormFieldState> formKey;
  final TextEditingController youtubeUrlController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          ref
              .read(downloadUrlProvider.notifier)
              .update((state) => youtubeUrlController.text.trimRight());

          mediaDownloader(ref);
        }
      },
      child: const Text('Download'),
    );
  }
}
