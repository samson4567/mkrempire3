class BettingModel{

  final String id;
  final String title;
  final bool active;
  final String logoUrl;
  final String slug;
  final String category;
  BettingModel( {
    required this.id,
    required this.title,
    required this.active,
    required this.logoUrl,
    required this.slug,
    required this.category,
});


  factory BettingModel.fromJson(Map<String, dynamic> json){
    return BettingModel(
        id: json['id'] as String ,
        title: json['title']  as String ,
        active: json['active'] as bool ,
        logoUrl: json['logo_url'] as String ,
        slug: json['slug'] as String ,
        category: json['category'] as String
    );
  }
}