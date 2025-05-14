import 'package:get/get.dart';

class ServicesModel {
  final String id;
  final String name;

  final String imageAsset;
  final bool isActive;
  ServicesModel({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.isActive,
  });

  // factory ServicesModel.fromJson(Map<String, dynamic> json) {
  //   return ServicesModel(
  //     status: json['status'] ?? false,
  //     description: json['description'] ?? 'No description available',
  //     details: (json['message']?['details'] as List<dynamic>? ?? [])
  //         .map((e) => Services.fromJson(e as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }
}

class ServicesModels {
  final bool status;
  final String description;
  final List<Services> details;

  ServicesModels({
    required this.status,
    required this.description,
    required this.details,
  });

  factory ServicesModels.fromJson(Map<String, dynamic> json) {
    return ServicesModels(
      status: json['status'] ?? false,
      description: json['description'] ?? 'No description available',
      details: (json['message']?['details'] as List<dynamic>? ?? [])
          .map((e) => Services.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Services {
  final String id;
  final String title;
  final String slug;
  final String category;
  final String logoUrl;
  final bool active;

  Services({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.logoUrl,
    required this.active,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    print('services json $json');
    return Services(
      id: json['id']?.toString() ?? 'Unknown ID',
      title: json['title'] ?? 'No Title',
      slug: json['slug'] ?? 'No Slug',
      category: json['category'] ?? 'No Category',
      logoUrl: json['logo_url'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
