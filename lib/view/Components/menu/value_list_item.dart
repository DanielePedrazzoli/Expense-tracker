import 'package:flutter/material.dart';

class ValueListItem extends StatelessWidget {
  final String title;
  final Widget value;
  final Function? onTap;
  final double padding;
  const ValueListItem({super.key, required this.title, required this.value, this.onTap, this.padding = 8});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            value,
          ],
        ),
      ),
    );
  }
}
