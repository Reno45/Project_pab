import 'package:flutter/material.dart';

class ProfilInfoItem extends StatelessWidget {
  const ProfilInfoItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      this.showEdition = false,
      this.onEditPressed,
      required this.iconColor});

  final IconData icon;
  final String label;
  final String value;
  final bool showEdition;
  final VoidCallback? onEditPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Row(children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ]),
        ),
        Expanded(
            child: Text(
          ': $value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )),
        if (showEdition)
          IconButton(onPressed: onEditPressed, icon: const Icon(Icons.edit))
      ],
    );
  }
}
