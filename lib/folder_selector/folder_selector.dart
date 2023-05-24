import 'package:creator/creator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/media_downloader/yt_downloader.dart';

final folderSelectorCreator = Creator((ref) async {
  String? selectedFolder = await FilePicker.platform.getDirectoryPath();

  ref.set(folderSavePathCreator, selectedFolder);
});
