import 'dart:core';

String compressedFen(String fen) {
  for (int length = 8; length >= 2; length--) {
    String ones = '1' * length;
    String replacement = length.toString();
    fen = fen.replaceAll(ones, replacement);
  }
  return fen;
}

String uncompressedFen(String fen) {
  final RegExp digitRegExp = RegExp(r'[2-8]');
  return fen.replaceAllMapped(digitRegExp, (Match match) {
    int count = int.parse(match.group(0)!);
    return '1' * count;
  });
}
