## [1.5.0] - September 9, 2026.

* 10 new icons: figma, illustrator, photoshop, discord, tiktok, sass, vuejs,
  vscode, visualStudio, x.
* Works on Dart 3. Flutter made `IconData` a final class, which stopped the
  package from compiling; icons are now plain `IconData` constants instead of a
  subclass. SDK constraint widened to `>=2.12.0 <4.0.0`.
* Icon constants are generated from the font by `tools/generate_icons.dart`.
* Fixed the example app: it depends on the local package and builds again.

## [1.4.0] - July 12, 2021.

* Migrate to NULL Safety (Thanks to GJJ2019)

## [1.3.0] - June 21, 2019.

* Tidy Neat & Clean Code, better for understanding and also some improvements.

## [1.2.0] - June 19, 2019.

* Desicriptions and SDK version update.

## [1.1.0] - June 19, 2019.

* Desicriptions and Some improvements.

## [1.0.0] - June 18, 2019.

* Add LICENSE.md file
* Created README.md file with instructions for using this package.
* Created `IcoFontIcons` class, which provides all IcoFont Icons as IconData, similar to Flutter's built-in Icons class.