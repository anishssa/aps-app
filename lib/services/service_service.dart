import '../models/service.dart';
import './../api.dart';

class ServiceService {
  Future<String> save(data) async {
    var res = await Api.dio()
        .post<Map<String, dynamic>>('/customer/add-service', data: data)
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Service Add failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> deleteService(id) async {
    var res = await Api.dio()
        .delete<Map<String, dynamic>>('/customer/delete-service/$id')
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Service Delete failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<String> ratingService(id, rating, comment) async {
    var res = await Api.dio()
        .post<Map<String, dynamic>>(
          '/customer/comment-add-service',
          data: {'star_rating': rating, 'comment': comment, 'id': id},
        )
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });

    print('result ---------------- $res');

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Service Rating failed. ${res.data!['message']}');
    }

    return res.data!['message'];
  }

  Future<List<Service>> listService(page, search, tab) async {
    var res = await Api.dio()
        .get<Map<String, dynamic>>(
          '/customer/getall-service',
          queryParameters: {'page': page, 'search': search, 'tap': tab},
        )
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Service List failed. ${res.data!['message']}');
    }
    return List<Service>.from(
      res.data!['data']['data'].map((x) => Service.fromJson(x)),
    );
  }

  Future downloadInvoice(id) async {
    print('Download Invoice Service ID: $id');
    var res = await Api.dio()
        .get<Map<String, dynamic>>('/customer/download-service/$id')
        .catchError((e) {
          print('Download Invoice Servicsdfsdfdsfdsfe ID: $id');
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
        print('Download Invoidsfsdfdsfce Service ID: $res');

    if (Api.isFailed(res.statusCode)) {
      throw Exception('Download failed. ${res.data!['message']}');
    }
    print('result ---------------- $res');
    return res;
  }
}
