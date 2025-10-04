import 'dart:math';

import './../api.dart';

class EssentialService {
  Future<Map> list() async {
    var res = await Api.dio().get<Map<String, dynamic>>('/essiential', queryParameters: {
      'keys[0]': 'service_product',
     'keys[1]': 'country',
    },).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    return res.data!['data'];
  }

  Future<List<dynamic>> getServiceBrand(serviceId) async {

    var res = await Api.dio().get<Map<String, dynamic>>('/essiential/service-brand/$serviceId')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Get Service Brand failed. ${res.data!['message']}');
    }
    return res.data!['data'];
  }
  Future<List<dynamic>> getCountryState(countryId) async {

    var res = await Api.dio().get<Map<String, dynamic>>('/essiential/state/$countryId')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Get Country State failed. ${res.data!['message']}');
    }
    return res.data!['data'];
  }

  Future<List<dynamic>> getStateDistrict(stateId) async {

    var res = await Api.dio().get<Map<String, dynamic>>('/essiential/district/$stateId')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Get State District failed. ${res.data!['message']}');
    }
    return res.data!['data'];
  }

  Future<List<dynamic>> getDistrictPinCode(districtId) async {

    var res = await Api.dio().get<Map<String, dynamic>>('/essiential/pincode/$districtId')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Get State District failed. ${res.data!['message']}');
    }

    List<dynamic> data = res.data!['data'];
    print(data);
    List<Map<String, dynamic>> result = data.map<Map<String, dynamic>>((item) => {
      'id': item['id'],
      'name': '${item['city_name']} - ${item['city_pincode']}',
    }).toList();
    return result;    
  }

}

