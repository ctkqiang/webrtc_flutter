import 'package:simple_permissions/simple_permissions.dart';
// & Reference : johnmelody_dev [john.cheng@mynapse.com]
// & FOR IMPLEMENTATION PLEASE REFER TO DOCUMENTATION IN NAMED
// & 'permission_readme.pdf' WHERE IT LOCATED IN THE SAME
// & DIRECTORY .

enum RequestPermissionState {
  Camera,
  ReadContacts,
  WriteContacts,
  ReadExternalStorage,
  ReadSms,
  SendSMS,
  AccessCoarseLocation,
  AccessFineLocation,
  RecordAudio,
  AlwaysLocation,
  PhotoLibrary,
}

// * @param Android permission_type:
// * @param 0; The Location Permission Should called both case 6 & 7;
// * Please <b>DO REMEMBER</b> to declare in `AndroidManifest.xml` if havent already.

// +-----+----------------------+
// | int | permissionType       |
// +-----+----------------------+
// |  0  | camera               |
// +-----+----------------------+
// |  1  | ReadContacts         |
// +-----+----------------------+
// |  2  | WriteContacts        |
// +-----+----------------------+
// |  3  | ReadExternalStorage  |
// +-----+----------------------+
// |  4  | ReadSms              |
// +-----+----------------------+
// |  5  | SendSMS              |
// +-----+----------------------+
// |  6  | AccessCoarseLocation |
// +-----+----------------------+
// |  7  | AccessFineLocation   |
// +-----+----------------------+
// |  8  | RecordAudio          |
// +-----+----------------------+
// |  9  | ReadPhoneState       |
// +-----+----------------------+
// |  10 | WriteExternalStorage |
// +-----+----------------------+
// |  11 | Vibrate              |
// +-----+----------------------+
// |  12 | AccessMotionSensor   |
// +-----+----------------------+
// |  13 | CallPhone            |
// +-----+----------------------+

// * @param IOS permission_type:
// * @param 1; The Location Permission Should called both case 6 & 8;
// * Please <b>DO REMEMBER</b> to declare in `info.plist` if havent already.

// +-----+-------------------+
// | int | permissionType    |
// +-----+-------------------+
// |  0  | camera            |
// +-----+-------------------+
// |  1  | ReadContacts      |
// +-----+-------------------+
// |  2  | WriteContacts     |
// +-----+-------------------+
// |  3  | PhotoLibrary      |
// +-----+-------------------+
// |  4  | ReadSms           |
// +-----+-------------------+
// |  5  | SendSMS           |
// +-----+-------------------+
// |  6  | AlwaysLocation    |
// +-----+-------------------+
// |  7  | RecordAudio       |
// +-----+-------------------+
// |  8  | WhenInUseLocation |
// +-----+-------------------+

typedef void OnRequestStateCallBack(
  RequestPermissionState state,
);

class UserPermission {
  OnRequestStateCallBack onRequestStateCallBack;
  String warning = 'Please Enter A valid Int Value!';
  bool status;
  int result;

  List<Permission> androidPermission = [
    Permission.Camera,
    Permission.ReadContacts,
    Permission.WriteContacts,
    Permission.ReadExternalStorage,
    Permission.ReadSms,
    Permission.SendSMS,
    Permission.AccessCoarseLocation,
    Permission.AccessFineLocation,
    Permission.RecordAudio,
    Permission.ReadPhoneState,
    Permission.WriteExternalStorage,
    Permission.Vibrate,
    Permission.AccessMotionSensor,
    Permission.CallPhone,
  ];

  List<Permission> iosPermission = [
    Permission.Camera,
    Permission.ReadContacts,
    Permission.WriteContacts,
    Permission.PhotoLibrary,
    Permission.ReadSms,
    Permission.SendSMS,
    Permission.AlwaysLocation,
    Permission.RecordAudio,
    Permission.WhenInUseLocation,
  ];

  // * @param platform:
  // * +-----+----------+
  // * | int | platform |
  // * +-----+----------+
  // * | [0] | Android  |
  // * | [1] | IOS      |
  // * +-----+----------+
  Future<void> permissionStatus(int platform) async {
    if (platform == 0) {
      status = await SimplePermissions.checkPermission(androidPermission[0]);
      status = await SimplePermissions.checkPermission(androidPermission[1]);
      status = await SimplePermissions.checkPermission(androidPermission[2]);
      status = await SimplePermissions.checkPermission(androidPermission[3]);
      status = await SimplePermissions.checkPermission(androidPermission[4]);
      status = await SimplePermissions.checkPermission(androidPermission[5]);
      status = await SimplePermissions.checkPermission(androidPermission[6]);
      status = await SimplePermissions.checkPermission(androidPermission[7]);
      status = await SimplePermissions.checkPermission(androidPermission[8]);
      status = await SimplePermissions.checkPermission(androidPermission[9]);
      status = await SimplePermissions.checkPermission(androidPermission[10]);
      status = await SimplePermissions.checkPermission(androidPermission[11]);
      status = await SimplePermissions.checkPermission(androidPermission[12]);
      status = await SimplePermissions.checkPermission(androidPermission[13]);
      result = 0;
    } else if (platform == 1) {
      status = await SimplePermissions.checkPermission(iosPermission[0]);
      status = await SimplePermissions.checkPermission(iosPermission[1]);
      status = await SimplePermissions.checkPermission(iosPermission[2]);
      status = await SimplePermissions.checkPermission(iosPermission[3]);
      status = await SimplePermissions.checkPermission(iosPermission[4]);
      status = await SimplePermissions.checkPermission(iosPermission[5]);
      status = await SimplePermissions.checkPermission(iosPermission[6]);
      status = await SimplePermissions.checkPermission(iosPermission[7]);
      status = await SimplePermissions.checkPermission(iosPermission[8]);
      result = 1;
    }
  }

  Future<void> requestPermission(int platform, int permissionType) async {
    // * @param 0; The Location Permission Should called both case 6 & 7;
    // & Please <b>DO REMEMBER</b> to declare in `AndroidManifest.xml` if haven't already.

    if (platform == 0) {
      permissionStatus(0);

      switch (permissionType) {
        case 0:
          await SimplePermissions.requestPermission(androidPermission[0]);
          break;

        case 1:
          await SimplePermissions.requestPermission(androidPermission[1]);
          break;

        case 2:
          await SimplePermissions.requestPermission(androidPermission[2]);
          break;

        case 3:
          await SimplePermissions.requestPermission(androidPermission[3]);
          break;

        case 4:
          await SimplePermissions.requestPermission(androidPermission[4]);
          break;

        case 5:
          await SimplePermissions.requestPermission(androidPermission[5]);
          break;

        case 6:
          await SimplePermissions.requestPermission(androidPermission[6]);
          break;

        case 7:
          await SimplePermissions.requestPermission(androidPermission[7]);
          break;

        case 8:
          await SimplePermissions.requestPermission(androidPermission[8]);
          break;

        case 9:
          await SimplePermissions.requestPermission(androidPermission[9]);
          break;

        case 10:
          await SimplePermissions.requestPermission(androidPermission[10]);
          break;

        case 11:
          await SimplePermissions.requestPermission(androidPermission[11]);
          break;

        case 12:
          await SimplePermissions.requestPermission(androidPermission[12]);
          break;

        case 13:
          await SimplePermissions.requestPermission(androidPermission[13]);
          break;

        default:
          break;
      }
    } else if (platform == 1) {
      // * @param 1; The Location Permission Should called both case 6 & 8;
      // & Please <b>DO REMEMBER</b> to declare in `info.plist` if haven't already.
      switch (permissionType) {
        case 0:
          await SimplePermissions.requestPermission(iosPermission[0]);
          break;

        case 1:
          await SimplePermissions.requestPermission(iosPermission[1]);
          break;

        case 2:
          await SimplePermissions.requestPermission(iosPermission[2]);
          break;

        case 3:
          await SimplePermissions.requestPermission(iosPermission[3]);
          break;

        case 4:
          await SimplePermissions.requestPermission(iosPermission[4]);
          break;

        case 5:
          await SimplePermissions.requestPermission(iosPermission[5]);
          break;

        case 6:
          await SimplePermissions.requestPermission(iosPermission[6]);
          break;

        case 7:
          await SimplePermissions.requestPermission(iosPermission[7]);
          break;

        case 8:
          await SimplePermissions.requestPermission(iosPermission[8]);
          break;

        default:
          break;
      }
    } else {
      throw ('$warning');
    }
  }

  Future<void> getPlatformPermission(int platform, int permissionType) async {
    switch (platform) {
      case 0:
        permissionStatus(0).then((value) {
          return requestPermission(0, permissionType);
        });
        break;

      case 1:
        permissionStatus(1).then((value) {
          return requestPermission(1, permissionType);
        });
        break;

      default:
        throw ('$warning');
        break;
    }
  }
}
