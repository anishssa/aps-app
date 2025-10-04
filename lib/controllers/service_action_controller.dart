import 'dart:math';

import 'package:get/get.dart';

import '../services/service_service.dart';

class ServiceActionController extends GetxController {
  var loading = false.obs;

  var brandId = '';
  var productId = '';
  var address = '';
  var complaintDetails = '';
  var mobileNo = '';
  var pinCodeId = '';
  var countryId = '';
  var stateId = '';
  var districtId  = '';
  var alternativeNumber = '';

  var message = ''.obs;

  var service = ServiceService();

  @override
  void onInit() async {
    super.onInit();
  }

  void reset() {
    brandId = '';
    productId = '';
    address = '';
    complaintDetails = '';
    mobileNo = '';
    pinCodeId = '';
    countryId = '';
    stateId = '';
    districtId  = '';
    alternativeNumber = '';
    message.value = '';
  }

  Future<void> addService() async {
    loading.value = true;
    try {
      var data = {
        'service_brand_id': brandId,
        'service_product_id': productId,
        'address': address,
        'complaint_details': complaintDetails,
        'mobile_no': mobileNo,
        'pincode_id': pinCodeId,
        'district_id': districtId,
        'state_id': stateId,
        'country_id': countryId,
        'alternative_number': alternativeNumber,
      };
      var result = await service.save(data);
      message.value = result;
    }
    finally {
      loading.value = false;
    }
  }

}

