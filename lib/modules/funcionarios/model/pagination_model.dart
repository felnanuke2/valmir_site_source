import 'dart:convert';

class Pagination {
  final int pageSize;
  final int totalResults;
  final int totalPages;
  final int page;
  final String previous;
  final String next;
  Pagination({
    required this.pageSize,
    required this.totalResults,
    required this.totalPages,
    required this.page,
    required this.previous,
    required this.next,
  });

  Map<String, dynamic> toMap() {
    return {
      'pageSize': pageSize,
      'totalResults': totalResults,
      'totalPages': totalPages,
      'page': page,
      'previous': previous,
      'next': next,
    };
  }

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      pageSize: map['pageSize'],
      totalResults: map['totalResults'],
      totalPages: map['totalPages'],
      page: map['page'],
      previous: map['previous'],
      next: map['next'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Pagination.fromJson(String source) => Pagination.fromMap(json.decode(source));
}
