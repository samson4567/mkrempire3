// class CryptoModel {
//   Status? status;
//   List<Data>? data;

//   CryptoModel({this.status, this.data});

//   CryptoModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'] != null ? Status.fromJson(json['status']) : null;
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (status != null) {
//       data['status'] = status!.toJson();
//     }
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Status {
//   String? timestamp;
//   int? errorCode;
//   Null? errorMessage;
//   int? elapsed;
//   int? creditCount;
//   Null? notice;
//   int? totalCount;

//   Status(
//       {this.timestamp,
//       this.errorCode,
//       this.errorMessage,
//       this.elapsed,
//       this.creditCount,
//       this.notice,
//       this.totalCount});

//   Status.fromJson(Map<String, dynamic> json) {
//     timestamp = json['timestamp'];
//     errorCode = json['error_code'];
//     errorMessage = json['error_message'];
//     elapsed = json['elapsed'];
//     creditCount = json['credit_count'];
//     notice = json['notice'];
//     totalCount = json['total_count'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['timestamp'] = timestamp;
//     data['error_code'] = errorCode;
//     data['error_message'] = errorMessage;
//     data['elapsed'] = elapsed;
//     data['credit_count'] = creditCount;
//     data['notice'] = notice;
//     data['total_count'] = totalCount;
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? name;
//   String? symbol;
//   String? slug;
//   bool? infiniteSupply;
//   int? cmcRank;
//   double? selfReportedCirculatingSupply;
//   double? selfReportedMarketCap;
//   double? tvlRatio;
//   String? lastUpdated;
//   Quote? quote;

//   Data(
//       {this.id,
//       this.name,
//       this.symbol,
//       this.slug,
//       this.infiniteSupply,
//       this.cmcRank,
//       this.selfReportedCirculatingSupply,
//       this.selfReportedMarketCap,
//       this.tvlRatio,
//       this.lastUpdated,
//       this.quote});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     symbol = json['symbol'];
//     slug = json['slug'];
//     infiniteSupply = json['infinite_supply'];
//     cmcRank = json['cmc_rank'];
//     selfReportedCirculatingSupply = json['self_reported_circulating_supply'];
//     selfReportedMarketCap = json['self_reported_market_cap'];
//     tvlRatio = json['tvl_ratio'];
//     lastUpdated = json['last_updated'];
//     quote = json['quote'] != null ? Quote.fromJson(json['quote']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['symbol'] = symbol;
//     data['slug'] = slug;
//     data['infinite_supply'] = infiniteSupply;
//     data['cmc_rank'] = cmcRank;
//     data['self_reported_circulating_supply'] = selfReportedCirculatingSupply;
//     data['self_reported_market_cap'] = selfReportedMarketCap;
//     data['tvl_ratio'] = tvlRatio;
//     data['last_updated'] = lastUpdated;
//     if (quote != null) {
//       data['quote'] = quote!.toJson();
//     }
//     return data;
//   }
// }

// class Quote {
//   USD? uSD;

//   Quote({this.uSD});

//   Quote.fromJson(Map<String, dynamic> json) {
//     uSD = json['USD'] != null ? USD.fromJson(json['USD']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (uSD != null) {
//       data['USD'] = uSD!.toJson();
//     }
//     return data;
//   }
// }

// class USD {
//   double? price;
//   double? volume24h;
//   double? volumeChange24h;
//   double? percentChange1h;
//   double? percentChange24h;
//   double? percentChange7d;
//   double? percentChange30d;
//   double? percentChange60d;
//   double? percentChange90d;
//   double? marketCap;
//   double? marketCapDominance;
//   double? fullyDilutedMarketCap;
//   double? tvl;
//   String? lastUpdated;

//   USD(
//       {this.price,
//       this.volume24h,
//       this.volumeChange24h,
//       this.percentChange1h,
//       this.percentChange24h,
//       this.percentChange7d,
//       this.percentChange30d,
//       this.percentChange60d,
//       this.percentChange90d,
//       this.marketCap,
//       this.marketCapDominance,
//       this.fullyDilutedMarketCap,
//       this.tvl,
//       this.lastUpdated});

//   USD.fromJson(Map<String, dynamic> json) {
//     price = json['price'];
//     volume24h = json['volume_24h'];
//     volumeChange24h = json['volume_change_24h'];
//     percentChange1h = json['percent_change_1h'];
//     percentChange24h = json['percent_change_24h'];
//     percentChange7d = json['percent_change_7d'];
//     percentChange30d = json['percent_change_30d'];
//     percentChange60d = json['percent_change_60d'];
//     percentChange90d = json['percent_change_90d'];
//     marketCap = json['market_cap'];
//     marketCapDominance = json['market_cap_dominance'];
//     fullyDilutedMarketCap = json['fully_diluted_market_cap'];
//     tvl = json['tvl'];
//     lastUpdated = json['last_updated'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['price'] = price;
//     data['volume_24h'] = volume24h;
//     data['volume_change_24h'] = volumeChange24h;
//     data['percent_change_1h'] = percentChange1h;
//     data['percent_change_24h'] = percentChange24h;
//     data['percent_change_7d'] = percentChange7d;
//     data['percent_change_30d'] = percentChange30d;
//     data['percent_change_60d'] = percentChange60d;
//     data['percent_change_90d'] = percentChange90d;
//     data['market_cap'] = marketCap;
//     data['market_cap_dominance'] = marketCapDominance;
//     data['fully_diluted_market_cap'] = fullyDilutedMarketCap;
//     data['tvl'] = tvl;
//     data['last_updated'] = lastUpdated;
//     return data;
//   }
// }
class CryptoModel {
  Status? status;
  List<Data>? data;

  CryptoModel({this.status, this.data});

  CryptoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  String? timestamp;
  int? errorCode;
  dynamic errorMessage;
  int? elapsed;
  int? creditCount;
  dynamic notice;
  int? totalCount;

  Status({
    this.timestamp,
    this.errorCode,
    this.errorMessage,
    this.elapsed,
    this.creditCount,
    this.notice,
    this.totalCount,
  });

  Status.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
    elapsed = json['elapsed'];
    creditCount = json['credit_count'];
    notice = json['notice'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['error_code'] = errorCode;
    data['error_message'] = errorMessage;
    data['elapsed'] = elapsed;
    data['credit_count'] = creditCount;
    data['notice'] = notice;
    data['total_count'] = totalCount;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? symbol;
  String? slug;
  bool? infiniteSupply;
  int? cmcRank;
  dynamic selfReportedCirculatingSupply;
  dynamic selfReportedMarketCap;
  dynamic tvlRatio;
  String? lastUpdated;
  Quote? quote;

  Data({
    this.id,
    this.name,
    this.symbol,
    this.slug,
    this.infiniteSupply,
    this.cmcRank,
    this.selfReportedCirculatingSupply,
    this.selfReportedMarketCap,
    this.tvlRatio,
    this.lastUpdated,
    this.quote,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    slug = json['slug'];
    infiniteSupply = json['infinite_supply'];
    cmcRank = json['cmc_rank'];
    selfReportedCirculatingSupply = json['self_reported_circulating_supply'];
    selfReportedMarketCap = json['self_reported_market_cap'];
    tvlRatio = json['tvl_ratio'];
    lastUpdated = json['last_updated'];
    quote = json['quote'] != null ? Quote.fromJson(json['quote']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['symbol'] = symbol;
    data['slug'] = slug;
    data['infinite_supply'] = infiniteSupply;
    data['cmc_rank'] = cmcRank;
    data['self_reported_circulating_supply'] = selfReportedCirculatingSupply;
    data['self_reported_market_cap'] = selfReportedMarketCap;
    data['tvl_ratio'] = tvlRatio;
    data['last_updated'] = lastUpdated;
    if (quote != null) {
      data['quote'] = quote!.toJson();
    }
    return data;
  }
}

class Quote {
  USD? usd;

  Quote({this.usd});

  Quote.fromJson(Map<String, dynamic> json) {
    usd = json['USD'] != null ? USD.fromJson(json['USD']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (usd != null) {
      data['USD'] = usd!.toJson();
    }
    return data;
  }
}

class USD {
  double? price;
  double? volume24h;
  double? volumeChange24h;
  double? percentChange1h;
  double? percentChange24h;
  double? percentChange7d;
  double? percentChange30d;
  double? percentChange60d;
  double? percentChange90d;
  double? marketCap;
  double? marketCapDominance;
  double? fullyDilutedMarketCap;
  dynamic tvl;
  String? lastUpdated;

  USD({
    this.price,
    this.volume24h,
    this.volumeChange24h,
    this.percentChange1h,
    this.percentChange24h,
    this.percentChange7d,
    this.percentChange30d,
    this.percentChange60d,
    this.percentChange90d,
    this.marketCap,
    this.marketCapDominance,
    this.fullyDilutedMarketCap,
    this.tvl,
    this.lastUpdated,
  });

  USD.fromJson(Map<String, dynamic> json) {
    price = json['price']?.toDouble();
    volume24h = json['volume_24h']?.toDouble();
    volumeChange24h = json['volume_change_24h']?.toDouble();
    percentChange1h = json['percent_change_1h']?.toDouble();
    percentChange24h = json['percent_change_24h']?.toDouble();
    percentChange7d = json['percent_change_7d']?.toDouble();
    percentChange30d = json['percent_change_30d']?.toDouble();
    percentChange60d = json['percent_change_60d']?.toDouble();
    percentChange90d = json['percent_change_90d']?.toDouble();
    marketCap = json['market_cap']?.toDouble();
    marketCapDominance = json['market_cap_dominance']?.toDouble();
    fullyDilutedMarketCap = json['fully_diluted_market_cap']?.toDouble();
    tvl = json['tvl'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['volume_24h'] = volume24h;
    data['volume_change_24h'] = volumeChange24h;
    data['percent_change_1h'] = percentChange1h;
    data['percent_change_24h'] = percentChange24h;
    data['percent_change_7d'] = percentChange7d;
    data['percent_change_30d'] = percentChange30d;
    data['percent_change_60d'] = percentChange60d;
    data['percent_change_90d'] = percentChange90d;
    data['market_cap'] = marketCap;
    data['market_cap_dominance'] = marketCapDominance;
    data['fully_diluted_market_cap'] = fullyDilutedMarketCap;
    data['tvl'] = tvl;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
