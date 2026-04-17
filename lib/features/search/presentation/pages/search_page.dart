import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../common/widgets/foodify_app_bar.dart';
import '../cubit/search_cubit.dart';
import '../widgets/search_chefs_tab.dart';
import '../widgets/search_recipes_tab.dart';
import '../widgets/search_tab_bar.dart';
import '../widgets/search_tags_tab.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: FoodifyAppBar.searchFilter(
          onChanged: (q) => context.read<SearchCubit>().updateQuery(q),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: const SearchTabBar(),
            ),
            Gap(8.h),
            const Expanded(
              child: TabBarView(
                children: [
                  SearchRecipesTab(),
                  SearchChefsTab(),
                  SearchTagsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
