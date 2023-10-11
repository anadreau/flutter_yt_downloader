import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

folderSelector(WidgetRef ref) async {
  String? selectedFolder = await FilePicker.platform.getDirectoryPath();

  ref.read(folderSavePathProvider.notifier).update((state) => selectedFolder);
}
