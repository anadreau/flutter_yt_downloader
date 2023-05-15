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

  switch (status) {
    case Status.notStarted:
      statusString = 'Download has not been started yet';
      break;
    case Status.inProgress:
      statusString = 'Download in Progress';
      break;
    case Status.done:
      statusString = 'Download has been Completed';
      break;

    case Status.error:
      statusString = 'Error Downloading Video';
  }

  return statusString;
});
