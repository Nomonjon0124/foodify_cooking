import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/gen/fonts.gen.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: const Color(0xFF0E0E0E),
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        height: 1.18,
        fontFamily: 'Georgia',
        fontFamilyFallback: const ['Times New Roman', FontFamily.montserrat],
      ),
    );
  }
}
