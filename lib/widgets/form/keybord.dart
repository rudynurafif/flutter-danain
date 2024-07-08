import 'package:flutter/material.dart';
import 'package:flutter_danain/widgets/widget_element.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  const PinKeyboard({Key? key, required this.onKeyPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 8),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 8),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 8),
          _buildRow(['', '0', 'backspace']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys
          .map(
            (key) => InkWell(
              onTap: () {
                onKeyPressed(key);
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: key.isEmpty
                    ? const SizedBox.shrink()
                    : key == 'backspace'
                        ? const Icon(
                            Icons.backspace_outlined,
                            size: 24,
                            color: Colors.black,
                          )
                        : Headline(text: key),
              ),
            ),
          )
          .toList(),
    );
  }
}
