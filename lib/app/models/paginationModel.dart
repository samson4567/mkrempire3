class PaginationModel {
  int currentPage;
  List<dynamic> data;
  String firstPageUrl;
  int? from;
  int lastPage;
  String lastPageUrl;
  List<LinkModel> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int total;

  PaginationModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    List<LinkModel> linksList = [];
    if (json['links'] != null) {
      linksList = List<LinkModel>.from(
        (json['links'] as List).map((link) => LinkModel.fromJson(link)),
      );
    }

    return PaginationModel(
      currentPage: json['current_page'] ?? 1,
      data: json['data'] ?? [],
      firstPageUrl: json['first_page_url'] ?? '',
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      lastPageUrl: json['last_page_url'] ?? '',
      links: linksList,
      nextPageUrl: json['next_page_url'],
      path: json['path'] ?? '',
      perPage: json['per_page'] ?? 10,
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }
}

class LinkModel {
  String? url;
  String label;
  bool active;

  LinkModel({
    this.url,
    required this.label,
    required this.active,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    return LinkModel(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
