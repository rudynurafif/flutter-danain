import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/button/button.dart';
import 'package:flutter_danain/widgets/text/subtitle.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class SearchLocation2 extends StatefulWidget {
  final String textButton;
  final VoidCallback nextAction;
  final TextEditingController? provinsi;
  final TextEditingController? kota;

  const SearchLocation2({
    Key? key,
    required this.textButton,
    required this.nextAction,
    this.provinsi,
    this.kota,
  }) : super(key: key);

  @override
  State<SearchLocation2> createState() => _SearchLocation2State();
}

class _SearchLocation2State extends State<SearchLocation2> {
  bool _isLoading = false;
  void checkLocationInfo() async {
    setState(() {
      _isLoading = true;
    });
    final loc.Location location = loc.Location();

    // Check if location services are enabled
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location services are disabled.");
        return;
      }
    }

    // Check if location permission is granted
    _permissionGranted = await Permission.location.status;
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await Permission.location.request();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission is not granted.");
        return;
      }
    }

    // Get current location
    loc.LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
      return;
    }

    // Use the geocoding package to reverse geocode based on latitude and longitude
    List<Placemark> placemarks = await placemarkFromCoordinates(
      currentLocation.latitude!,
      currentLocation.longitude!,
    );

    if (placemarks.isNotEmpty) {
      String cityName = placemarks[0].locality ?? '';
      String provinceName = placemarks[0].administrativeArea ?? '';
      String postalCode = placemarks[0].postalCode ?? '';

      print("Latitude: ${currentLocation.latitude}");
      print("Longitude: ${currentLocation.longitude}");
      print("City Name: $cityName");
      print("Province Name: $provinceName");
      print("Postal Code: $postalCode");
      if(provinceName == 'Daerah Khusus Ibukota Jakarta'){
        provinceName = 'jakarta';
      }
      if (widget.provinsi != null) {
        widget.provinsi?.text = provinceName;
      }
      if (widget.kota != null) {
        widget.kota?.text = cityName;
      }

      widget.nextAction();
    } else {
      print("No address information available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: Subtitle2(
              text: 'Mohon Tunggu',
              align: TextAlign.center,
            ),
          )
        : Button1(
            btntext: widget.textButton,
            action: checkLocationInfo,
          );
  }
}

void checkLocationInfo(TextEditingController? provinsiCon,
    TextEditingController? kotaCon, VoidCallback nextAction) async {
  final loc.Location location = loc.Location();

  // Check if location services are enabled
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      print("Location services are disabled.");
      return;
    }
  }

  // Check if location permission is granted
  _permissionGranted = await Permission.location.status;
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await Permission.location.request();
    if (_permissionGranted != PermissionStatus.granted) {
      print("Location permission is not granted.");
      return;
    }
  }

  // Get current location
  loc.LocationData currentLocation;
  try {
    currentLocation = await location.getLocation();
  } catch (e) {
    print("Error getting location: $e");
    return;
  }

  // Use the geocoding package to reverse geocode based on latitude and longitude
  List<Placemark> placemarks = await placemarkFromCoordinates(
    currentLocation.latitude!,
    currentLocation.longitude!,
  );

  if (placemarks.isNotEmpty) {
    String cityName = placemarks[0].locality ?? '';
    String provinceName = placemarks[0].administrativeArea ?? '';
    String postalCode = placemarks[0].postalCode ?? '';

    print("Latitude: ${currentLocation.latitude}");
    print("Longitude: ${currentLocation.longitude}");
    print("City Name: $cityName");
    print("Province Name: $provinceName");
    print("Postal Code: $postalCode");
    if(provinceName == 'Daerah Khusus Ibukota Jakarta'){
      provinceName = 'jakarta';
    }
    if (provinsiCon != null) {
      provinsiCon.text = provinceName;
    }
    if (kotaCon != null) {
      kotaCon.text = cityName;
    }

    nextAction();
  } else {
    print("No address information available.");
  }
}
