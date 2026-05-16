import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';

import '../../../../l10n/l10n_extension.dart';
import '../add_new_l10n.dart';
import '../cubit/add_new_cubit.dart';

class RecipePreviewWidget extends StatefulWidget {
  const RecipePreviewWidget({required this.state, super.key});

  final AddNewState state;

  @override
  State<RecipePreviewWidget> createState() => _RecipePreviewWidgetState();
}

class _RecipePreviewWidgetState extends State<RecipePreviewWidget> {
  int _activeTab = 0; // 0: Introduction, 1: Ingredients, 2: Comments

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildRecipeInfo(),
                _buildTabs(),
                _buildTabContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 256.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            image: const DecorationImage(
              image: NetworkImage(
                'https://www.figma.com/api/mcp/asset/51abe9d1-56eb-4f8e-923c-cbbded791ef9',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          left: 15.w,
          bottom: 11.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF353535),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Icon(Icons.star_outline, color: Colors.white, size: 12.r),
                SizedBox(width: 4.w),
                Text(
                  '4.3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 15.w,
          bottom: 11.h,
          child: Row(
            children: [
              Icon(Icons.archive_outlined, color: Colors.white, size: 20.r),
              SizedBox(width: 15.w),
              Icon(Icons.favorite_border, color: Colors.white, size: 20.r),
              SizedBox(width: 15.w),
              Icon(Icons.ios_share, color: Colors.white, size: 20.r),
            ],
          ),
        ),
        _buildAuthorCard(),
      ],
    );
  }

  Widget _buildAuthorCard() {
    return Positioned(
      bottom: -24.h,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 68.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF353535),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              decoration: BoxDecoration(
                color: const Color(0xFF353535),
                borderRadius: BorderRadius.circular(84.r),
              ),
              child: Row(
                children: [
                  Text(
                    'Kelly Mayer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEE21B),
                      borderRadius: BorderRadius.circular(31.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_outline,
                          color: const Color(0xFF353535),
                          size: 12.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '4.8',
                          style: TextStyle(
                            color: const Color(0xFF353535),
                            fontSize: 11.sp,
                            fontFamily: FontFamily.montserrat,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _buildRecipeInfo() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF4058A0),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              widget.state.title.isEmpty
                  ? context.l10n.addNewRecipeTitleFallback
                  : widget.state.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildInfoPill(
                  Icons.trending_down,
                  '${widget.state.calories} Cal',
                ),
                _buildInfoPill(
                  Icons.bolt,
                  context.l10n.addNewDifficultyLabel(widget.state.difficulty),
                ),
                _buildInfoPill(
                  Icons.access_time,
                  '${widget.state.cookTime} Min',
                ),
                _buildInfoPill(Icons.favorite, '435'),
                _buildInfoPill(Icons.chat_bubble_outline, '5'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: const Color(0xFF4058A0)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 11.sp,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          _buildTabItem(0, context.l10n.addNewPreviewIntroduction),
          SizedBox(width: 10.w),
          _buildTabItem(1, context.l10n.addNewPreviewIngredients),
          SizedBox(width: 10.w),
          _buildTabItem(2, context.l10n.addNewPreviewComments),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          height: 37.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFADADAD),
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF0E0E0E)
                    : const Color(0xFFADADAD),
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_activeTab == 0) return _buildIntroduction();
    if (_activeTab == 1) return _buildIngredients();
    return const SizedBox();
  }

  Widget _buildIntroduction() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6339)),
              Text(
                context.l10n.addNewStepsCount(widget.state.steps.length),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF0E0E0E),
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...List.generate(widget.state.steps.length, (index) {
            return _buildStepItem(index + 1, widget.state.steps[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildStepItem(int number, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(35.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            text.isEmpty ? context.l10n.addNewInstructionPlaceholder : text,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          Positioned(
            left: -35.w,
            top: -12.h,
            child: Container(
              width: 25.r,
              height: 25.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6339),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  number.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6339)),
              Text(
                context.l10n.addNewIngredientsCount(
                  widget.state.ingredients.length,
                ),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF0E0E0E),
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...List.generate(widget.state.ingredients.length, (index) {
            return _buildIngredientItem(
              index + 1,
              widget.state.ingredients[index],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(int number, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(35.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            text.isEmpty ? context.l10n.addNewIngredientPlaceholder : text,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          Positioned(
            left: -35.w,
            top: -12.h,
            child: Container(
              width: 25.r,
              height: 25.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6339),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  number.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
