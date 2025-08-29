import 'package:flutter/material.dart';
import 'package:offlinebingo/ZeroApp/bingo_play_page.dart';
import 'package:offlinebingo/ZeroApp/pattern_choose.dart';

class NumbersPage extends StatefulWidget {
  const NumbersPage({super.key});

  @override
  State<NumbersPage> createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  final Set<int> _selectedNumbers = {};
  final TextEditingController _numberController = TextEditingController();

  void _toggleNumber(int number) {
    setState(() {
      if (_selectedNumbers.contains(number)) {
        _selectedNumbers.remove(number);
      } else {
        _selectedNumbers.add(number);
      }
    });
  }

  void _goToBingoPage() {
    if (_selectedNumbers.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BingoPage(selectedNumbers: _selectedNumbers.toList()),
      ),
    );
  }

  void _goToPatternChoose() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PatternChoose()),
    );
  }

  void _addNumberFromInput() {
    final input = _numberController.text.trim();
    if (input.isEmpty) return;
    final numValue = int.tryParse(input);
    if (numValue != null && numValue >= 1 && numValue <= 200) {
      _toggleNumber(numValue);
    }
    _numberController.clear();
  }

  void _clearMarkedNumbers() {
    setState(() {
      _selectedNumbers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Select Player Numbers updated new"),
        foregroundColor: Colors.grey.shade100,
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: _goToPatternChoose,
            icon: const Icon(Icons.grid_view),
            tooltip: "Choose Patterns",
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Form to add number
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter number",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addNumberFromInput(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNumberFromInput,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _clearMarkedNumbers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Clear", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),

          // Numbers grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: 200,
              itemBuilder: (context, index) {
                final number = index + 1;
                final isSelected = _selectedNumbers.contains(number);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Colors.greenAccent, Colors.green.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.blue.shade100,
                              Colors.blue.shade200,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.6),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                    border: Border.all(
                      color: isSelected
                          ? Colors.green.shade900
                          : Colors.black26,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _toggleNumber(number),
                      splashColor: Colors.white24,
                      child: Center(
                        child: Text(
                          "$number",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Go to Bingo page button
          Padding(
            padding: const EdgeInsets.all(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _selectedNumbers.isNotEmpty
                    ? const LinearGradient(
                        colors: [Colors.teal, Colors.tealAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade600, Colors.grey.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: _selectedNumbers.isNotEmpty
                    ? [
                        BoxShadow(
                          color: Colors.tealAccent.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _selectedNumbers.isNotEmpty ? _goToBingoPage : null,
                  splashColor: Colors.white24,
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    child: Center(
                      child: Text(
                        "Go to Player Page (${_selectedNumbers.length} selected) numbers",
                        style: TextStyle(
                          fontSize: 16, // smaller text
                          fontWeight: FontWeight.bold,
                          color: _selectedNumbers.isNotEmpty
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
