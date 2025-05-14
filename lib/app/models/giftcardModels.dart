import 'dart:convert';

class GiftCardCountriesModel {
  final String isoName;
  final String name;
  final String currencyName;
  final String currencyCode;
  final String flagUrl;

  GiftCardCountriesModel({
    required this.isoName,
    required this.currencyName,
    required this.currencyCode,
    required this.flagUrl,
    required this.name,
  });

  // Factory constructor to parse from JSON
  factory GiftCardCountriesModel.fromJson(Map<String, dynamic> json) {
    return GiftCardCountriesModel(
      isoName: json['isoName'],
      currencyName: json['currencyName'],
      currencyCode: json['currencyCode'],
      flagUrl: json['flagUrl'],
      name: json['name'],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'isoName': isoName,
      'name': name,
      'currencyName': currencyName,
      'currencyCode': currencyCode,
      'flagUrl': flagUrl,
    };
  }
}

// Function to parse the JSON list into a list of GiftCardCountriesModel objects
List<GiftCardCountriesModel> parseGiftCardCategories(List<dynamic> jsonData) {
  return jsonData
      .map((dynamic item) => GiftCardCountriesModel.fromJson(item))
      .toList();
}

class AllGiftcardModel {
  final List<GiftcarModel> content;

  AllGiftcardModel({required this.content});

  // Factory method to parse JSON into AllGiftcardModel
  factory AllGiftcardModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] is List) {
      var contentList = json['content'] as List;
      List<GiftcarModel> giftCards =
          contentList.map((e) => GiftcarModel.fromJson(e)).toList();

      return AllGiftcardModel(content: giftCards);
    } else if (json['content'] is Map) {
      var contentMap = json['content'] as Map<String, dynamic>;
      List<GiftcarModel> giftCards =
          contentMap.values.map((e) => GiftcarModel.fromJson(e)).toList();

      return AllGiftcardModel(content: giftCards);
    } else {
      throw Exception("Unexpected JSON structure for 'content'");
    }
  }

  // Convert AllGiftcardModel back to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content.map((e) => e.toJson()).toList(),
    };
  }
}

class GiftcarModel {
  final int productId;
  final String productName;
  final bool global;
  final String status;
  final bool supportsPreOrder;
  final dynamic senderFee;
  final dynamic senderFeePercentage;
  final dynamic discountPercentage;
  final dynamic denominationType;
  final dynamic recipientCurrencyCode;
  final dynamic minRecipientDenomination;
  final dynamic maxRecipientDenomination;
  final dynamic senderCurrencyCode;
  final dynamic minSenderDenomination;
  final dynamic maxSenderDenomination;
  final List<dynamic> fixedRecipientDenominations;
  final List<dynamic>? fixedSenderDenominations;
  final Map<dynamic, dynamic> fixedRecipientToSenderDenominationsMap;
  final dynamic metadata;
  final List<String> logoUrls;
  final Map<String, dynamic> brand;
  final Map<String, dynamic> category;
  final Map<String, dynamic> country;
  final Map<String, dynamic> redeemInstruction;
  final Map<String, dynamic> additionalRequirements;

  GiftcarModel({
    required this.productId,
    required this.productName,
    required this.global,
    required this.status,
    required this.supportsPreOrder,
    required this.senderFee,
    required this.senderFeePercentage,
    required this.discountPercentage,
    required this.denominationType,
    required this.recipientCurrencyCode,
    this.minRecipientDenomination,
    this.maxRecipientDenomination,
    required this.senderCurrencyCode,
    this.minSenderDenomination,
    this.maxSenderDenomination,
    required this.fixedRecipientDenominations,
    required this.fixedSenderDenominations,
    required this.fixedRecipientToSenderDenominationsMap,
    required this.metadata,
    required this.logoUrls,
    required this.brand,
    required this.category,
    required this.country,
    required this.redeemInstruction,
    required this.additionalRequirements,
  });

  // Factory method to parse JSON into GiftcarModel
  factory GiftcarModel.fromJson(Map<String, dynamic> json) {
    // print("json['metadata'] ${json['metadata']}");
    // dynamic result
    // if(json['fixedRecipientDenominations'] == null){
    //
    // }else{
    //
    // }
    // try{
    //
    // }catch(e){
    //
    // }
    return GiftcarModel(
      productId: json['productId'],
      productName: json['productName'],
      global: json['global'],
      status: json['status'],
      supportsPreOrder: json['supportsPreOrder'],
      senderFee: (json['senderFee'] as num).toDouble(),
      senderFeePercentage: json['senderFeePercentage'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      denominationType: json['denominationType'],
      recipientCurrencyCode: json['recipientCurrencyCode'],
      minRecipientDenomination: json['minRecipientDenomination'],
      maxRecipientDenomination: json['maxRecipientDenomination'],
      senderCurrencyCode: json['senderCurrencyCode'],
      minSenderDenomination: json['minSenderDenomination'],
      maxSenderDenomination: json['maxSenderDenomination'],
      fixedRecipientDenominations:
          (json['fixedRecipientDenominations'] ?? [10.0])
              .map((e) => (e as num).toDouble())
              .toList(),
      fixedSenderDenominations: (json['fixedSenderDenominations'] ?? [10.0])
          .map((e) => (e as num).toDouble())
          .toList(),
      fixedRecipientToSenderDenominationsMap:
          (json['fixedRecipientToSenderDenominationsMap'] ?? {})
              .map((key, value) => MapEntry(key, (value as num).toDouble())),
      metadata: json['metadata'] ?? null,
      logoUrls: List<String>.from(json['logoUrls']),
      brand: json['brand'] ?? {},
      category: json['category'] ?? {},
      country: json['country'] ?? {},
      redeemInstruction: json['redeemInstruction'] ?? {},
      additionalRequirements: json['additionalRequirements'] ?? {},
    );
  }

  // Convert GiftcarModel back to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'global': global,
      'status': status,
      'supportsPreOrder': supportsPreOrder,
      'senderFee': senderFee,
      'senderFeePercentage': senderFeePercentage,
      'discountPercentage': discountPercentage,
      'denominationType': denominationType,
      'recipientCurrencyCode': recipientCurrencyCode,
      'minRecipientDenomination': minRecipientDenomination,
      'maxRecipientDenomination': maxRecipientDenomination,
      'senderCurrencyCode': senderCurrencyCode,
      'minSenderDenomination': minSenderDenomination,
      'maxSenderDenomination': maxSenderDenomination,
      'fixedRecipientDenominations': fixedRecipientDenominations,
      'fixedSenderDenominations': fixedSenderDenominations,
      'fixedRecipientToSenderDenominationsMap':
          fixedRecipientToSenderDenominationsMap,
      'metadata': metadata,
      'logoUrls': logoUrls,
      'brand': brand,
      'category': category,
      'country': country,
      'redeemInstruction': redeemInstruction,
      'additionalRequirements': additionalRequirements,
    };
  }
}
