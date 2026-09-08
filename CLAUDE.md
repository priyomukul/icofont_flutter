# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Flutter package that exposes the IcoFont pack as `IconData` constants.
`lib/icofont_flutter.dart` is the whole library: ~2100 constants, all generated.
`example/` is a demo app depending on the package by path.

## Generated code

`lib/icofont_flutter.dart` is generated — do not hand-edit it.

```
dart run tool/generate_icons.dart          # regenerate from lib/fonts/icofont.ttf
dart run tool/generate_icons.dart --check  # fail if the file is stale
```

Only the IcoFont range (U+E800–U+F03D) is exposed. Some builds of the .ttf also
carry an unrelated Joomla admin icon set above U+FFFF whose `post` names cannot
identify its glyphs (310 glyphs, 161 names), so the generator skips everything
above U+FFFF and reports how many. That skip is deliberate — not a parser bug.

Constant names come from the font's `post` glyph names, camelCased. When a glyph
name starts with a digit, or a code point reuses an earlier glyph, the generator
refuses to name it and tells you to add an entry to `nameOverrides` in the
script. Those override names are public API — renaming one breaks every app
using that icon, so add entries, never rewrite existing ones.

## Font asset wiring

Three things must agree or every icon renders blank: the asset path
`lib/fonts/icofont.ttf` and `family: IcoFont` in `pubspec.yaml`, and the
`_fontFamily` / `_fontPackage` constants each `IconData` is built with. Those
constants are emitted by the generator, so change them in the script's template,
not in the generated file.

## SDK constraint

`sdk: ">=2.12.0 <4.0.0"`: null safety at the bottom, Dart 3 at the top. Both
ends matter — the lower bound keeps pre-Dart-3 consumers working, the upper one
is what makes the package usable at all on current Flutter.

Do not reintroduce a class that extends `IconData`. Flutter marked `IconData`
final, so a subclass fails to compile outright, not just in the analyzer. Icons
are plain `IconData` constants for that reason.

## Workflow

- Work on `dev`; open PRs against `master`.
- Release: bump `version:` in `pubspec.yaml`, add a `CHANGELOG.md` entry, then
  `flutter pub publish`.
