import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

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
  @override
  _IcoFontHomeState createState() => _IcoFontHomeState();
}

class _IcoFontHomeState extends State<IcoFontHome> {
  double abacusSize = 50.0;
  bool isTaped = false;

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
              GestureDetector(
                onTap: (){
                  setState(() {
                    abacusSize = isTaped ? 50 : 100;
                    isTaped = isTaped ? false : true;
                  });
                },
                child: Icon( 
                  IcoFontIcons.abacus, size: abacusSize, color: Colors.red, 
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}