import 'package:discover/widgets/ui/btn_colored.dart';
import 'package:discover/widgets/ui/custom_dialog.dart';
import 'package:discover/widgets/ui/flat_btn_rounded.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String positiveBtn;
  final VoidCallback onPositive;
  final String negativeBtn;
  final VoidCallback onNegative;
  final bool contentPadding;

  const CustomAlertDialog({
    Key key,
    @required this.title,
    @required this.content,
    this.positiveBtn = "Yes",
    this.negativeBtn = "No",
    @required this.onPositive,
    @required this.onNegative,
    this.contentPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: Theme.of(context).textTheme.title),
          ),
          contentPadding
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: content,
                )
              : content,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatBtnRounded(text: negativeBtn, onPressed: onNegative),
                const SizedBox(width: 12.0),
                BtnColored(text: positiveBtn, onPressed: onPositive),
              ],
            ),
          )
        ],
      ),
    );
  }
}
