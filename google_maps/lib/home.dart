import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  Marker setMarket = Marker(
    markerId: MarkerId('network'),
    position: LatLng(48.8348933, 2.3287472),
    // icon: BitmapDescriptor.fromAsset(
    //   'assets/images/marker.png',
    // ),
    icon:BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet
    ),
    infoWindow: InfoWindow(
      title: "Paris",
      snippet: "Snippet",
    )
  );

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            //
          }
        ),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon:Icon(FontAwesomeIcons.search),
            onPressed: () {
              //
            }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          //_zoomMoinsFunction(),
          //_zoomPlusFunction(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomMoinsFunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(FontAwesomeIcons.searchMinus, color: Colors.blue),
        onPressed: () {
          zoomVal--;
          _minus(zoomVal);
        },
      ),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(48.8909, 2.7398),
          zoom: zoomVal
        )
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                "",
                48.768998,
                2.7689800,
                "Grevean Taven"
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String shortName) {
    return GestureDetector(
      onTap: () {
        _geoLocation(lat, long);
      },
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0xB02196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 200,
                  child: Image(
                    fit: BoxFit.fill,
                    image:NetworkImage(_image),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: myDetailsContainer(shortName),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget myDetailsContainer(String shortName) {
    Widget _googleMap(BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          mapType: MapType.normal,
          markers: { setMarket },
          initialCameraPosition: CameraPosition(
            target: LatLng(48.8348933, 2.3287472),
            zoom: 12
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      );
    }

    Future<void> _geoLocation(double lat, double long) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 15,
            tilt: 50.0,
            bearing: 45.0
          )
        )
      );
    }
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        markers: { setMarket },
        initialCameraPosition: CameraPosition(
          target: LatLng(48.8348933, 2.3287472),
          zoom: 12
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}