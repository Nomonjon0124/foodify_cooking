import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class Spacing {
  static Widget get h4 => SizedBox(height: 4.h);
  static Widget get h8 => SizedBox(height: 8.h);
  static Widget get h12 => SizedBox(height: 12.h);
  static Widget get h16 => SizedBox(height: 16.h);
  static Widget get w8 => SizedBox(width: 8.w);
  static Widget get w16 => SizedBox(width: 16.w);
}
