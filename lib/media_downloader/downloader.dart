import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_downloader/utils/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[StateProvider] holds [String] of video url.
final downloadUrlProvider = StateProvider((ref) => '');

///[StateProvider] holds [List<String>] of command line output
///of yt-dlp.exe cmd
final resultProvider = StateProvider<List<String>>((ref) => []);

///[StateProvider] holds [String?] of folder path that video
///will be downloaded to.
final folderSavePathProvider = StateProvider<String?>((ref) => '');

///Function to run yt-dlp.exe cmd based on [downloadUrlProvider]
///and [folderSavePathProvider]
Future<void> mediaDownloader(WidgetRef ref) async {
  final downloadUrl = ref.read(downloadUrlProvider);
  final fileSavePath = ref.read(folderSavePathProvider);
  final ytDownloadCmd = '-P $fileSavePath $downloadUrl';
  ref
      .read(conversionStatusProvider.notifier)
      .update((state) => Status.inProgress);

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', 'yt-dlp.exe', ytDownloadCmd, '| echo'],
    ),
  );

  //process.stdout.transform(utf8.decoder).forEach(print);
  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
  if (result.exitCode == 0) {
    final stdoutLog = result.stdout.toString();
    final stdoutList = stdoutLog.split('\n');
    ref.read(resultProvider.notifier).update((state) => stdoutList);
    if (result.stderr.toString().isNotEmpty) {
      ref
          .read(conversionStatusProvider.notifier)
          .update((state) => Status.error);
    }
    if (result.stdout.toString().isNotEmpty) {
      ref
          .read(conversionStatusProvider.notifier)
          .update((state) => Status.done);
    }
  } else {
    ref.read(conversionStatusProvider.notifier).update((state) => Status.error);
    log('Downloader encountered an error: ${result.exitCode}');
  }
}
