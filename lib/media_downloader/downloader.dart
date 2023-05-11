import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

final downloadUrlCreator =
    Creator((p0) => 'www.youtube.com/watch?v=8Iwdwn3PUug');

final resultCreator = Creator((ref) => []);

final folderSavePathCreator = Creator((ref) => '');

final mediaDownloaderCreator = Creator<void>((ref) async {
  String downloadUrl = ref.read(downloadUrlCreator);
  String fileSavePath = ref.read(folderSavePathCreator);
  final ytDownloadCmd = '-P $fileSavePath $downloadUrl';

  final result = await Isolate.run(() => Process.runSync('powershell.exe',
      ['-Command', 'yt-dlp.exe', '-P', fileSavePath, downloadUrl, '| echo']));

  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
  if (result.exitCode == 0) {
    log(result.stdout);
    String stdoutLog = result.stdout;
    List<String> stdoutList = stdoutLog.split('\n');
    ref.set(resultCreator, stdoutList);
    log('Finished');
  } else {
    log('Finished but exit code missed.');
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
