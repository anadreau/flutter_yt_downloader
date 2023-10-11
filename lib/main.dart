import 'package:flutter/material.dart';
import 'package:flutter_downloader/folder_selector/folder_selector.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';
import 'package:flutter_downloader/utils/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  //TO-DO: #11 Add ability to check for and
  //install yt-dlp.exe if it is missing. @anadreau
  runApp(const ProviderScope(child: DownloaderApp()));
}

///Root of application.
class DownloaderApp extends StatefulWidget {
  ///Implementation of [DownloaderApp]
  const DownloaderApp({super.key});

  @override
  State<DownloaderApp> createState() => _DownloaderAppState();
}

class _DownloaderAppState extends State<DownloaderApp> {
  GlobalKey<FormFieldState<dynamic>> formKey =
      GlobalKey<FormFieldState<dynamic>>();

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
                    youtubeUrlController: youtubeUrlController,
                  ),
                  const SelectFolderButton(),
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
                child: OutputView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///[ConsumerWidget] that gives ref to button that selects folder
///that file will be downloaded to.
class SelectFolderButton extends ConsumerWidget {
  ///Implementation of[SelectFolderButton]
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

///[ConsumerWidget] that gives [Text] widget access to [statusProvider]
class StatusText extends ConsumerWidget {
  ///Implementation of [StatusText]
  const StatusText({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(ref.watch(statusProvider)),
      ),
    );
  }
}

///[ConsumerWidget] that gives access to [resultProvider]
class OutputView extends ConsumerWidget {
  ///Implementation of [OutputView]
  const OutputView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.watch(resultProvider));
  }
}

///[ConsumerWidget] that gives access to [downloadUrlProvider] and
///downloads file on button press
class DownloadButton extends ConsumerWidget {
  ///Implementation of [DownloadButton]
  const DownloadButton({
    required this.formKey,
    required this.youtubeUrlController,
    super.key,
  });

  ///[GlobalKey] used in input validation.
  final GlobalKey<FormFieldState<dynamic>> formKey;

  ///[TextEditingController] used to track url input by user.
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
