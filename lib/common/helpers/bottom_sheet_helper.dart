import 'package:flutter/material.dart';

abstract final class BottomSheetHelper {
  static Future<T?> showAppBottomSheet<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (_) => child,
      isScrollControlled: true,
    );
  }
}
