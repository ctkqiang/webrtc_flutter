import 'dart:io';

class DeviceInfo {
  // * Get Local Hostname of Connected Device
  static String get label {
    return Platform.localHostname;
  }
}
