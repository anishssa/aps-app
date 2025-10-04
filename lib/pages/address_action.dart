import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/BottomSheetDropdownComponent.dart';
import '../components/ButtonComponent.dart';
import '../components/InputComponent.dart';
import '../components/SnackBarComponent.dart';
import '../components/CustomAppBarComponent.dart';
import '../controllers/address_action_controller.dart';
import '../controllers/essential_controller.dart';

class AddressAction extends StatefulWidget {
  const AddressAction({Key? key}) : super(key: key);

  @override
  _AddressActionState createState() => _AddressActionState();
}

class _AddressActionState extends State<AddressAction> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(EssentialController());
  final addressController = Get.put(AddressActionController());

  @override
  void initState() {
    super.initState();
    final address = addressController.address.value;
    if (address != null) {
      if (address.countryId != null) {
        addressController.countryId = address.countryId.toString();
        controller.getCountryState(address.countryId.toString());
      }
      if (address.stateId != null) {
        addressController.stateId = address.stateId.toString();
        controller.getStateDistrict(address.stateId.toString());
      }
      if (address.districtId != null) {
        addressController.districtId = address.districtId.toString();
        controller.getDistrictPinCode(address.districtId.toString());
      }
      addressController.pinCodeId = address.pincodeId.toString();
    }
  }

  void dispose() {
    super.dispose();
  }

  Map<String, dynamic>? selectedValue(List<dynamic> array, String id) {
    final d =  array.firstWhereOrNull((e) => e['id'].toString() == id);

    print('selectedValue: $d');

    return d;
  }

  @override
  Widget build(BuildContext context) {
    var address = addressController.address.value;
    return Scaffold(
      appBar: const CustomAppBarComponent(title: 'Address Update'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputComponent(
                    label: 'Address Line 1',
                    prefixIcon: Icons.home,
                    initialValue: address?.addressLine1,
                    minLines: 2,
                    maxLines: 5,
                    hintText: 'Enter your address line 1',
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a address line 1';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      addressController.address1 = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Address Line 2',
                    prefixIcon: Icons.home,
                    initialValue: address?.addressLine2,
                    minLines: 2,
                    maxLines: 5,
                    hintText: 'Enter your address line 2',
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Please enter a address line 2';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      addressController.address2 = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  InputComponent(
                    label: 'Phone',
                    prefixIcon: Icons.phone_android,
                    initialValue: address?.phone,
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
                      addressController.phone = value ?? '';
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
                        addressController.countryId,
                      ),
                      onChanged: (selected) {
                        final id = selected?['id']?.toString() ?? '';
                        addressController.countryId = id;
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
                      value: selectedValue(state, addressController.stateId),
                      onChanged: (selected) {
                        final id = selected?['id']?.toString() ?? '';
                        addressController.stateId = id;
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
                        addressController.districtId,
                      ),
                      onChanged: (selected) {
                        final id = selected?['id']?.toString() ?? '';
                        addressController.districtId = id;
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
                    return BottomSheetDropdownComponent(
                      label: "pincode",
                      hintText: 'Select pincode',
                      options: pinCode,
                      displayField: 'name',
                      value: selectedValue(
                        pinCode,
                        addressController.pinCodeId,
                      ),
                      onChanged: (selected) {
                        final id = selected?['id']?.toString() ?? '';
                        addressController.pinCodeId = id;
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

                  const SizedBox(height: 16),
                  Obx(
                    () => addressController.loading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ButtonComponent(
                            text: 'Update',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  await addressController.addAddress();
                                  await addressController.init();
                                  Get.offNamed('/profile');
                                  SnackBarComponent.showSuccess(
                                    context,
                                    addressController.message.value,
                                  );
                                } catch (e) {
                                  SnackBarComponent.showError(
                                    context,
                                    e.toString(),
                                  );
                                }
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
