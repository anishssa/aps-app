import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/BottomSheetDropdownComponent.dart';
import '../components/ButtonComponent.dart';
import '../components/DropDownInputComponent.dart';
import '../components/SnackBarComponent.dart';
import '../controllers/essential_controller.dart';
import '../components/InputComponent.dart';
import '../controllers/service_action_controller.dart';
import '../controllers/service_controller.dart';
import 'index.dart';

class ServiceAction extends StatefulWidget {
  const ServiceAction({Key? key}) : super(key: key);

  @override
  _ServiceActionState createState() => _ServiceActionState();
}

class _ServiceActionState extends State<ServiceAction> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

  final controller = Get.put(EssentialController());
  final serviceController = Get.put(ServiceActionController());
  final serviceListController = Get.find<ServiceController>();

  Map<String, dynamic>? selectedValue(List<dynamic> array, String id) {
    return array.firstWhereOrNull((e) => e['id'].toString() == id);
  }

  @override
  Widget build(BuildContext context) {
    return IndexPage(
      title: 'Add Service',
      index: 1,
      page: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              controller.reset();
              controller.init();
              _formKey.currentState?.reset();
              serviceController.reset();
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        final product = controller.product.value;
                        return BottomSheetDropdownComponent(
                          label: "Product",
                          hintText: 'Select Product',
                          options: product,
                          displayField: 'name',
                          value: selectedValue(
                            product,
                            serviceController.productId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.productId = id;
                            serviceController.brandId = '';
                            controller.getServiceBrand(id);
                            setState(() {});
                          },
                          prefixIcon: Icons.shopping_bag,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a product';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        final brand = controller.brand.value;
                        return BottomSheetDropdownComponent(
                          label: "Brand",
                          hintText: 'Select Brand',
                          options: brand,
                          displayField: 'name',
                          value: selectedValue(
                            brand,
                            serviceController.brandId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.brandId = id;
                            setState(() {});
                          },
                          loading: controller.brandLoading.value,
                          prefixIcon: Icons.branding_watermark,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a brand';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      InputComponent(
                        label: 'Detail',
                        prefixIcon: Icons.description,
                        minLines: 2,
                        maxLines: 5,
                        hintText: 'Complaint Detail',
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter a detail';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          serviceController.complaintDetails = value ?? '';
                        },
                      ),
                      const SizedBox(height: 16),
                      InputComponent(
                        label: 'Phone',
                        prefixIcon: Icons.phone,
                        hintText: 'Enter your phone',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter a phone';
                          }
                          if (value != null && value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          serviceController.mobileNo = value ?? '';
                        },
                      ),
                      const SizedBox(height: 16),
                      InputComponent(
                        label: 'Alternative Phone',
                        prefixIcon: Icons.phone,
                        hintText: 'Enter your phone',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length != 10) {
                            return 'Phone number must be 10 digits';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          serviceController.alternativeNumber = value ?? '';
                        },
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final country = controller.country.value;
                        return BottomSheetDropdownComponent(
                          label: "Country",
                          hintText: 'Select Country',
                          options: country,
                          displayField: 'name',
                          value: selectedValue(
                            country,
                            serviceController.countryId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.countryId = id;
                            controller.getCountryState(id);
                            setState(() {});
                          },
                          prefixIcon: Icons.public,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a country';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        final state = controller.state.value;
                        return BottomSheetDropdownComponent(
                          label: "State",
                          hintText: 'Select State',
                          options: state,
                          displayField: 'name',
                          value: selectedValue(
                            state,
                            serviceController.stateId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.stateId = id;
                            controller.getStateDistrict(id);
                            setState(() {});
                          },
                          prefixIcon: Icons.map,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a state';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        final district = controller.district.value;
                        return BottomSheetDropdownComponent(
                          label: "District",
                          hintText: 'Select District',
                          options: district,
                          displayField: 'name',
                          value: selectedValue(
                            district,
                            serviceController.districtId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.districtId = id;
                            controller.getDistrictPinCode(id);
                            setState(() {});
                          },
                          prefixIcon: Icons.location_on,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a District';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      Obx(() {
                        final pinCode = controller.pinCode.value;
                        print(pinCode);
                        return BottomSheetDropdownComponent(
                          label: "pincode",
                          hintText: 'Select pincode',
                          options: pinCode,
                          displayField: 'name',
                          value: selectedValue(
                            pinCode,
                            serviceController.pinCodeId,
                          ),
                          onChanged: (selected) {
                            final id = selected?['id']?.toString() ?? '';
                            serviceController.pinCodeId = id;
                            setState(() {});
                          },
                          prefixIcon: Icons.pin_drop,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a pincode';
                            }
                            return null;
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      InputComponent(
                        label: 'Address',
                        prefixIcon: Icons.home,
                        minLines: 2,
                        maxLines: 5,
                        hintText: 'Enter your address',
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Please enter a address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          serviceController.address = value ?? '';
                        },
                      ),

                      const SizedBox(height: 16),
                      Obx(
                        () => serviceController.loading.value
                            ? const CircularProgressIndicator()
                            : ButtonComponent(
                                text: 'Save',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    try {
                                      await serviceController.addService();
                                      SnackBarComponent.showSuccess(
                                        context,
                                        serviceController.message.value,
                                      );
                                      serviceController.reset();
                                      await serviceListController.listService(
                                        refresh: true,
                                      );
                                      Get.toNamed('/service');
                                    } catch (e) {
                                      _formKey.currentState!.validate();
                                      SnackBarComponent.showError(
                                        context,
                                        e.toString(),
                                      );
                                    }
                                  }
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
