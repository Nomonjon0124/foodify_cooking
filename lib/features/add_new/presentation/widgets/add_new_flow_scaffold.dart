import 'package:flutter/material.dart';

class AddNewFlowScaffold extends StatelessWidget {
  const AddNewFlowScaffold({
    required this.header,
    required this.body,
    super.key,
    this.bottomBar,
    this.backgroundColor = const Color(0xFFF6FBF4),
  });

  final Widget header;
  final Widget body;
  final Widget? bottomBar;
  final Color backgroundColor;

  static const maxContentWidth = 430.0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                header,
                Expanded(child: body),
                if (bottomBar != null)
                  SafeArea(
                    top: false,
                    minimum: EdgeInsets.zero,
                    child: bottomBar!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
