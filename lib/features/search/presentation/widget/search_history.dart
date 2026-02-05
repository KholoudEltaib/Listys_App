import 'package:flutter/material.dart';

class HistoryWidget extends StatelessWidget {
  final List<String> history;
  final Function(String) onHistoryTap;
  final Function(String) onHistoryRemove;
  final VoidCallback onClearAll;

  const HistoryWidget({
    super.key,
    required this.history,
    required this.onHistoryTap,
    required this.onHistoryRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: onClearAll,
              child: const Text(
                "Clear all",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Column(
          children: history.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => onHistoryTap(item),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onHistoryRemove(item),
                      child: const Icon(Icons.close, color: Colors.white70, size: 20),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}