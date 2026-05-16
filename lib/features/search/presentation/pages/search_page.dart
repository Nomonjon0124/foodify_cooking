import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../common/widgets/foodify_app_bar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/l10n_extension.dart';
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
      create: (_) => getIt<SearchCubit>()..loadInitial(),
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
          hintText: context.l10n.searchHint,
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
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: state.status == SearchStatus.loading
                      ? const LinearProgressIndicator(minHeight: 2)
                      : const SizedBox(height: 2),
                );
              },
            ),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state.status != SearchStatus.failure) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                  child: Text(
                    state.errorMessage ?? context.l10n.searchLoadFailure,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              },
            ),
            Gap(8.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return TabBarView(
                    children: [
                      SearchRecipesTab(recipes: state.results.recipes),
                      SearchChefsTab(chefs: state.results.chefs),
                      SearchTagsTab(tags: state.results.tags),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
