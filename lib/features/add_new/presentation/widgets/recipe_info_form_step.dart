import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';
import '../cubit/add_new_cubit.dart';
import 'add_section_container.dart';

class RecipeInfoFormStep extends StatefulWidget {
  const RecipeInfoFormStep({super.key});

  @override
  State<RecipeInfoFormStep> createState() => _RecipeInfoFormStepState();
}

class _RecipeInfoFormStepState extends State<RecipeInfoFormStep> {
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
      text: (state.cookTime ~/ 60).toString(),
    );
    _minutesController = TextEditingController(
      text: (state.cookTime % 60).toString(),
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
    final h = int.tryParse(_hoursController.text) ?? 0;
    final m = int.tryParse(_minutesController.text) ?? 0;
    context.read<AddNewCubit>().updateCookTime(h * 60 + m);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              AddSectionContainer(
                label: 'Name',
                child: TextField(
                  controller: _titleController,
                  onChanged: (val) =>
                      context.read<AddNewCubit>().updateTitle(val),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: FontFamily.montserrat,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Name your recipe',
                    hintStyle: const TextStyle(color: Color(0xFFADADAD)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 13.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AddSectionContainer(
                label: 'Number',
                child: Row(
                  children: [
                    Text(
                      'Serving for',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (state.servings > 1) {
                          context.read<AddNewCubit>().updateServings(
                            state.servings - 1,
                          );
                        }
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      state.servings.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => context.read<AddNewCubit>().updateServings(
                        state.servings + 1,
                      ),
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'People',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              AddSectionContainer(
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
              SizedBox(height: 20.h),
              AddSectionContainer(
                label: 'Difficulty',
                child: Wrap(
                  spacing: 8.w,
                  children: ['Easy', 'Medium', 'Hard'].map((d) {
                    final isSelected = state.difficulty == d;
                    return _CustomChip(
                      label: d,
                      isSelected: isSelected,
                      onTap: () =>
                          context.read<AddNewCubit>().updateDifficulty(d),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              AddSectionContainer(
                label: 'Dish Type',
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      [
                        'Breakfast',
                        'Lunch',
                        'Snack',
                        'Brunch',
                        'Dessert',
                        'Dinner',
                        'Appetizers',
                      ].map((c) {
                        final isSelected = state.category == c;
                        return _CustomChip(
                          label: c,
                          isSelected: isSelected,
                          onTap: () =>
                              context.read<AddNewCubit>().updateCategory(c),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              AddSectionContainer(
                label: 'Suggested Dietary Target',
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      [
                        'Vegetarian',
                        'High Fat',
                        'Low Fat',
                        'Sugar Free',
                        'Lactose Free',
                        'Gluten Free',
                      ].map((t) {
                        final isSelected = state.tags.contains(t);
                        return _CustomChip(
                          label: t,
                          isSelected: isSelected,
                          onTap: () => context.read<AddNewCubit>().toggleTag(t),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              AddSectionContainer(
                label: 'Hashtags',
                child: TextField(
                  controller: _hashtagsController,
                  onChanged: (val) =>
                      context.read<AddNewCubit>().updateHashtags(val),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontFamily: FontFamily.montserrat,
                  ),
                  decoration: const InputDecoration(
                    hintText: '#egg #Vegan #Sugerfree #lowfat',
                    hintStyle: TextStyle(color: Color(0xFFADADAD)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: FontFamily.montserrat,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w, left: 4.w),
            child: Text(
              suffix,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomChip extends StatelessWidget {
  const _CustomChip({
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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDEE21B) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFADADAD)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E0E0E) : Colors.white,
            fontSize: 11.sp,
            fontFamily: FontFamily.montserrat,
          ),
        ),
      ),
    );
  }
}
