import 'address.dart';
import 'master.dart';

class Service {
  Service({
    required this.id,
    required this.customerId,
    required this.serviceBrandId,
    required this.serviceProductId,
    required this.address,
    required this.serviceNo,
    required this.complaintDetails,
    required this.mobileNo,
    required this.countryId,
    required this.stateId,
    required this.pincodeId,
    required this.districtId,
    required this.alternativeNumber,
    required this.verifyPayment,
    required this.status,
    required this.commentAdded,
    required this.serviceProduct,
    required this.district,
    required this.serviceBrand,
    required this.pincode,
    required this.completedAt,
    required this.createdAt,
  });

  final int id;
  final int? customerId;
  final int? serviceBrandId;
  final int? serviceProductId;
  final String? address;
  final String? serviceNo;
  final String? completedAt;
  final String? createdAt;
  final String? complaintDetails;
  final String? mobileNo;
  final int? countryId;
  final int? stateId;
  final int? pincodeId;
  final int? districtId;
  final String? alternativeNumber;
  final int? verifyPayment;
  final String? status;
  int commentAdded;
  final Master? serviceProduct;
  final Master? district;
  final Master? serviceBrand;
  final Pincode? pincode;

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"],
      customerId: json["customer_id"],
      serviceBrandId: json["service_brand_id"],
      serviceProductId: json["service_product_id"],
      address: json["address"],
      serviceNo: json["service_no"],
      complaintDetails: json["complaint_details"],
      mobileNo: json["mobile_no"],
      countryId: json["country_id"],
      stateId: json["state_id"],
      pincodeId: json["pincode_id"],
      districtId: json["district_id"],
      alternativeNumber: json["alternative_number"],
      verifyPayment: json["verify_payment"],
      createdAt: json["created_at"],
      completedAt: json["completed_at"],
      status: json["status"],
      commentAdded: json["comment_added"],
      serviceProduct: json["service_product"] == null ? null : Master.fromJson(json["service_product"]),
      district: json["district"] == null ? null : Master.fromJson(json["district"]),
      serviceBrand: json["service_brand"] == null ? null : Master.fromJson(json["service_brand"]),
      pincode: json["pincode"] == null ? null : Pincode.fromJson(json["pincode"]),
    );
  }
}
