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
        secondaryHeaderColor: Color(0xFF44678c)
      ),
      home: IcoFontHome(),
    );
  }
}

class IcoFontHome extends StatefulWidget {
  // IcoFontHome({ Key key, this.duration }) : super(key: key);

  // final Duration duration;
  @override
  _IcoFontHomeState createState() => _IcoFontHomeState();
}

class _IcoFontHomeState extends State<IcoFontHome> with TickerProviderStateMixin {
  double abacusSize = 50.0;
  bool isTaped = false;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IcoFontWidget( icon: IcoFontIcons.abacus ),
              IcoFontWidget( icon: IcoFontIcons.apple ),
              IcoFontWidget( icon: IcoFontIcons.brandAcer ),
            ],
          ),
        ],
      )
    );
  }
}

class IcoFontWidget extends StatefulWidget {
  const IcoFontWidget({ @required this.icon});
  final IconData icon;
  @override
  _IcoFontWidgetState createState() => _IcoFontWidgetState();
}

class _IcoFontWidgetState extends State<IcoFontWidget>  with TickerProviderStateMixin {
  double abacusSize = 50.0;
  bool isTaped = false;
  IconData icon;

  IconData iconName;

  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    icon = widget.icon;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    return GestureDetector(
      onTap: (){
        setState(() {
          isTaped = isTaped ? false : true;
          iconName = icon;
        });
      },
      child: AnimatedIcoFont(
        key: Key( icon.toString() ),
        controller: _controller, 
        isTaped : isTaped,
        icon: icon,
      ),
    );
  }
}


class AnimatedIcoFont extends AnimatedWidget {
  const AnimatedIcoFont({Key key, AnimationController controller, @required this.isTaped, @required this.icon})
      : super(key: key, listenable: controller);
  Animation<double> get _progress => listenable;
  final bool isTaped;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      key: Key(icon.toString()),
      scale: isTaped ? _progress.value : 1.0,
      child: Icon(
        icon, size: 50.0,
      ),
    );
  }
}