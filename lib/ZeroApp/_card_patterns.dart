import 'package:offlinebingo/config/wining_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, List<List<String>>> bingoPatternMap = {
  "Rows": BingoPatterns.row,
  "Columns": BingoPatterns.column,
  "Diagonals": BingoPatterns.diagonal,
  "Four Corners": BingoPatterns.fourCorners,
  "One Line": BingoPatterns.oneLine,
  "Inner Corners": BingoPatterns.innerCorners,
  "Inner or Four Corners": BingoPatterns.innerOrFourCorners,
  "L Pattern": BingoPatterns.lPattern,
  "Reverse L": BingoPatterns.reverseL,
  "T Pattern": BingoPatterns.tPattern,
  "Reverse T": BingoPatterns.reverseT,
  "Plus": BingoPatterns.plus,
  "Square": BingoPatterns.square,
  "X Pattern": BingoPatterns.xPattern,
  "U Pattern": BingoPatterns.uPattern,
  "Cross": BingoPatterns.cross,
  "Diamond": BingoPatterns.diamond,
  "Postage Stamp": BingoPatterns.postageStamp,
  "Big Diamond": BingoPatterns.bigDiamond,
  "Letter H": BingoPatterns.letterH,
  "Letter C": BingoPatterns.letterC,
  "Letter E": BingoPatterns.letterE,
  "Smiley Face": BingoPatterns.smileyFace,
  "Triangle": BingoPatterns.triangle,
  "Zigzag": BingoPatterns.zigzag,
  "Crescent": BingoPatterns.crescent,
  "Lightning Bolt": BingoPatterns.lightningBolt,
  "Any Two Line": BingoPatterns.anyTwoLine,
  "Row and Column": _generateRowAndColumnPatterns(),
  "Row or Column": [...BingoPatterns.row, ...BingoPatterns.column],
};

/// Combine two patterns with OR logic: just merge both pattern lists.
List<List<String>> combinePatternsOr(
  List<List<String>> pattern1,
  List<List<String>> pattern2,
) {
  return [...pattern1, ...pattern2];
}

/// Combine two patterns with AND logic: each pattern must be present on the same card.
/// So, merge each pair (one from pattern1, one from pattern2).
List<List<String>> combinePatternsAnd(
  List<List<String>> pattern1,
  List<List<String>> pattern2,
) {
  List<List<String>> result = [];
  for (final p1 in pattern1) {
    for (final p2 in pattern2) {
      result.add([...p1, ...p2]); // Merge both into a single pattern
    }
  }
  return result;
}

List<List<String>> _generateRowAndColumnPatterns() {
  List<List<String>> result = [];
  for (final row in BingoPatterns.row) {
    for (final col in BingoPatterns.column) {
      result.add([...row, ...col]);
    }
  }
  return result;
}

List<List<String>> combineOr(List<List<String>> a, List<List<String>> b) {
  final setA = a.expand((line) => line).toSet();
  final setB = b.expand((line) => line).toSet();
  final intersect = setA.intersection(setB).toList();

  // Return as one combined pattern line (list of cell IDs)
  return [intersect];
}

List<List<String>> combineAnd(List<List<String>> a, List<List<String>> b) {
  final setA = a.expand((line) => line).toSet();
  final setB = b.expand((line) => line).toSet();
  final union = setA.union(setB).toList();

  // Return as one combined pattern line (list of cell IDs)
  return [union];
}

// Get the saved pattern name from SharedPreferences
Future<String?> getSavedPatternName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('selectedPattern');
}

List<List<String>> getCombinedPatternLines(String savedPatternName) {
  if (savedPatternName.startsWith('Single:')) {
    final patternName = savedPatternName.substring(7).trim();
    return bingoPatternMap[patternName] ?? [];
  }

  final regex = RegExp(r'^(OR|AND):\s*(.+?)\s*\+\s*(.+)$');
  final match = regex.firstMatch(savedPatternName);
  if (match != null) {
    final comb = match.group(1)!; // "OR" or "AND"
    final pattern1 = match.group(2)!; // e.g. "Fourth Corner"
    final pattern2 = match.group(3)!; // e.g. "Plus"
    final first = bingoPatternMap[pattern1] ?? [];
    final second = bingoPatternMap[pattern2] ?? [];
    if (comb == 'OR') {
      return combineOr(first, second);
    } else {
      return combineAnd(first, second);
    }
  }

  // fallback: try direct lookup
  return bingoPatternMap[savedPatternName] ?? [];
}
