class CatFactModel {
  const CatFactModel({
    required this.fact,
    required this.length,
  });

  factory CatFactModel.fromJson(Map<String, dynamic> json) {
    return CatFactModel(
      fact: json['fact'],
      length: json['length'],
    );
  }

  final String fact;
  final int length;

  Map<String, dynamic> toJson() => {
        'fact': fact,
        'length': length,
      };

  CatFactModel copyWith({
    String? fact,
    int? length,
  }) {
    return CatFactModel(fact: fact ?? this.fact, length: length ?? this.length);
  }
}
