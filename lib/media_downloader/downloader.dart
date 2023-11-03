import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_downloader/utils/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[StateProvider] holds [String] of video url.
final downloadUrlProvider = StateProvider((ref) => '');

///[StateProvider] holds [List<String>] of command line output
///of yt-dlp.exe cmd
final resultProvider = StateProvider<String>((ref) => '');

///[StateProvider] holds [String?] of folder path that video
///will be downloaded to.
final folderSavePathProvider = StateProvider<String?>((ref) => '');

///Function to run yt-dlp.exe cmd based on [downloadUrlProvider]
///and [folderSavePathProvider]
Future<void> mediaDownloader(WidgetRef ref) async {
  final downloadUrl = ref.read(downloadUrlProvider.notifier).state;
  final fileSavePath = ref.read(folderSavePathProvider.notifier).state;
  final ytDownloadCmd = '$downloadUrl -o $fileSavePath\\video';
  log('cmd - $ytDownloadCmd');
  ref
      .read(conversionStatusProvider.notifier)
      .update((state) => Status.inProgress);

  final result = await Isolate.run(
    () => Process.start(
      'powershell.exe',
      ['-Command', 'yt-dlp', ytDownloadCmd],
    ),
  );
  log('result: ${result.stderr}');
  log('Exitcode: ${await result.exitCode}');
  //TO-DO: #14 Changing Process.runsync to Process.start @anadreau

  /*
  Changing Process.runsync to Process.start
  Need to change logic below so the status.error doesn't change each time a new
  line is sent through the pipe. 
  */
  //process.stdout.transform(utf8.decoder).forEach(print);
  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
  if (result.stderr.toString().isNotEmpty) {
    final error = result.stderr.toString();
    log('error is $error');
    ref.read(conversionStatusProvider.notifier).update((state) => Status.error);

    ref.read(resultProvider.notifier).update((state) => error);
  }
  if (result.stdout.toString().isNotEmpty) {
    final status = result.stdout.toString();
    log('status: $status');
    ref.read(conversionStatusProvider.notifier).update((state) => Status.done);

    ref.read(resultProvider.notifier).update((state) => status);
  }
}
