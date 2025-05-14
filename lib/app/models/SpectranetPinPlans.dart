class SpectranetPinPlans{

  final String id;
  final String title;
  final dynamic amount;

  SpectranetPinPlans({
    required this.id,
    required this.title,
    required this.amount,
  });


  factory SpectranetPinPlans.fromJson(Map<String, dynamic> json){
    return SpectranetPinPlans(
        id: json['id'] ,
        title: json['title']  ,
        amount: json['amount']
    );
  }
}
