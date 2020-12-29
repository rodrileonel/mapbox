
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;

  final _center = LatLng(-12.0727495,-77.0630232);

  final _blackStyle = 'mapbox://styles/rodrigoleonel/ckgp4efe50uh619p4671n1fyu';
  final _normalStyle = 'mapbox://styles/rodrigoleonel/ckgok2t470azx19p45xg1aq6m';

  String _currentStyle ='';

  void _createMap(MapboxMapController controller) {
    _onStyleLoaded();
    mapController = controller;
  }
  //imagenes personalizadas de asset o de una url
  void _onStyleLoaded() {
    addImageFromAsset("asset", "assets/custom-icon.png");
    addImageFromUrl("marker", "https://via.placeholder.com/50");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        styleString: _currentStyle.isEmpty ? _normalStyle : _currentStyle,
        onMapCreated: _createMap,
        accessToken: 'pk.eyJ1Ijoicm9kcmlnb2xlb25lbCIsImEiOiJja2ZvNTViMzMxbDJ6Mnl0NDFzbGM1d2p3In0.rYLwuOlyU5z9Otthkr01zg', 
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[
          _symbol(),
          SizedBox(height:10),
          _zoomIn(),
          SizedBox(height:10),
          _zoomOut(),
          SizedBox(height:10),
          _selectMap()
        ]
      ),
    );
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  Widget _symbol() => FloatingActionButton(
    child: Icon(Icons.mood_sharp),
    onPressed: () {
      setState(() {
        mapController.addSymbol(SymbolOptions(
          geometry: _center,
          //iconSize: 3,
          iconImage: 'asset',
          textField: 'Rodrigo',
          textOffset: Offset(0,2),
        ));
      });
    },
  );

  Widget _zoomIn() => FloatingActionButton(
    child: Icon(Icons.zoom_in),
    onPressed: () {
      //mapController.animateCamera(CameraUpdate.tiltTo(80));
      mapController.animateCamera(CameraUpdate.zoomIn());
    },
  );

  Widget _zoomOut() => FloatingActionButton(
    child: Icon(Icons.zoom_out),
    onPressed: () {
      mapController.animateCamera(CameraUpdate.zoomOut());
    },
  );

  Widget _selectMap() => FloatingActionButton(
    child: Icon(Icons.map_outlined),
    onPressed: () {
      if(_currentStyle==_blackStyle)
        _currentStyle = _normalStyle;
      else
        _currentStyle = _blackStyle;
      _onStyleLoaded();
      setState(() {});
    },
  );
}