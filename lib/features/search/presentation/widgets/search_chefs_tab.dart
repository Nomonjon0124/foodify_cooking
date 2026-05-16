import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entities/search_results.dart';

class SearchChefsTab extends StatelessWidget {
  const SearchChefsTab({super.key, required this.chefs});

  final List<SearchChef> chefs;

  @override
  Widget build(BuildContext context) {
    if (chefs.isEmpty) {
      return Center(child: Text(context.l10n.searchNoChefs));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 16.h, 0, 118.h),
        itemCount: chefs.length,
        itemBuilder: (context, index) =>
            _ChefItem(chef: chefs[index], isHighlighted: index == 2),
      ),
    );
  }
}

class _ChefItem extends StatelessWidget {
  const _ChefItem({required this.chef, this.isHighlighted = false});

  final SearchChef chef;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        ClipOval(
          child: FoodifyImage(
            chef.avatarUrl,
            width: 48.r,
            height: 48.r,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              chef.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.montserrat,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );

    if (isHighlighted) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Container(
          height: 54.r,
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27.r),
          ),
          child: row,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
      child: SizedBox(height: 48.r, child: row),
    );
  }
}
