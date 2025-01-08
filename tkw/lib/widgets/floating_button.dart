import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'sheet.dart';

class FancyFab extends StatefulWidget {
  final MapController mapController;
  final LatLng center;

  FancyFab({
    required this.mapController,
    required this.center,
  });

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.yellow,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.00, 1.00, curve: Curves.linear),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.75, curve: _curve),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget payment() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => showPaymentModal(context),
        tooltip: 'Home',
        child: Icon(Icons.home,size: 30,),
      ),
    );
  }

  Widget zoomToCenter() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => widget.mapController.move(widget.center, 7.0),
        tooltip: 'Zoom to Center',
        child: Icon(Icons.my_location,size:30),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
          child: payment(),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, _translateButton.value, 0.0),
          child: zoomToCenter(),
        ),
        toggle(),
      ],
    );
  }
}