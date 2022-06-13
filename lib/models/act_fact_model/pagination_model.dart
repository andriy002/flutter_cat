class PaginationCatFactModel {
  const PaginationCatFactModel({
    this.currentPage = 0,
    this.totalRecords = 0,
  });

  factory PaginationCatFactModel.fromJson(Map<String, dynamic> json) {
    return PaginationCatFactModel(
      currentPage: json['current_page'],
      totalRecords: json['total'],
    );
  }

  final int currentPage;
  final int totalRecords;

  PaginationCatFactModel copyWith({
    int? currentPage,
    int? totalRecords,
  }) {
    return PaginationCatFactModel(
      currentPage: currentPage ?? this.currentPage,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }
}
