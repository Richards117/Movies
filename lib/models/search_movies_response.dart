import 'dart:convert';

import 'package:flutter_application_2_0/models/models.dart';

class SearchResponse {
  int? page;
  List<Movies> results;
  int? totalPages;
  int? totalResults;

  SearchResponse({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory SearchResponse.fromRawJson(String str) =>
      SearchResponse.fromJson(json.decode(str));

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        page: json["page"],
        results:
            List<Movies>.from(json["results"].map((x) => Movies.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
