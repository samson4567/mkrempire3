class InternetServicesModel{

  final String id;
  final String title;
  final bool active;

  InternetServicesModel({
    required this.id,
    required this.title,
    required this.active,
  });


  factory InternetServicesModel.fromJson(Map<String, dynamic> json){
    return InternetServicesModel(
        id: json['id'] ,
        title: json['title']  ,
        active: json['active']
    );
  }
}