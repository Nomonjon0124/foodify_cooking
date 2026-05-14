import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class NumberedInputTile extends StatefulWidget {
  const NumberedInputTile({
    required this.index,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
    super.key,
    this.onDelete,
    this.isMultiline = false,
  });

  final int index;
  final String initialValue;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onDelete;
  final bool isMultiline;

  @override
  State<NumberedInputTile> createState() => _NumberedInputTileState();
}

class _NumberedInputTileState extends State<NumberedInputTile> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant NumberedInputTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue == _controller.text) return;
    if (widget.initialValue == oldWidget.initialValue) return;

    _controller.value = TextEditingValue(
      text: widget.initialValue,
      selection: TextSelection.collapsed(offset: widget.initialValue.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: widget.isMultiline ? 57.h : 47.h,
          ),
          padding: EdgeInsets.fromLTRB(34.w, 12.h, 40.w, 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            minLines: widget.isMultiline ? 2 : 1,
            maxLines: widget.isMultiline ? null : 1,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              height: 1.25,
              fontWeight: widget.isMultiline
                  ? FontWeight.w400
                  : FontWeight.w700,
              fontFamily: FontFamily.montserrat,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFADADAD),
                fontSize: 12.sp,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 23.r,
            height: 23.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6339),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.index.toString().padLeft(2, '0'),
              style: TextStyle(
                color: const Color(0xFFF6FBF4),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
        if (widget.onDelete != null)
          Positioned(
            right: 12.w,
            bottom: widget.isMultiline ? 12.h : 14.h,
            child: GestureDetector(
              onTap: widget.onDelete,
              child: const Icon(Icons.remove_circle, color: Color(0xFFADADAD)),
            ),
          ),
      ],
    );
  }
}
