library icofont_flutter;

import 'package:flutter/widgets.dart';

class IcoFontData extends IconData {
  const IcoFontData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'IcoFont',
          fontPackage: 'icofont_flutter',
        );
}
