class PaginationCatImageModel {
  const PaginationCatImageModel({
    this.currentPage = 0,
    this.totalRecords = 0,
  });

  factory PaginationCatImageModel.fromJson(Map<String, List<String>> json) {
    return PaginationCatImageModel(
      currentPage: int.parse(json['pagination-page']?.first ?? '0'),
      totalRecords: int.parse(json['pagination-count']?.first ?? '0'),
    );
  }

  final int currentPage;
  final int totalRecords;

  PaginationCatImageModel copyWith({
    int? currentPage,
    int? totalRecords,
  }) {
    return PaginationCatImageModel(
      currentPage: currentPage ?? this.currentPage,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }
}
