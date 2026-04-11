class PaginationModel {
  const PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
  });

  final int page;
  final int limit;
  final int total;
}
