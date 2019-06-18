# icofont_flutter

The [IcoFont Icon](https://icofont.com) Pack available as Flutter Icon Page

### Based on IcoFont Version 1.0.1
@license - https://icofont.com/license/

# Installation
In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
icofont_flutter: <latest_version>
```

# Usage
```javascript
import 'package:icofont_flutter/icofont_flutter.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return new IconButton(
      // Use the IcoFontIcons class for the IconData
      icon: new Icon(IcoFontIcons.brandAcer), 
      onPressed: () { print("Pressed"); }
     );
  }
}
```

# Thanks to JoomShaper
for creating such a wonderfull icon pack too use for web.
