// Regenerates lib/icofont_flutter.dart from lib/fonts/icofont.ttf.
//
// Usage:
//   dart run tool/generate_icons.dart            # rewrite lib/icofont_flutter.dart
//   dart run tool/generate_icons.dart --check    # fail if the file is out of date
//
// The constant names come from the font's `post` table glyph names (camelCased)
// and the code points from its `cmap` table. Names that cannot be derived
// mechanically -- glyph names starting with a digit, and code points that share
// a glyph with an earlier one -- are listed in [nameOverrides]. Those overrides
// are part of the package's public API: change one and you break every app that
// uses that icon.

import 'dart:io';
import 'dart:typed_data';

/// Hand-picked constant names, keyed by code point.
///
/// Add an entry here when the generator refuses to name a glyph.
const Map<int, String> nameOverrides = <int, String>{
  // Glyph names that start with a digit.
  0xecbc: 'twoCheckoutAlt', // 2checkout-alt
  0xecbd: 'twoCheckout', // 2checkout
  0xed1c: 'fiveHundredpx', // 500px
  0xee41: 'fiveStarHotel', // 5-star-hotel
  // Code points that reuse an earlier glyph, so they share its name.
  0xebc7: 'law', // duplicate of law-alt-2 (0xebc0)
  0xef7c: 'logout', // duplicate of exit (0xef1d)
};

/// Words that cannot be a member name. Built-in identifiers (`external`,
/// `interface`, `library`, ...) are legal here and several icons rely on that.
const Set<String> _dartReservedWords = <String>{
  'assert',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
  'yield',
};

const String _fontPath = 'lib/fonts/icofont.ttf';
const String _outputPath = 'lib/icofont_flutter.dart';

void main(List<String> args) {
  final bool checkOnly = args.contains('--check');

  final File font = File(_fontPath);
  if (!font.existsSync()) {
    stderr.writeln('Cannot find $_fontPath. Run this from the package root.');
    exit(1);
  }

  final _Font parsed = _Font(font.readAsBytesSync());
  final Map<int, String> glyphNames = parsed.glyphNames();
  final Map<int, int> charToGlyph = parsed.characterMap();

  final Map<String, _Icon> icons = <String, _Icon>{};
  final Set<int> seenGlyphs = <int>{};
  final List<String> problems = <String>[];
  int skipped = 0;

  final List<int> codePoints = charToGlyph.keys.toList()..sort();
  for (final int codePoint in codePoints) {
    // IcoFont's single-layer icons live in the private use area. Above U+FFFF
    // the font also carries its 324 duotone icons, drawn as pairs of stacked
    // glyphs: 310 glyphs share 161 `post` names, so they cannot be named
    // one-to-one, and rendering one needs two IconData values layered in
    // different colours, which a single constant cannot express. This package
    // ships the single-layer range only.
    if (codePoint > 0xffff) {
      skipped++;
      continue;
    }

    final String? glyphName = glyphNames[charToGlyph[codePoint]];
    if (glyphName == null || glyphName.isEmpty || glyphName == '.notdef') {
      continue;
    }

    final String name = nameOverrides[codePoint] ?? _camelCase(glyphName);
    if (!_isValidIdentifier(name)) {
      problems.add('0x${codePoint.toRadixString(16)} ($glyphName) -> "$name" '
          'is not a usable Dart identifier');
      continue;
    }
    if (icons.containsKey(name)) {
      problems.add('0x${codePoint.toRadixString(16)} ($glyphName) -> "$name" '
          'collides with 0x${icons[name]!.codePoint.toRadixString(16)}');
      continue;
    }

    // A code point that reuses an earlier glyph inherits that glyph's name,
    // which no longer describes this icon, so document it by its own name.
    final bool isAlias = !seenGlyphs.add(charToGlyph[codePoint]!);
    icons[name] = _Icon(codePoint, isAlias ? name : glyphName);
  }

  if (problems.isNotEmpty) {
    stderr.writeln('Add an entry to nameOverrides for each of these:');
    problems.forEach(stderr.writeln);
    exit(1);
  }

  // Every constant is a plain IconData. Subclassing IconData used to be the
  // tidier way to write this, but Flutter made IconData a final class, so a
  // subclass no longer compiles. Naming the font on each constant instead
  // keeps the package working on both old and new SDKs.
  // Comments are dartdoc (///), not plain comments: pub.dev scores a package
  // on the share of its public API that carries documentation, and every icon
  // is public API.
  final StringBuffer out = StringBuffer()
    ..writeln('/// The [IcoFont](https://icofont.com) icon pack as [IconData]')
    ..writeln('/// constants.')
    ..writeln('///')
    ..writeln('/// Every icon is a `static const` field on [IcoFontIcons]:')
    ..writeln('///')
    ..writeln('/// ```dart')
    ..writeln('/// const Icon(IcoFontIcons.brandIcofont)')
    ..writeln('/// ```')
    ..writeln('library icofont_flutter;')
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln()
    ..writeln("const String _fontFamily = 'IcoFont';")
    ..writeln("const String _fontPackage = 'icofont_flutter';")
    ..writeln()
    ..writeln('/// This is main class which provides IcoFont icon as IconData.')
    ..writeln('class IcoFontIcons {');
  bool first = true;
  for (final MapEntry<String, _Icon> icon in icons.entries) {
    final String hex = icon.value.codePoint.toRadixString(16).padLeft(4, '0');
    // dart format puts a blank line before every documented member.
    if (!first) {
      out.writeln();
    }
    first = false;
    out
      ..writeln('  /// The IcoFont `${icon.value.comment}` icon.')
      ..writeln('  static const IconData ${icon.key} =')
      ..writeln('      IconData(0x$hex, '
          'fontFamily: _fontFamily, fontPackage: _fontPackage);');
  }
  out.writeln('}');

  final File output = File(_outputPath);
  final String generated = out.toString();

  if (skipped > 0) {
    stdout.writeln('Skipped $skipped code points above U+FFFF '
        '(not part of the IcoFont range).');
  }

  if (checkOnly) {
    final String current = output.existsSync() ? output.readAsStringSync() : '';
    if (current != generated) {
      stderr.writeln('$_outputPath is out of date. '
          'Run: dart run tool/generate_icons.dart');
      exit(1);
    }
    stdout.writeln('$_outputPath is up to date (${icons.length} icons).');
    return;
  }

  output.writeAsStringSync(generated);
  stdout.writeln('Wrote ${icons.length} icons to $_outputPath.');
}

String _camelCase(String glyphName) {
  final List<String> parts = glyphName
      .split(RegExp(r'[-_ ]+'))
      .where((String part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return '';
  }
  final StringBuffer buffer = StringBuffer(parts.first);
  for (final String part in parts.skip(1)) {
    buffer
      ..write(part.substring(0, 1).toUpperCase())
      ..write(part.substring(1));
  }
  return buffer.toString();
}

bool _isValidIdentifier(String name) =>
    RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name) &&
    !_dartReservedWords.contains(name);

/// Minimal TrueType reader: only the `post` and `cmap` tables are needed.
class _Font {
  _Font(Uint8List bytes)
      : _data = ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.length) {
    final int tableCount = _data.getUint16(4);
    for (int i = 0; i < tableCount; i++) {
      final int record = 12 + 16 * i;
      final String tag = String.fromCharCodes(
          Uint8List.view(_data.buffer, _data.offsetInBytes + record, 4));
      _tables[tag] = _data.getUint32(record + 8);
    }
  }

  final ByteData _data;
  final Map<String, int> _tables = <String, int>{};

  int _table(String tag) {
    final int? offset = _tables[tag];
    if (offset == null) {
      throw StateError('Font has no "$tag" table.');
    }
    return offset;
  }

  /// Glyph id -> glyph name, from a version 2.0 `post` table.
  Map<int, String> glyphNames() {
    final int post = _table('post');
    final int version = _data.getUint32(post);
    if (version != 0x00020000) {
      throw StateError('Expected a version 2.0 "post" table, got '
          '0x${version.toRadixString(16)}. The font was exported without '
          'glyph names, so icon names cannot be derived from it.');
    }

    final int glyphCount = _data.getUint16(post + 32);
    final List<int> indices = <int>[
      for (int i = 0; i < glyphCount; i++) _data.getUint16(post + 34 + 2 * i),
    ];

    final List<String> pool = <String>[];
    int cursor = post + 34 + 2 * glyphCount;
    while (pool.length < glyphCount && cursor < _data.lengthInBytes) {
      final int length = _data.getUint8(cursor);
      pool.add(String.fromCharCodes(Uint8List.view(
          _data.buffer, _data.offsetInBytes + cursor + 1, length)));
      cursor += 1 + length;
    }

    final Map<int, String> names = <int, String>{};
    for (int glyph = 0; glyph < glyphCount; glyph++) {
      final int index = indices[glyph];
      // Indices below 258 refer to standard Macintosh names, which this font
      // only uses for .notdef and friends.
      if (index >= 258 && index - 258 < pool.length) {
        names[glyph] = pool[index - 258];
      }
    }
    return names;
  }

  /// Character code -> glyph id, merged across every Unicode cmap subtable.
  ///
  /// Format 4 cannot express code points above U+FFFF, so a font that also
  /// ships a format 12 subtable keeps its astral icons only there. Reading one
  /// subtable and stopping silently drops those, so read them all and let
  /// format 12 win any disagreement.
  Map<int, int> characterMap() {
    final int cmap = _table('cmap');
    final int subtableCount = _data.getUint16(cmap + 2);

    final Map<int, int> format4 = <int, int>{};
    final Map<int, int> format12 = <int, int>{};
    for (int i = 0; i < subtableCount; i++) {
      final int record = cmap + 4 + 8 * i;
      final int platform = _data.getUint16(record);
      final int encoding = _data.getUint16(record + 2);
      final int subtable = cmap + _data.getUint32(record + 4);
      final int format = _data.getUint16(subtable);
      // Unicode (platform 0) and Windows Unicode (platform 3) subtables.
      final bool unicode =
          platform == 0 || (platform == 3 && (encoding == 1 || encoding == 10));
      if (!unicode) {
        continue;
      }
      if (format == 4) {
        format4.addAll(_parseFormat4(subtable));
      } else if (format == 12) {
        format12.addAll(_parseFormat12(subtable));
      }
    }

    if (format4.isEmpty && format12.isEmpty) {
      throw StateError('Font has no Unicode cmap subtable in format 4 or 12.');
    }
    return <int, int>{...format4, ...format12};
  }

  Map<int, int> _parseFormat4(int subtable) {
    final int segCountX2 = _data.getUint16(subtable + 6);
    final int segCount = segCountX2 ~/ 2;
    final int endsAt = subtable + 14;
    final int startsAt = endsAt + segCountX2 + 2;
    final int deltasAt = startsAt + segCountX2;
    final int rangesAt = deltasAt + segCountX2;

    final Map<int, int> map = <int, int>{};
    for (int segment = 0; segment < segCount; segment++) {
      final int end = _data.getUint16(endsAt + 2 * segment);
      final int start = _data.getUint16(startsAt + 2 * segment);
      final int delta = _data.getInt16(deltasAt + 2 * segment);
      final int rangeOffset = _data.getUint16(rangesAt + 2 * segment);

      for (int code = start; code <= end && code != 0xffff; code++) {
        int glyph;
        if (rangeOffset == 0) {
          glyph = (code + delta) & 0xffff;
        } else {
          final int at =
              rangesAt + 2 * segment + rangeOffset + 2 * (code - start);
          glyph = _data.getUint16(at);
          if (glyph != 0) {
            glyph = (glyph + delta) & 0xffff;
          }
        }
        if (glyph != 0) {
          map[code] = glyph;
        }
      }
    }
    return map;
  }

  Map<int, int> _parseFormat12(int subtable) {
    final int groupCount = _data.getUint32(subtable + 12);
    final Map<int, int> map = <int, int>{};
    for (int i = 0; i < groupCount; i++) {
      final int group = subtable + 16 + 12 * i;
      final int start = _data.getUint32(group);
      final int end = _data.getUint32(group + 4);
      final int startGlyph = _data.getUint32(group + 8);
      for (int code = start; code <= end; code++) {
        map[code] = startGlyph + (code - start);
      }
    }
    return map;
  }
}

/// One generated constant: its code point and the glyph name to document it by.
class _Icon {
  const _Icon(this.codePoint, this.comment);

  final int codePoint;
  final String comment;
}
