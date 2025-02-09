import 'package:flutter/material.dart';

class FavoriteCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FavoriteCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Favorito'),
        Checkbox(
          value: value,
          onChanged: (value) {
            onChanged(value ?? false);
          },
        ),
      ],
    );
  }
}