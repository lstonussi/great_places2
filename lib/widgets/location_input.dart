import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;
  LocationInput(this.onSelectPosition);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: locData.latitude, longitude: locData.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectPosition(LatLng(
      locData.latitude,
      locData.longitude,
    ));
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(),
      ),
    );

    if (selectedPosition == null) return;

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: selectedPosition.latitude,
        longitude: selectedPosition.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
    widget.onSelectPosition(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? Text('Localização não informada')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              label: Text('Localização Atual'),
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
                label: Text('Selecionar no Mapa'),
                icon: Icon(Icons.map, color: Theme.of(context).primaryColor),
                onPressed: _selectOnMap),
          ],
        )
      ],
    );
  }
}
