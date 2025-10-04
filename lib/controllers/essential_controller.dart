import 'dart:math';

import 'package:get/get.dart';

import '../services/essential_service.dart';

class EssentialController extends GetxController {
  var loading = false.obs;
  var brandLoading = false.obs;
  var stateLoading = false.obs;
  var districtLoading = false.obs;
  var pinCodeLoading = false.obs;

  var product = [].obs;
  var country = [].obs;
  var state = [].obs;
  var district = [].obs;
  var pinCode = [].obs;
  var brand = [].obs;

  var essential = EssentialService();

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  void reset() {
    product.clear();
    country.clear();
    state.clear();
    district.clear();
    pinCode.clear();
    brand.clear();
  }

  Future<void> init() async {
    loading.value = true;
    try {
      var data = await essential.list();
      product.value = data['service_product'];
      country.value = data['country'];
    } finally {
      loading.value = false;
    }
  }

  Future<void> getServiceBrand(id) async {
    if (id == null || id == '') return;
    brandLoading.value = true;
    try {
      var data = await essential.getServiceBrand(id);
      brand.value = data;
    } finally {
      brandLoading.value = false;
    }
  }

  Future<void> getCountryState(id) async {
    print('Get Country State: $id');
    if (id == null || id == '') return;

    stateLoading.value = true;
    try {
      var data = await essential.getCountryState(id);
      state.value = data;
    } finally {
      stateLoading.value = false;
    }
  }

  Future<void> getStateDistrict(id) async {
    print('Get State District: $id');
    if (id == null || id == '') return;
    districtLoading.value = true;
    try {
      var data = await essential.getStateDistrict(id);
      district.value = data;
    } finally {
      districtLoading.value = false;
    }
  }

  Future<void> getDistrictPinCode(id) async {
    print('Get District PinCode: $id');
    if (id == null || id == '') return;
    pinCodeLoading.value = true;
    try {
      var data = await essential.getDistrictPinCode(id);
      pinCode.value = data;
    } finally {
      pinCodeLoading.value = false;
    }
  }
}
