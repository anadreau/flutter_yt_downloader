import 'package:creator/creator.dart';

///Enum for download status
enum Status { notStarted, inProgress, done, error }

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusCreator = Creator.value(Status.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusCreator = Creator((ref) {
  var status = ref.watch(conversionStatusCreator);
  String statusString;

  statusString = switch (status) {
    Status.notStarted => 'Download has not been started yet',
    Status.inProgress => 'Download in Progress',
    Status.done => 'Download has been Completed',
    Status.error => 'Error Downloading Video'
  };

  return statusString;
});
