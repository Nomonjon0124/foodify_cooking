import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../add_new_constants.dart';
import '../cubit/add_new_cubit.dart';
import 'section_card.dart';

class RecipeInfoStep extends StatefulWidget {
  const RecipeInfoStep({super.key});

  @override
  State<RecipeInfoStep> createState() => _RecipeInfoStepState();
}

class _RecipeInfoStepState extends State<RecipeInfoStep> {
  late final TextEditingController _titleController;
  late final TextEditingController _hashtagsController;
  late final TextEditingController _hoursController;
  late final TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddNewCubit>().state;
    _titleController = TextEditingController(text: state.title);
    _hashtagsController = TextEditingController(text: state.hashtags);
    _hoursController = TextEditingController(
      text: (state.cookTime ~/ 60) == 0 ? '' : '${state.cookTime ~/ 60}',
    );
    _minutesController = TextEditingController(
      text: (state.cookTime % 60) == 0 ? '' : '${state.cookTime % 60}',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hashtagsController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _updateCookTime() {
    final hours = int.tryParse(_hoursController.text.trim()) ?? 0;
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;
    context.read<AddNewCubit>().updateCookTime((hours * 60) + minutes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 4.h),
          child: Column(
            children: [
              SectionCard(
                label: 'Name',
                child: _RecipeField(
                  controller: _titleController,
                  hintText: 'Name your recipe',
                  filled: true,
                  textColor: const Color(0xFF353535),
                  onChanged: context.read<AddNewCubit>().updateTitle,
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Number',
                child: Row(
                  children: [
                    _MetaText('Serving for'),
                    const Spacer(),
                    _AdjusterButton(
                      icon: Icons.remove_circle,
                      onTap: () => context.read<AddNewCubit>().updateServings(
                        state.servings - 1,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${state.servings}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    _AdjusterButton(
                      icon: Icons.add_circle,
                      onTap: () => context.read<AddNewCubit>().updateServings(
                        state.servings + 1,
                      ),
                    ),
                    const Spacer(),
                    _MetaText('People'),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Cook Time',
                child: Row(
                  children: [
                    Expanded(
                      child: _TimeInput(
                        controller: _hoursController,
                        suffix: 'h',
                        onChanged: (_) => _updateCookTime(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _TimeInput(
                        controller: _minutesController,
                        suffix: 'm',
                        onChanged: (_) => _updateCookTime(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Difficulty',
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: AddNewConstants.difficultyOptions
                      .map(
                        (option) => _OptionChip(
                          label: option,
                          isSelected: state.difficulty == option,
                          onTap: () => context
                              .read<AddNewCubit>()
                              .updateDifficulty(option),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Dish Type',
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: AddNewConstants.dishTypeOptions
                      .map(
                        (option) => _OptionChip(
                          label: option,
                          isSelected: state.category == option,
                          onTap: () => context
                              .read<AddNewCubit>()
                              .updateCategory(option),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Suggested Dietary Target',
                labelWidth: 214,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: AddNewConstants.dietaryTargetOptions
                      .map(
                        (option) => _OptionChip(
                          label: option,
                          isSelected: state.tags.contains(option),
                          onTap: () =>
                              context.read<AddNewCubit>().toggleTag(option),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 10.h),
              SectionCard(
                label: 'Hashtags',
                child: _RecipeField(
                  controller: _hashtagsController,
                  hintText: '#egg #Vegan #Sugerfree #lowfat',
                  filled: false,
                  textColor: Colors.white,
                  onChanged: context.read<AddNewCubit>().updateHashtags,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecipeField extends StatelessWidget {
  const _RecipeField({
    required this.controller,
    required this.hintText,
    required this.filled,
    required this.textColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final bool filled;
  final Color textColor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        color: textColor,
        fontSize: 12.sp,
        height: 1.25,
        fontFamily: FontFamily.montserrat,
      ),
      decoration: InputDecoration(
        filled: filled,
        fillColor: filled ? Colors.white : Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFFADADAD),
          fontSize: 12.sp,
          fontFamily: FontFamily.montserrat,
        ),
        border: filled
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide.none,
              )
            : InputBorder.none,
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        fontFamily: FontFamily.montserrat,
      ),
    );
  }
}

class _AdjusterButton extends StatelessWidget {
  const _AdjusterButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 24.r),
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.controller,
    required this.suffix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String suffix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFADADAD)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: FontFamily.montserrat,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            suffix,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDEE21B) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFADADAD)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E0E0E) : Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            fontFamily: FontFamily.montserrat,
          ),
        ),
      ),
    );
  }
}
