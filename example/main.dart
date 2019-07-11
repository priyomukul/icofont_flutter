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
  // IcoFontHome({ Key key, this.duration }) : super(key: key);

  // final Duration duration;
  @override
  _IcoFontHomeState createState() => _IcoFontHomeState();
}

class _IcoFontHomeState extends State<IcoFontHome>
    with TickerProviderStateMixin {
  double abacusSize = 50.0;
  bool isTaped = false;
  bool isPlayed = false;

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // direction: Axis.horizontal,
            children: <Widget>[
              GestureDetector(
                onTap : (){
                  setState(() {
                    isPlayed = ! isPlayed;
                  });
                },
                child: IcoFontWidget(
                  icon: IcoFontIcons.apple,
                  isPlayed: isPlayed,
                ),
              ),
              GestureDetector(
                onTap : (){
                  setState(() {
                    isPlayed = ! isPlayed;
                  });
                },
                child: IcoFontWidget(
                  icon: IcoFontIcons.orange,
                  isPlayed: isPlayed,
                ),
              ),
              // IcoFontWidget(
              //   icon: IcoFontIcons.paperPlane,
              // ),
              // IcoFontWidget(
              //   icon: IcoFontIcons.fruits,
              // ),
              // IcoFontWidget(
              //   icon: IcoFontIcons.magic,
              // ),
            ],
          ),
        ));
  }
}

class IcoFontWidget extends StatefulWidget {
  const IcoFontWidget({@required this.icon, @required this.isPlayed});
  final IconData icon;
  final bool isPlayed;
  @override
  _IcoFontWidgetState createState() => _IcoFontWidgetState();
}

class _IcoFontWidgetState extends State<IcoFontWidget>
    with TickerProviderStateMixin {
  double abacusSize = 50.0;
  bool isTaped = false;
  bool isPlayed;
  IconData icon;

  IconData iconName;

  AnimationController _controller;
  @override
  void initState() {
    print(widget.isPlayed);
    super.initState();
    icon = widget.icon;
    isPlayed = widget.isPlayed;
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
      onTap: () {
        setState(() {
          isTaped = isTaped ? false : true;
          iconName = icon;
        });
      },
      child: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedIcoFont(
            controller: _controller,
            isTaped: isTaped,
            isPlayed: isPlayed,
            icon: icon,
          ),
        ),
      ),
    );
  }
}

class AnimatedIcoFont extends AnimatedWidget {
  const AnimatedIcoFont(
      {Key key,
      this.size,
      AnimationController controller,
      @required this.isTaped,
      @required this.isPlayed,
      @required this.icon})
      : super(key: key, listenable: controller);
  Animation<double> get _progress => listenable;
  final bool isTaped;
  final bool isPlayed;
  final IconData icon;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      key: Key(icon.toString()),
      scale: isTaped && !isPlayed ? _progress.value : 1.0,
      child: Icon(
        icon,
        size: size != null ? size : 30.0,
      ),
    );
  }
}
