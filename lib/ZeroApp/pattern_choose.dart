import 'package:flutter/material.dart';
import 'package:offlinebingo/ZeroApp/_card_patterns.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternChoose extends StatefulWidget {
  const PatternChoose({super.key});

  @override
  State<PatternChoose> createState() => _PatternChooseState();
}

class _PatternChooseState extends State<PatternChoose> {
  String? pattern1Name;
  String? pattern2Name;
  String combinationType = 'Single';
  final List<String> combinationTypes = ['OR', 'Single', 'AND'];

  @override
  void initState() {
    super.initState();
    _loadSavedPattern();
    pattern1Name = bingoPatternMap.keys.first;
    pattern2Name = bingoPatternMap.keys.elementAt(1);
  }

  Future<void> _loadSavedPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPattern = prefs.getString('selectedPattern');

    if (savedPattern != null && savedPattern.isNotEmpty) {
      if (savedPattern.startsWith('OR:') || savedPattern.startsWith('AND:')) {
        final parts = savedPattern.split(':');
        combinationType = parts[0];
        final patterns = parts[1].split('+').map((s) => s.trim()).toList();
        pattern1Name = patterns[0];
        pattern2Name = patterns.length > 1
            ? patterns[1]
            : bingoPatternMap.keys.elementAt(1);
      } else {
        combinationType = 'Single';
        pattern1Name = savedPattern;
        pattern2Name = bingoPatternMap.keys.elementAt(1);
      }
    }
    setState(() {});
  }

  List<int> cellIdToGridPos(String cellId) {
    if (cellId.length != 2) return [-1, -1];
    const colMap = {'b': 0, 'i': 1, 'n': 2, 'g': 3, 'o': 4};
    final col = colMap[cellId[0].toLowerCase()] ?? -1;
    final row = int.tryParse(cellId[1]) ?? -1;
    if (col == -1 || row < 1 || row > 5) return [-1, -1];
    return [row - 1, col];
  }

  List<String> get allPatternNames => bingoPatternMap.keys.toList();

  List<List<String>> combineOr(List<List<String>> p1, List<List<String>> p2) =>
      [...p1, ...p2];

  List<List<String>> combineAnd(List<List<String>> p1, List<List<String>> p2) {
    List<List<String>> result = [];
    for (var l1 in p1) {
      for (var l2 in p2) {
        result.add([...l1, ...l2]);
      }
    }
    return result;
  }

  List<List<String>> getSelectedPatternLines() {
    if (combinationType == 'Single' && pattern1Name != null) {
      return bingoPatternMap[pattern1Name!] ?? [];
    } else if (pattern1Name != null && pattern2Name != null) {
      final first = bingoPatternMap[pattern1Name!]!;
      final second = bingoPatternMap[pattern2Name!]!;
      return combinationType == 'OR'
          ? combineOr(first, second)
          : combineAnd(first, second);
    }
    return [];
  }

  List<List<int>> get selectedPositions => getSelectedPatternLines()
      .expand((line) => line.map(cellIdToGridPos))
      .where((pos) => pos[0] != -1)
      .toList();

  Future<void> _saveSelectedPattern() async {
    final prefs = await SharedPreferences.getInstance();
    String patternName = combinationType == 'Single'
        ? pattern1Name ?? ''
        : '$combinationType: ${pattern1Name ?? ''} + ${pattern2Name ?? ''}';
    await prefs.setString('selectedPattern', patternName);
  }

  @override
  Widget build(BuildContext context) {
    final positions = selectedPositions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Patterns"),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdownCard(
              "Pattern 1",
              pattern1Name!,
              (v) => setState(() => pattern1Name = v),
            ),
            if (combinationType != 'Single')
              _buildDropdownCard(
                "Pattern 2",
                pattern2Name!,
                (v) => setState(() => pattern2Name = v),
              ),
            _buildDropdownCard(
              "Combination",
              combinationType,
              (v) => setState(() => combinationType = v),
              options: combinationTypes,
            ),
            const SizedBox(height: 20),
            _buildBingoHeader(),
            const SizedBox(height: 12),
            _buildGrid(positions),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard(
    String label,
    String selected,
    Function(String) onChanged, {
    List<String>? options,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[600]!, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.grid_on, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selected,
                  dropdownColor: Colors.teal[800],
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  items: (options ?? allPatternNames)
                      .map(
                        (name) =>
                            DropdownMenuItem(value: name, child: Text(name)),
                      )
                      .toList(),
                  onChanged: (val) => onChanged(val!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBingoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: "BINGO".split('').map((letter) {
        return ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              colors: [Colors.tealAccent, Colors.greenAccent],
            ).createShader(rect);
          },
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGrid(List<List<int>> positions) {
    return SizedBox(
      width: 320,
      height: 320,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          int row = index ~/ 5;
          int col = index % 5;
          int number = 25 - (row * 5 + col);

          bool isActive = positions.any(
            (pos) => pos[0] == row && pos[1] == col,
          );

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isActive ? Colors.greenAccent : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ]
                  : [BoxShadow(color: Colors.black45, blurRadius: 3)],
            ),
            child: Center(
              child: Text(
                "$number",
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: () async {
        await _saveSelectedPattern();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pattern saved successfully"),
            duration: Duration(milliseconds: 500),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 600));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.greenAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Save Pattern",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [Shadow(blurRadius: 3, color: Colors.black38)],
            ),
          ),
        ),
      ),
    );
  }
}
