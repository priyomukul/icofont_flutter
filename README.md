# icofont_flutter

[![pub package](https://img.shields.io/pub/v/icofont_flutter.svg)](https://pub.dev/packages/icofont_flutter)
[![CI](https://github.com/priyomukul/icofont_flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/priyomukul/icofont_flutter/actions/workflows/ci.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

The [IcoFont](https://icofont.com) icon pack as a Flutter icon pack — 2,105 icons
exposed as `IconData` constants, usable anywhere Flutter takes an icon.

No dependencies beyond Flutter itself. The font ships with the package, so there
is nothing to declare in your own `pubspec.yaml` beyond the package.

## Installation

```console
flutter pub add icofont_flutter
```

Or add it to the `dependencies:` section of your `pubspec.yaml`:

```yaml
dependencies:
  icofont_flutter: ^1.5.0
```

## Usage

Every icon is a `static const IconData` on `IcoFontIcons`, so it works with any
widget that accepts an `IconData`:

```dart
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(IcoFontIcons.brandIcofont),
      onPressed: () => debugPrint('Pressed'),
    );
  }
}
```

Size and color come from the usual `Icon` properties:

```dart
const Icon(IcoFontIcons.rocket, size: 48, color: Colors.indigo)
```

### Finding an icon

Browse the pack at [icofont.com/icons](https://icofont.com/icons). An icon's
name there maps to a constant by camel casing it:

| IcoFont name | Constant |
| --- | --- |
| `angry-monster` | `IcoFontIcons.angryMonster` |
| `brand-icofont` | `IcoFontIcons.brandIcofont` |
| `ui-calculator` | `IcoFontIcons.uiCalculator` |
| `500px` | `IcoFontIcons.fiveHundredpx` |

Names that would start with a digit are spelled out, since Dart identifiers
cannot. `lib/icofont_flutter.dart` lists every constant with its IcoFont name in
a comment above it.

The 324 duotone icons are not currently available — they are drawn as pairs of
stacked glyphs, which the single-`IconData` API here cannot express.

## Requirements

Dart `>=2.12.0 <4.0.0`, Flutter `>=1.17.0`. Works on Dart 2 and Dart 3.

## Example

See [`example/`](example) for a small app that renders icons from the pack:

```console
cd example
flutter run
```

## Updating the icons

`lib/icofont_flutter.dart` is generated from `lib/fonts/icofont.ttf` — do not
edit it by hand. After replacing the font, regenerate:

```console
dart run tool/generate_icons.dart
```

The generator reads glyph names from the font's `post` table and code points
from its `cmap` table. It refuses to guess a name it cannot derive, so if it
reports a problem, add the icon to `nameOverrides` in the script rather than
editing the output. CI runs `dart run tool/generate_icons.dart --check` to
verify the committed file still matches the font.

## Credits

Icons by the [IcoFont](https://icofont.com) team, who made this wonderful pack
free for everyone. This package only wraps their work for Flutter.

## License

MIT — see [LICENSE](LICENSE).
