//TODO: #1 @anadreau create isolate function to download yt videos
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

final mediaDownloaderCreator = Creator((ref) async {
  String downloadUrl = '';
  String fileSavePath = '';
  final ytDownloadCmd = 'yt-dlp.exe -P $fileSavePath $downloadUrl';

  final result = await Isolate.run(
      () => Process.start('pwershell.exe', ['-Command', ytDownloadCmd]));

  ///cmd yt-dlp.exe -P C:\Users\anadr\Videos\download *url*
});
