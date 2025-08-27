// bingo_patterns.dart

class BingoPatterns {
  static const List<List<String>> row = [
    ["b1", "i1", "n1", "g1", "o1"],
    ["b2", "i2", "n2", "g2", "o2"],
    ["b3", "i3", "n3", "g3", "o3"],
    ["b4", "i4", "n4", "g4", "o4"],
    ["b5", "i5", "n5", "g5", "o5"],
  ];

  static const List<List<String>> column = [
    ["b1", "b2", "b3", "b4", "b5"],
    ["i1", "i2", "i3", "i4", "i5"],
    ["n1", "n2", "n3", "n4", "n5"],
    ["g1", "g2", "g3", "g4", "g5"],
    ["o1", "o2", "o3", "o4", "o5"],
  ];

  static const List<List<String>> diagonal = [
    ["b1", "i2", "n3", "g4", "o5"],
    ["b5", "i4", "n3", "g2", "o1"],
  ];

  static const List<List<String>> oneLine = [
    ...row,
    ...column,
    ...diagonal,
  ];

  static const List<List<String>> fourCorners = [
    ["b1", "b5", "o1", "o5"],
  ];

  static const List<List<String>> innerCorners = [
    ["i2", "i4", "g2", "g4"],
  ];

  static const List<List<String>> innerOrFourCorners = [
    ...fourCorners,
    ...innerCorners,
  ];

  static const List<List<String>> lPattern = [
    ["b1", "b2", "b3", "b4", "b5", "i5", "n5", "g5", "o5"],
    ["o1", "o2", "o3", "o4", "o5", "b5", "i5", "n5", "g5"],
  ];

  static const List<List<String>> reverseL = [
    ["b1", "b2", "b3", "b4", "b5", "b1", "i1", "n1", "g1"],
    ["o1", "o2", "o3", "o4", "o5", "b1", "i1", "n1", "g1"],
  ];

  static const List<List<String>> tPattern = [
    ["b1", "i1", "n1", "g1", "o1", "n2", "n3", "n4", "n5"],
    ["b5", "i5", "n5", "g5", "o5", "n1", "n2", "n3", "n4"],
  ];

  static const List<List<String>> reverseT = [
    ["n1", "n2", "n3", "n4", "n5", "b1", "i1", "n1", "g1", "o1"],
    ["n1", "n2", "n3", "n4", "n5", "b5", "i5", "n5", "g5", "o5"],
  ];

  static const List<List<String>> plus = [
    ["n1", "n2", "n3", "n4", "n5", "b3", "i3", "g3", "o3"],
  ];

  static const List<List<String>> square = [
    [
      "b1", "b2", "i1", "i2", "b4", "b5", "i4", "i5",
      "g1", "g2", "o1", "o2", "g4", "g5", "o4", "o5",
    ],
    ["i2", "i3", "i4", "n2", "n4", "g2", "g3", "g4"],
  ];

  static const List<List<String>> xPattern = [
    ["b1", "i2", "n3", "g4", "o5", "b5", "i4", "g2", "o1"],
  ];

  static const List<List<String>> uPattern = [
    ["b1", "b2", "b3", "b4", "b5", "i5", "n5", "g5", "o5", "o4", "o3", "o2", "o1"],
    ["b1", "b2", "b3", "b4", "b5", "i1", "n1", "g1", "o1", "o2", "o3", "o4", "o5"],
  ];

  static const List<List<String>> cross = [
    ["b3", "i3", "n3", "g3", "o3", "n1", "n2", "n4", "n5"],
  ];

  static const List<List<String>> diamond = [
    ["n2", "i3", "n3", "g3", "n4"],
  ];

  static const List<List<String>> postageStamp = [
    ["b1", "b2", "i1", "i2"],
    ["g1", "g2", "o1", "o2"],
    ["b4", "b5", "i4", "i5"],
    ["g4", "g5", "o4", "o5"],
  ];

  static const List<List<String>> bigDiamond = [
    ["n1", "i2", "b3", "i3", "n3", "g3", "o3", "g2", "n2", "i4", "n4", "g4"],
  ];

  static const List<List<String>> letterH = [
    ["b1", "b2", "b3", "b4", "b5", "o1", "o2", "o3", "o4", "o5", "b3", "i3", "n3", "g3", "o3"],
  ];

  static const List<List<String>> letterC = [
    ["b1", "b2", "b3", "b4", "b5", "b1", "i1", "n1", "g1", "o1", "b5", "i5", "n5", "g5", "o5"],
  ];

  static const List<List<String>> letterE = [
    [
      "b1", "b2", "b3", "b4", "b5", "b1", "i1", "n1", "g1", "o1",
      "b3", "i3", "n3", "g3", "o3", "b5", "i5", "n5", "g5", "o5",
    ],
  ];
  // Add new additional patterns as static const
  static const List<List<String>> smileyFace = [
    ["i2", "g2", "i4", "g4", "b5", "i5", "n5", "g5", "o5"], // Smiley face (eyes and smile)
  ];

  static const List<List<String>> triangle = [
    ["n1", "i2", "n2", "g2", "b3", "i3", "n3", "g3", "o3"], // Triangle pointing down
  ];

  static const List<List<String>> zigzag = [
    ["b1", "i2", "n3", "g4", "o5"], // Zigzag pattern
  ];

  static const List<List<String>> crescent = [
    ["b3", "i3", "n3", "g3", "o3", "i2", "g2", "i4", "g4"], // Crescent shape
  ];

  static const List<List<String>> lightningBolt = [
    ["b1", "i2", "n3", "i4", "g5"], // Lightning bolt pattern
  ];

  static const List<List<String>> anyTwoLine = [
    //=== 1. HORIZONTAL + HORIZONTAL ===//
    ["b1", "b2", "b3", "b4", "b5", "i1", "i2", "i3", "i4", "i5"], // B + I
    ["b1", "b2", "b3", "b4", "b5", "n1", "n2", "n3", "n4", "n5"], // B + N
    ["b1", "b2", "b3", "b4", "b5", "g1", "g2", "g3", "g4", "g5"], // B + G
    ["b1", "b2", "b3", "b4", "b5", "o1", "o2", "o3", "o4", "o5"], // B + O
    ["i1", "i2", "i3", "i4", "i5", "n1", "n2", "n3", "n4", "n5"], // I + N
    ["i1", "i2", "i3", "i4", "i5", "g1", "g2", "g3", "g4", "g5"], // I + G
    ["i1", "i2", "i3", "i4", "i5", "o1", "o2", "o3", "o4", "o5"], // I + O
    ["n1", "n2", "n3", "n4", "n5", "g1", "g2", "g3", "g4", "g5"], // N + G
    ["n1", "n2", "n3", "n4", "n5", "o1", "o2", "o3", "o4", "o5"], // N + O
    ["g1", "g2", "g3", "g4", "g5", "o1", "o2", "o3", "o4", "o5"], // G + O

    //=== 2. VERTICAL + VERTICAL ===//
    ["b1", "i1", "n1", "g1", "o1", "b2", "i2", "n2", "g2", "o2"], // 1st + 2nd col
    ["b1", "i1", "n1", "g1", "o1", "b3", "i3", "n3", "g3", "o3"], // 1st + 3rd col
    ["b1", "i1", "n1", "g1", "o1", "b4", "i4", "n4", "g4", "o4"], // 1st + 4th col
    ["b1", "i1", "n1", "g1", "o1", "b5", "i5", "n5", "g5", "o5"], // 1st + 5th col
    ["b2", "i2", "n2", "g2", "o2", "b3", "i3", "n3", "g3", "o3"], // 2nd + 3rd col
    ["b2", "i2", "n2", "g2", "o2", "b4", "i4", "n4", "g4", "o4"], // 2nd + 4th col
    ["b2", "i2", "n2", "g2", "o2", "b5", "i5", "n5", "g5", "o5"], // 2nd + 5th col
    ["b3", "i3", "n3", "g3", "o3", "b4", "i4", "n4", "g4", "o4"], // 3rd + 4th col
    ["b3", "i3", "n3", "g3", "o3", "b5", "i5", "n5", "g5", "o5"], // 3rd + 5th col
    ["b4", "i4", "n4", "g4", "o4", "b5", "i5", "n5", "g5", "o5"], // 4th + 5th col

    //=== 3. DIAGONAL + DIAGONAL ===//
    ["b1", "i2", "n3", "g4", "o5", "b5", "i4", "n3", "g2", "o1"], // X-shape

    //=== 4. HORIZONTAL + VERTICAL ===//
    // T-shape patterns (horizontal row + vertical stem at middle column)
    ["b1", "b2", "b3", "b4", "b5", "b3", "i3", "n3", "g3", "o3"], // B + 3rd col (T)
    ["i1", "i2", "i3", "i4", "i5", "b3", "i3", "n3", "g3", "o3"], // I + 3rd col (T)
    ["n1", "n2", "n3", "n4", "n5", "b3", "i3", "n3", "g3", "o3"], // N + 3rd col (T)
    ["g1", "g2", "g3", "g4", "g5", "b3", "i3", "n3", "g3", "o3"], // G + 3rd col (T)
    ["o1", "o2", "o3", "o4", "o5", "b3", "i3", "n3", "g3", "o3"], // O + 3rd col (T)
    // Cross-shape patterns (vertical column + horizontal stem at N-row)
    ["b1", "i1", "n1", "g1", "o1", "n1", "n2", "n3", "n4", "n5"], // 1st col + N (⊥)
    ["b2", "i2", "n2", "g2", "o2", "n1", "n2", "n3", "n4", "n5"], // 2nd col + N (⊥)
    ["b3", "i3", "n3", "g3", "o3", "n1", "n2", "n3", "n4", "n5"], // 3rd col + N (+)
    ["b4", "i4", "n4", "g4", "o4", "n1", "n2", "n3", "n4", "n5"], // 4th col + N (⊢)
    ["b5", "i5", "n5", "g5", "o5", "n1", "n2", "n3", "n4", "n5"], // 5th col + N (⊢)
    // Additional horizontal + vertical combinations
    ["b1", "b2", "b3", "b4", "b5", "b1", "i1", "n1", "g1", "o1"], // B + 1st col
    ["b1", "b2", "b3", "b4", "b5", "b2", "i2", "n2", "g2", "o2"], // B + 2nd col
    ["b1", "b2", "b3", "b4", "b5", "b4", "i4", "n4", "g4", "o4"], // B + 4th col
    ["b1", "b2", "b3", "b4", "b5", "b5", "i5", "n5", "g5", "o5"], // B + 5th col
    ["i1", "i2", "i3", "i4", "i5", "b1", "i1", "n1", "g1", "o1"], // I + 1st col
    ["i1", "i2", "i3", "i4", "i5", "b2", "i2", "n2", "g2", "o2"], // I + 2nd col
    ["i1", "i2", "i3", "i4", "i5", "b4", "i4", "n4", "g4", "o4"], // I + 4th col
    ["i1", "i2", "i3", "i4", "i5", "b5", "i5", "n5", "g5", "o5"], // I + 5th col
    ["g1", "g2", "g3", "g4", "g5", "b1", "i1", "n1", "g1", "o1"], // G + 1st col
    ["g1", "g2", "g3", "g4", "g5", "b2", "i2", "n2", "g2", "o2"], // G + 2nd col
    ["g1", "g2", "g3", "g4", "g5", "b4", "i4", "n4", "g4", "o4"], // G + 4th col
    ["g1", "g2", "g3", "g4", "g5", "b5", "i5", "n5", "g5", "o5"], // G + 5th col
    ["o1", "o2", "o3", "o4", "o5", "b1", "i1", "n1", "g1", "o1"], // O + 1st col
    ["o1", "o2", "o3", "o4", "o5", "b2", "i2", "n2", "g2", "o2"], // O + 2nd col
    ["o1", "o2", "o3", "o4", "o5", "b4", "i4", "n4", "g4", "o4"], // O + 4th col

    //=== 5. HORIZONTAL + DIAGONAL ===//
    ["b1", "b2", "b3", "b4", "b5", "b1", "i2", "n3", "g4", "o5"], // B + top-L diag
    ["b1", "b2", "b3", "b4", "b5", "b5", "i4", "n3", "g2", "o1"], // B + top-R diag
    ["i1", "i2", "i3", "i4", "i5", "b1", "i2", "n3", "g4", "o5"], // I + top-L diag
    ["i1", "i2", "i3", "i4", "i5", "b5", "i4", "n3", "g2", "o1"], // I + top-R diag
    ["n1", "n2", "n3", "n4", "n5", "b1", "i2", "n3", "g4", "o5"], // N + top-L diag
    ["n1", "n2", "n3", "n4", "n5", "b5", "i4", "n3", "g2", "o1"], // N + top-R diag
    ["g1", "g2", "g3", "g4", "g5", "b1", "i2", "n3", "g4", "o5"], // G + top-L diag
    ["g1", "g2", "g3", "g4", "g5", "b5", "i4", "n3", "g2", "o1"], // G + top-R diag
    ["o1", "o2", "o3", "o4", "o5", "b1", "i2", "n3", "g4", "o5"], // O + top-L diag
    ["o1", "o2", "o3", "o4", "o5", "b5", "i4", "n3", "g2", "o1"], // O + top-R diag

    //=== 6. VERTICAL + DIAGONAL ===//
    ["b1", "i1", "n1", "g1", "o1", "b1", "i2", "n3", "g4", "o5"], // 1st col + top-L diag
    ["b1", "i1", "n1", "g1", "o1", "b5", "i4", "n3", "g2", "o1"], // 1st col + top-R diag
    ["b2", "i2", "n2", "g2", "o2", "b1", "i2", "n3", "g4", "o5"], // 2nd col + top-L diag
    ["b2", "i2", "n2", "g2", "o2", "b5", "i4", "n3", "g2", "o1"], // 2nd col + top-R diag
    ["b3", "i3", "n3", "g3", "o3", "b1", "i2", "n3", "g4", "o5"], // 3rd col + top-L diag
    ["b3", "i3", "n3", "g3", "o3", "b5", "i4", "n3", "g2", "o1"], // 3rd col + top-R diag
    ["b4", "i4", "n4", "g4", "o4", "b1", "i2", "n3", "g4", "o5"], // 4th col + top-L diag
    ["b4", "i4", "n4", "g4", "o4", "b5", "i4", "n3", "g2", "o1"], // 4th col + top-R diag
    ["b5", "i5", "n5", "g5", "o5", "b1", "i2", "n3", "g4", "o5"], // 5th col + top-L diag
    ["b5", "i5", "n5", "g5", "o5", "b5", "i4", "n3", "g2", "o1"], // 5th col + top-R diag
  ];
 
}