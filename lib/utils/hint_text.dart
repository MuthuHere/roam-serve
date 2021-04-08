import 'package:flutter/material.dart';

class HintText extends StatelessWidget {
  final hint;

  HintText(this.hint);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$hint',
      style: Theme.of(context).textTheme.headline5.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
