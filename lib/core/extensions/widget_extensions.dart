import 'package:flutter/widgets.dart';

extension WidgetExtensions on Widget {
  Widget withPadding([EdgeInsetsGeometry padding = const EdgeInsets.all(16)]) {
    return Padding(padding: padding, child: this);
  }
}
