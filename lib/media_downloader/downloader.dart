//TODO: #1 @anadreau create isolate function to download yt videos
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

final downloadUrlCreator = Creator((p0) => '');

final folderSavePathCreator = Creator((p0) => '');

final mediaDownloaderCreator = Creator((ref) async {
  String downloadUrl = ref.read(downloadUrlCreator);
  String fileSavePath = ref.read(folderSavePathCreator);
  final ytDownloadCmd = 'yt-dlp.exe -P $fileSavePath $downloadUrl';

  final result = await Isolate.run(
      () => Process.start('pwershell.exe', ['-Command', ytDownloadCmd]));

  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
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
