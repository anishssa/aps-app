import 'dart:math';

import 'package:get/get.dart';

import '../models/address.dart';
import '../services/address_service.dart';

class AddressActionController extends GetxController {
  var loading = false.obs;
  var deleteLoading = false.obs;


  var id = ''.obs;
  var address1 = '';
  var address2 = '';
  var phone = '';
  var pinCodeId = '';
  var countryId = '';
  var stateId = '';
  var districtId  = '';

  var message = ''.obs;
  var address = Rxn<Address>();

  var addressService = AddressService();

  @override
  void onInit() async {
    print('Address Init Action Controller Init');
    super.onInit();
    await init();
  }

  Future<void> init() async {
    loading.value = true;
    id.value = '';
    try {
      var data = await addressService.listAddress();
      address.value = data ?? null;
      if (address.value != null) {
        id.value = address.value!.id.toString();
      }
    } finally {
      loading.value = false;
    }
  }


  Future<void> addAddress() async {
    loading.value = true;
    try {
      var data = {
        'address_type': 'service_address',
        'address_line1': address1,
        'address_line2': address2,
        'phone': phone,
        'pincode_id': pinCodeId,
        'district_id': districtId,
        'state_id': stateId,
        'country_id': countryId,
      };
      var result;
      if (id.value != '') {
         result = await addressService.update(id.value, data);
      } else {
         result = await addressService.save(data);
      }
      message.value = result;
    }
    finally {
      loading.value = false;
    }
  }


  Future<void> deleteAddress(id) async {
    deleteLoading.value = true;
    try {
      var data = await addressService.deleteAddress(id);
    } finally {
      deleteLoading.value = false;
    }
  }

}

