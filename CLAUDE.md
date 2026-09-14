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

Only the single-layer range (U+E800–U+F03D) is exposed. Above U+FFFF the .ttf
also carries IcoFont's 324 duotone icons, drawn as pairs of stacked glyphs — so
310 glyphs share 161 `post` names and cannot be named one-to-one, and a duotone
icon needs two `IconData` values layered in different colours, which a single
constant cannot express. The generator skips everything above U+FFFF and reports
how many. That skip is deliberate — not a parser bug.

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

Work on `dev`; open PRs against `main`. `main` is the only long-lived branch
besides `dev` — `master` and `develop` are gone.

CI runs formatting, `flutter analyze`, `dart run tool/generate_icons.dart
--check`, the example tests, and a publish dry run on every push and PR. Run
them locally before opening a PR.

## Releasing

Publishing is automated — do not run `flutter pub publish` by hand.

1. Bump `version:` in `pubspec.yaml`.
2. Add a `CHANGELOG.md` entry.
3. Merge to `main`.
4. Tag and push: `git tag v1.5.0 && git push origin v1.5.0`.

The tag must match `pubspec.yaml` or pub.dev rejects the upload. The workflow
authenticates with OIDC, so there is no token in repository secrets.

User-facing docs live in the [GitHub wiki](https://github.com/priyomukul/icofont_flutter/wiki),
which is a separate git repo (`...icofont_flutter.wiki.git`). Update it when
behaviour or the public API changes.
