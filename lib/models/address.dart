class Address {
  Address({
    required this.id,
    required this.customerId,
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.districtId,
    required this.stateId,
    required this.countryId,
    required this.pincodeId,
    required this.phone,
    required this.country,
    required this.state,
    required this.district,
    required this.pincode,
  });

  final int? id;
  final int? customerId;
  final String? addressType;
  final String? addressLine1;
  final String? addressLine2;
  final int? districtId;
  final int? stateId;
  final int? countryId;
  final int? pincodeId;
  final String? phone;
  final Country? country;
  final Country? state;
  final Country? district;
  final Pincode? pincode;

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id: json["id"],
      customerId: json["customer_id"],
      addressType: json["address_type"],
      addressLine1: json["address_line1"],
      addressLine2: json["address_line2"],
      districtId: json["district_id"],
      stateId: json["state_id"],
      countryId: json["country_id"],
      pincodeId: json["pincode_id"],
      phone: json["phone"],
      country: json["country"] == null ? null : Country.fromJson(json["country"]),
      state: json["state"] == null ? null : Country.fromJson(json["state"]),
      district: json["district"] == null ? null : Country.fromJson(json["district"]),
      pincode: json["pincode"] == null ? null : Pincode.fromJson(json["pincode"]),
    );
  }

}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.status,
    required this.stateId,
    required this.countryId,
  });

  final int? id;
  final String? name;
  final int? status;
  final int? stateId;
  final int? countryId;

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
      id: json["id"],
      name: json["name"],
      status: json["status"],
      stateId: json["state_id"],
      countryId: json["country_id"],
    );
  }

}

class Pincode {
  Pincode({
    required this.id,
    required this.districtId,
    required this.cityName,
    required this.cityPincode,
    required this.status,
  });

  final int? id;
  final int? districtId;
  final String? cityName;
  final String? cityPincode;
  final int? status;

  factory Pincode.fromJson(Map<String, dynamic> json){
    return Pincode(
      id: json["id"],
      districtId: json["district_id"],
      cityName: json["city_name"],
      cityPincode: json["city_pincode"],
      status: json["status"],
    );
  }

}
