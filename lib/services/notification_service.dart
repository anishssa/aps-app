import '../api.dart';
import '../models/notification.dart';

class NotificationService {
  Future<Map<String, dynamic>> listNotifications(page, tab) async {
    var res = await Api.dio()
        .get<Map<String, dynamic>>(
      '/notification/getAll',
      queryParameters: {'page': page, 'tap': tab},
    )
        .catchError((e) {
      if (Api.isFailed(e.response.statusCode)) {
        throw Exception(Api.getErrorMessage(e));
      }
    });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Service List failed. ${res.data!['message']}');
    }
    print('Notification List: --------------------------');
    print(res.data!);

    final notifications = List<AppNotification>.from(
      res.data!['data']['data'].map((x) => AppNotification.fromJson(x)),
    );
    final totalCount = res.data!['data']['total'] ?? 0;

    return {
      'notifications': notifications,
      'totalCount': totalCount,
    };
  }


  Future<void> markAsRead(int id) async {
    var res = await Api.dio()
        .patch<Map<String, dynamic>>('/notification/read/$id')
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Notification read failed. ${res.data!['message']}');
    }
    return res.data!['message'];
  }

  Future<void> deleteNotification(int id) async {
    print('------------------delete notification $id-------------');
    var res = await Api.dio()
        .delete<Map<String, dynamic>>('/notification/delete/$id')
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Notification delete failed. ${res.data!['message']}');
    }
    print('-------------------------------------');
    print(res.data);
    return res.data!['message'];
  }

  Future<void> markAllAsRead() async {
    var res = await Api.dio()
        .post<Map<String, dynamic>>('/notification/readAll')
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Notification readAll failed. ${res.data!['message']}');
    }
    return res.data!['message'];
  }

  Future<void> deleteAll() async {
    var res = await Api.dio()
        .delete<Map<String, dynamic>>('/notification/deleteAll')
        .catchError((e) {
          if (Api.isFailed(e.response.statusCode)) {
            throw Exception(Api.getErrorMessage(e));
          }
        });
    if (Api.isFailed(res.statusCode)) {
      throw Exception('Notification deleteAll failed. ${res.data!['message']}');
    }
    return res.data!['message'];
  }
}
