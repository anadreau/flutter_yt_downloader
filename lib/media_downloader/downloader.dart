import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_downloader/utils/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloadUrlProvider = StateProvider((ref) => '');

final resultProvider = StateProvider((ref) => []);

final folderSavePathProvider = StateProvider<String?>((ref) => '');

mediaDownloader(WidgetRef ref) async {
  String downloadUrl = ref.read(downloadUrlProvider);
  String? fileSavePath = ref.read(folderSavePathProvider);
  final ytDownloadCmd = '-P $fileSavePath $downloadUrl';
  ref
      .read(conversionStatusProvider.notifier)
      .update((state) => Status.inProgress);

  final result = await Isolate.run(() => Process.runSync(
      'powershell.exe', ['-Command', 'yt-dlp.exe', ytDownloadCmd, '| echo']));

  //process.stdout.transform(utf8.decoder).forEach(print);
  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
  if (result.exitCode == 0) {
    String stdoutLog = result.stdout;
    List<String> stdoutList = stdoutLog.split('\n');
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
    log('Downloader encountered an error: ${result.exitCode.toString()}');
  }
}


///Alternative
///import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// Future<void> downloadVideo(String videoId) async {
//   // Create a YoutubeExplode instance.
//   final yt = YoutubeExplode();

//   // Get the video information.
//   final videoInfo = await yt.getVideoInfo(videoId);

//   // Get the video stream.
//   final videoStream = await yt.getVideoStream(videoId, videoInfo.streams.first);

//   // Create a file to store the video.
//   final file = File('video.mp4');

//   // Write the video to the file.
//   await file.writeAsBytes(videoStream);
// }
