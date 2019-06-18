# icofont_flutter

The [IcoFont Icon](https://icofont.com) Pack available as Flutter Icon Pack

### Based on IcoFont Version 1.0.1

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
      icon: new Icon(IcoFontIcons.brandIcofont),
      onPressed: () { print("Pressed"); }
     );
  }
}
```

# Special Thanks to IcoFont Team
for creating such wonderful icon pack for making design.
