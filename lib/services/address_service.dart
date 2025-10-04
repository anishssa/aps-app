import '../models/address.dart';
import './../api.dart';

class AddressService {
  Future<String> save(data) async {
    var res = await Api.dio()
        .post<Map<String, dynamic>>('/customer/address/save', data: data)
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Address Add failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> update(id, data) async {
    print('Update Address Data: $data');
    var res = await Api.dio()
        .put<Map<String, dynamic>>('/customer/address/update/$id', data: data)
        .catchError((e) {
          print('Error Response: ${e.response}');
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      print('Error Response Data: ${res.data}');

      throw Exception('Address Add failed. ${res.data!['message']}');
    }
print('Update Address Response Data: ${res.data}');
    return res.data!['message'];
  }

  Future<String> deleteAddress(id) async {
    var res = await Api.dio()
        .delete<Map<String, dynamic>>('/customer/address/delete/$id')
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Address Delete failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<Address?> listAddress() async {
    var res = await Api.dio().get<Map<String, dynamic>>(
        '/customer/address/getAll?address_type=service_address',
        queryParameters: {
          'address_type': 'service_address',
        }).catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Address List failed. ${res.data!['message']}');
    }
    final data = res.data?['data'];
    if (data == null) return null;
    return Address.fromJson(data);
  }
}

