# flutter_location_test

## Preparation

⚠️ Supported platforms: Android

1. Add the following permissions to your AndroidManifest.xml file:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
+   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
+   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
+   <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <application
        android:label="flutter_location_test"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
...
```

2. Add packages:

I want to fetch location data when the app is in the background, so I adopted the following package:

```bash
flutter pub add location
```

## Fetch function

```dart
Future<bool> enableLocationPermission() async {
  Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<LocationData> getLocation() async {
  Location location = Location();
  LocationData data = await location.getLocation();
  return data;
}
```

## Usage

```dart
final status = await enableLocationPermission();
if (status) {
    final data = await getLocation();
}
```
