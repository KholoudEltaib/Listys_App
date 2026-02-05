import 'package:flutter/material.dart';

class ButtonFilter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSwitch;

  const ButtonFilter({
    super.key,
    required this.currentIndex,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSwitch(0),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: currentIndex == 0
                    ? const Color(0xFFF9B933)
                    : const Color(0x12FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x09FFFFFF)),
              ),
              alignment: Alignment.center,
              child: Text(
                "Countries",
                style: TextStyle(
                  color: currentIndex == 0 ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => onSwitch(1),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: currentIndex == 1
                    ? const Color(0xFFF9B933)
                    : const Color(0x12FFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x09FFFFFF)),
              ),
              alignment: Alignment.center,
              child: Text(
                "Places",
                style: TextStyle(
                  color: currentIndex == 1 ? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
