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

class IcoFontDataWebApps extends IcoFontData {
  const IcoFontDataWebApps(int codePoint) : super(codePoint);
}

class IcoFontDataBrands extends IcoFontData {
  const IcoFontDataBrands(int codePoint) : super(codePoint);
}

class IcoFontDataDirectional extends IcoFontData {
  const IcoFontDataDirectional(int codePoint) : super(codePoint);
}

class IcoFontDataSocial extends IcoFontData {
  const IcoFontDataSocial(int codePoint) : super(codePoint);
}

class IcoFontDataAnimal extends IcoFontData {
  const IcoFontDataAnimal(int codePoint) : super(codePoint);
}

class IcoFontDataCurrency extends IcoFontData {
  const IcoFontDataCurrency(int codePoint) : super(codePoint);
}

class IcoFontDataFood extends IcoFontData {
  const IcoFontDataFood(int codePoint) : super(codePoint);
}
