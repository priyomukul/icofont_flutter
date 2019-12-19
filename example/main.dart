import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'dart:math' as math;

void main() => runApp(IcoFontExampleApp());

class IcoFontExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF494949),
          secondaryHeaderColor: Color(0xFF44678c)),
      home: IcoFontHome(),
    );
  }
}

class IcoFontHome extends StatefulWidget {
  @override
  _IcoFontHomeState createState() => _IcoFontHomeState();
}

class _IcoFontHomeState extends State<IcoFontHome>
    with SingleTickerProviderStateMixin {
  double abacusSize = 50.0;
  bool isTaped = false;
  bool isPlayed = false;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isTaped = false;
    _controller = AnimationController(
      duration: const Duration(seconds: 100),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('IcoFont Flutter Example'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // direction: Axis.horizontal,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    isTaped = !isTaped;
                  });
                },
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(15.0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Icon(Icons.add),
                    builder: (BuildContext context, Widget child) {
                      return Transform.scale(
                        scale: isTaped ? _controller.value : 1,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isTaped = !isTaped;
                  });
                },
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(15.0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Icon(Icons.access_alarm),
                    builder: (BuildContext context, Widget child) {
                      return Transform.scale(
                        scale: isTaped ? _controller.value : 1,
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
