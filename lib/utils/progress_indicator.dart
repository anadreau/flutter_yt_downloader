import 'package:creator/creator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Enum for download status
enum Status { notStarted, inProgress, done, error }

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusProvider = StateProvider((ref) => Status.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusProvider = StateProvider((ref) {
  var status = ref.watch(conversionStatusProvider);
  String statusString;

  statusString = switch (status) {
    Status.notStarted => 'Download has not been started yet',
    Status.inProgress => 'Download in Progress',
    Status.done => 'Download has been Completed',
    Status.error => 'Error Downloading Video'
  };

  return statusString;
});
