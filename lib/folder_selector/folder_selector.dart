import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/media_downloader/downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Awaits the Directory Path dependant on platform, then sets
///[folderSavePathProvider] to that path [String?].
Future<void> folderSelector(WidgetRef ref) async {
  final selectedFolder = await FilePicker.platform.getDirectoryPath();

  ref.read(folderSavePathProvider.notifier).update((state) => selectedFolder);
}
