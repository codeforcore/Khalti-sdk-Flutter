import 'dart:convert';

class KhaltiBanks {
  final String idx;
  final String name;
  final String shortName;
  final String logo;
  final String swiftCode;
  final bool hasCardpayment;
  final bool hasEbanking;
  final bool hasMobileBanking;
  final bool hasMobileCheckout;
  KhaltiBanks({
    required this.idx,
    required this.name,
    required this.shortName,
    required this.logo,
    required this.swiftCode,
    required this.hasCardpayment,
    required this.hasEbanking,
    required this.hasMobileBanking,
    required this.hasMobileCheckout,
  });

  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'name': name,
      'shortName': shortName,
      'logo': logo,
      'swiftCode': swiftCode,
      'hasCardpayment': hasCardpayment,
      'hasEbanking': hasEbanking,
      'hasMobileBanking': hasMobileBanking,
      'hasMobileCheckout': hasMobileCheckout,
    };
  }

  factory KhaltiBanks.fromMap(Map<String, dynamic> map) {
    return KhaltiBanks(
      idx: map['idx'],
      name: map['name'],
      shortName: map['short_name'],
      logo: map['logo'],
      swiftCode: map['swift_code'],
      hasCardpayment: map['has_cardpayment'],
      hasEbanking: map['has_ebanking'],
      hasMobileBanking: map['has_mobile_banking'],
      hasMobileCheckout: map['has_mobile_checkout'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KhaltiBanks.fromJson(String source) =>
      KhaltiBanks.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KhaltiBanks(idx: $idx, name: $name, shortName: $shortName, logo: $logo, swiftCode: $swiftCode, hasCardpayment: $hasCardpayment, hasEbanking: $hasEbanking, hasMobileBanking: $hasMobileBanking, hasMobileCheckout: $hasMobileCheckout)';
  }
}

class KhaltiResponse {
  /// true if operation is [sucess]
  final bool sucess;

  /// Token null if sucess is false
  final String? token;

  /// Message
  final String message;

  KhaltiResponse(
      {this.sucess = false, this.token, this.message = 'Error occured'});

  @override
  String toString() =>
      'KhaltiResponse(sucess: $sucess, token: $token, message: $message)';
}

class KhaltiConfig {
  ///Your Public Key
  final String publicKey;

  /// Users Mobile Number for payment (optional)
  String? mobile;

  /// Amount must be in paisa and greater than equal to 1000 i.e Rs 10
  int amount;

  /// Product id (Product to be sold )
  String productIdentity;

  /// Product Name
  String productName;

  /// Product URL
  String? productUrl;

  KhaltiConfig({
    required this.publicKey,
    this.mobile,
    required this.amount,
    required this.productIdentity,
    required this.productName,
    this.productUrl,
  });

  @override
  String toString() {
    return 'KhaltiConfig(publicKey: $publicKey, mobile: $mobile, amount: $amount, productIdentity: $productIdentity, productName: $productName, productUrl: $productUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'publicKey': publicKey,
      'mobile': mobile,
      'amount': amount,
      'productIdentity': productIdentity,
      'productName': productName,
      'productUrl': productUrl,
    };
  }

  factory KhaltiConfig.fromMap(Map<String, dynamic> map) {
    return KhaltiConfig(
      publicKey: map['publicKey'],
      mobile: map['mobile'],
      amount: map['amount'],
      productIdentity: map['productIdentity'],
      productName: map['productName'],
      productUrl: map['productUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KhaltiConfig.fromJson(String source) =>
      KhaltiConfig.fromMap(json.decode(source));
}
