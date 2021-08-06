import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key key}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  void _checkService()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _serviceEnabled = true;
        });
      }
    }
  }

  void _checkPermission()async{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return ;
      }
    }
  }

  @override
  void initState() {
    _checkService();
    _checkPermission();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return _serviceEnabled && _permissionGranted !=null ? Container(
      height: MediaQuery.of(context).size.height / 3,
      child: locationWidget(),
    ) : Container(
      child: Text("Problem! Permissions not granted or service unavailable"),
    );
  }

  Widget locationWidget(){
    return FutureBuilder<LocationData>(
        future: location.getLocation(),
        builder: (context, location){
          if (location.data !=null) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text("Altitude:"),
                        subtitle: Text(location.data.altitude.toString()),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text("Longitude:"),
                        subtitle: Text(location.data.longitude.toString()),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text("Speed:"),
                        subtitle: Text(location.data.speed.toString()),
                      ),
                    ),
                  ),
                ),

              ],
            );
          }
          return Center(
            child: Text("loading..."),
          );
        });
  }
}




