import 'package:location/location.dart';

Location location = Location();
late LocationData locationData;

Future<void> locationService(Future<void> function) async {
  bool _serviceGranted;
  PermissionStatus _permissionStatus;
  _serviceGranted = await location.serviceEnabled();
  if (!_serviceGranted) {
    _serviceGranted = await location.requestService();
    if (!_serviceGranted) {
      print("service is not granted");
    }
  }
  _permissionStatus = await location.hasPermission();
  if (_permissionStatus == PermissionStatus.denied) {
    _permissionStatus = await location.requestPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      print("permission is not granted");
    }
    print("permission granted");
  }
  function;
}
