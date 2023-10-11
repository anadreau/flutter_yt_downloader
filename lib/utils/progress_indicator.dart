import 'package:flutter_riverpod/flutter_riverpod.dart';

///Enum for download status
enum Status {
  ///When [Status] is not started.
  notStarted,

  ///When [Status] is in progress.
  inProgress,

  ///When [Status] is completed.
  done,

  ///When [Status] returns an error.
  error,
}

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusProvider = StateProvider((ref) => Status.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusProvider = StateProvider((ref) {
  final status = ref.watch(conversionStatusProvider);

  return switch (status) {
    Status.notStarted => 'Download has not been started yet',
    Status.inProgress => 'Download in Progress',
    Status.done => 'Download has been Completed',
    Status.error => 'Error Downloading Video'
  };
});
