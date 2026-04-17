part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({this.query = ''});

  final String query;

  SearchState copyWith({String? query}) =>
      SearchState(query: query ?? this.query);

  @override
  List<Object?> get props => [query];
}
