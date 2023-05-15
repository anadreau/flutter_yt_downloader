import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:flutter_downloader/utils/progress_indicator.dart';

final downloadUrlCreator = Creator((p0) => '');

final resultCreator = Creator((ref) => []);

final folderSavePathCreator = Creator((ref) => '');

final mediaDownloaderCreator = Creator<void>((ref) async {
  String downloadUrl = ref.read(downloadUrlCreator);
  String fileSavePath = ref.read(folderSavePathCreator);
  final ytDownloadCmd = '-P $fileSavePath $downloadUrl';
  ref.set(conversionStatusCreator, Status.inProgress);

  final result = await Isolate.run(() => Process.runSync(
      'powershell.exe', ['-Command', 'yt-dlp.exe', ytDownloadCmd, '| echo']));

  //process.stdout.transform(utf8.decoder).forEach(print);
  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
  if (result.exitCode == 0) {
    String stdoutLog = result.stdout;
    List<String> stdoutList = stdoutLog.split('\n');
    ref.set(resultCreator, stdoutList);
    if (result.stderr.toString().isNotEmpty) {
      ref.set(conversionStatusCreator, Status.error);
    }
    if (result.stdout.toString().isNotEmpty) {
      ref.set(conversionStatusCreator, Status.done);
    }
  } else {
    ref.set(conversionStatusCreator, Status.error);
    log(result.exitCode.toString());
  }
});


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
