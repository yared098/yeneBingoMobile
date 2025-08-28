import 'package:flutter/material.dart';
import 'package:offlinebingo/ZeroApp/_card_patterns.dart';
import 'package:offlinebingo/ZeroApp/_cards_patterns.dart';
import 'package:offlinebingo/ZeroApp/pattern_choose.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BingoPage extends StatefulWidget {
  final List<int> selectedNumbers;
  const BingoPage({super.key, required this.selectedNumbers});

  @override
  State<BingoPage> createState() => _BingoPageState();
}

class _BingoPageState extends State<BingoPage> {
  late List<List<List<int?>>> bingoCards;
  late List<Set<String>> _markedList;
  late List<List<List<int>>> _patternPositionsList;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<List<int>> selectedPatternPositions = [];

  @override
  void initState() {
    super.initState();
    bingoCards = [];
    _markedList = [];
    _patternPositionsList = [];
    _loadSelectedPattern().then((_) {
      for (var cardId in widget.selectedNumbers) {
        final card = _loadBingoCard(cardId);
        bingoCards.add(card);
        _markedList.add(<String>{});
        _patternPositionsList.add(selectedPatternPositions);
      }
      setState(() {});
    });
  }

  Future<void> _loadSelectedPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPattern = prefs.getString('selectedPattern');
    if (savedPattern != null && savedPattern.isNotEmpty) {
      final patternNames = savedPattern.contains(':')
          ? savedPattern.split(':')[1].split('+').map((e) => e.trim()).toList()
          : [savedPattern];

      selectedPatternPositions = [];
      for (final pName in patternNames) {
        final lines = bingoPatternMap[pName];
        if (lines != null) {
          selectedPatternPositions.addAll(
            lines
                .expand((line) => line.map(_cellIdToGridPos))
                .where((pos) => pos[0] != -1),
          );
        }
      }
    }
  }

  List<int> _cellIdToGridPos(String cellId) {
    if (cellId.length != 2) return [-1, -1];
    final colMap = {'b': 0, 'i': 1, 'n': 2, 'g': 3, 'o': 4};
    final col = colMap[cellId[0].toLowerCase()] ?? -1;
    final row = int.tryParse(cellId[1]);
    if (row == null) return [-1, -1];
    return [row - 1, col];
  }

  List<List<int?>> _loadBingoCard(int cardId) {
    final cardMap = cards.firstWhere(
      (c) => c['cardId'] == cardId,
      orElse: () => {},
    );

    if (cardMap.isEmpty)
      return List.generate(5, (_) => List<int?>.filled(5, null));

    int? toInt(dynamic value) => value == null ? null : value as int?;

    return List.generate(5, (r) {
      return List.generate(5, (c) {
        final colKeys = ['b', 'i', 'n', 'g', 'o'];
        final key = colKeys[c] + (r + 1).toString();
        return toInt(cardMap[key]);
      });
    });
  }

  

  Widget _buildCardNumbers() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.selectedNumbers.length, (index) {
        final number = widget.selectedNumbers[index];
        final isCurrent = _currentPage == index;

        return GestureDetector(
          onTap: () => _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isCurrent ? 35 : 20,
            height: isCurrent ? 35 : 20,
            decoration: BoxDecoration(
              gradient: isCurrent
                  ? const LinearGradient(
                      colors: [Colors.teal, Colors.greenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isCurrent ? null : Colors.white60,
              borderRadius: BorderRadius.circular(isCurrent ? 12 : 8),
              boxShadow: [
                BoxShadow(
                  color: isCurrent
                      ? Colors.teal.withOpacity(0.4)
                      : Colors.black12,
                  blurRadius: isCurrent ? 6 : 2,
                  spreadRadius: isCurrent ? 1 : 0,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isCurrent ? Colors.teal.shade700 : Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "$number",
              style: TextStyle(
                fontSize: isCurrent ? 14 : 11,
                fontWeight: FontWeight.bold,
                color: isCurrent ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }),
    );
  }

  // void _goToPatternChoose() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => const PatternChoose()),
  //   );
  // }
  Future<void> _goToPatternChoose() async {
    // Navigate to PatternChoose page and wait until it returns
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatternChoose()),
    );

    // After returning, reload the selected pattern
    await _loadSelectedPattern();

    // Update all card pattern positions
    for (int i = 0; i < bingoCards.length; i++) {
      _patternPositionsList[i] = selectedPatternPositions;
    }

    // Refresh UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final letters = ["B", "I", "N", "G", "O"];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Spacer(),
            // Circular card numbers
            _buildCardNumbers(),
            const Spacer(),
            // Push the icon to the end
            IconButton(
              onPressed: _goToPatternChoose,
              icon: const Icon(Icons.grid_view),
              tooltip: "Choose Pattern",
            ),
          ],
        ),
      ),

      body: PageView.builder(
        controller: _pageController,
        itemCount: bingoCards.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, cardIndex) {
          final card = bingoCards[cardIndex];
          final marked = _markedList[cardIndex];
          final patternPositions = _patternPositionsList[cardIndex];

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  "Card ${widget.selectedNumbers[cardIndex]}", // show actual selected number
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: letters
                      .map(
                        (e) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: List.generate(5, (r) {
                        return Row(
                          children: List.generate(5, (c) {
                            final num = card[r][c];
                            final key = "$r-$c";
                            bool isMarked = marked.contains(key);
                            bool isPattern = patternPositions.any(
                              (pos) => pos[0] == r && pos[1] == c,
                            );

                            Color bgColor;
                            Color borderColor;
                            Color textColor;

                            if (isMarked) {
                              bgColor = Colors.green.shade400;
                              borderColor = Colors.green.shade700;
                              textColor = Colors.white;
                            } else if (isPattern) {
                              bgColor = Colors.yellow.shade400;
                              borderColor = Colors.orange.shade700;
                              textColor = Colors.black87;
                            } else {
                              bgColor = Colors.grey.shade100;
                              borderColor = Colors.grey.shade400;
                              textColor = Colors.black87;
                            }

                            return GestureDetector(
                              onTap: () {
                                final key = "$r-$c";
                                // Only mark if not already marked
                                if (!_markedList[cardIndex].contains(key)) {
                                  setState(() {
                                    _markedList[cardIndex].add(key);
                                  });
                                }
                              },
                              onDoubleTap: () {
                                final key = "$r-$c";
                                // Unmark only if already marked
                                if (_markedList[cardIndex].contains(key)) {
                                  setState(() {
                                    _markedList[cardIndex].remove(key);
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                margin: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      _markedList[cardIndex].contains("$r-$c")
                                      ? Colors.green.shade400
                                      : _patternPositionsList[cardIndex].any(
                                          (pos) => pos[0] == r && pos[1] == c,
                                        )
                                      ? Colors.yellow.shade400
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        _markedList[cardIndex].contains("$r-$c")
                                        ? Colors.green.shade700
                                        : _patternPositionsList[cardIndex].any(
                                            (pos) => pos[0] == r && pos[1] == c,
                                          )
                                        ? Colors.orange.shade700
                                        : Colors.grey.shade400,
                                    width: 1.8,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${card[r][c]}",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          _markedList[cardIndex].contains(
                                            "$r-$c",
                                          )
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("BINGO pressed on Card ${cardIndex + 1}!"),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "BINGO",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
