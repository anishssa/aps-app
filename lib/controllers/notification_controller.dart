import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxList<AppNotification> readNotifications = <AppNotification>[].obs;
  late final TabController tab;
  final scrollController = ScrollController();
  final readScrollController = ScrollController();

  var service = NotificationService();

  var loading = false.obs;
  var hasMore = true.obs;
  var page = 1.obs;
  var limit = 10.obs;

  var readLoading = false.obs;
  var readHasMore = true.obs;
  var readPage = 1.obs;
  var readLimit = 10.obs;
  RxInt totalCount = 0.obs;


  @override
  void onInit() {
    super.onInit();
    tab = TabController(length: 2, vsync: this);
    scrollController.addListener(loadMore);
    readScrollController.addListener(readLoadMore);
    notification();
    readNotification();
  }

  @override
  void onClose() {
    scrollController.dispose();
    readScrollController.dispose();
    tab.dispose();
    super.onClose();
  }

  Future<void> _fetchNotifications({
    required bool isRead,
    bool refresh = false,
  }) async {
    final pageVar = isRead ? readPage : page;
    final hasMoreVar = isRead ? readHasMore : hasMore;
    final loadingVar = isRead ? readLoading : loading;
    final notificationsVar = isRead ? readNotifications : notifications;
    final limitVar = isRead ? readLimit : limit;
    if (refresh) {
      pageVar.value = 1;
      hasMoreVar.value = true;
      notificationsVar.clear();
    }
    if (loadingVar.value) return;
    loadingVar.value = true;
    try {
      var data = await service.listNotifications(
        pageVar.value,
        isRead ? 'read' : 'un_read',
      );
      if (data['notifications'].length < limitVar.value) {
        hasMoreVar.value = false;
      }
      pageVar.value++;
      notificationsVar.addAll(data['notifications'] as List<AppNotification>);
      if (!isRead) {
        totalCount.value = data['totalCount'] as int;
      }
    } finally {
      loadingVar.value = false;
    }
  }

  Future<void> notification({bool refresh = false}) async {
    await _fetchNotifications(isRead: false, refresh: refresh);
  }

  Future<void> readNotification({bool refresh = false}) async {
    await _fetchNotifications(isRead: true, refresh: refresh);
  }

  void loadMore() {
    if (hasMore.value) {
      notification();
    }
  }

  void refresh() {
    page.value = 1;
    hasMore.value = true;
    loading.value = false;
    notifications.clear();
    notification();
  }

  void readLoadMore() {
    if (readHasMore.value) {
      readNotification();
    }
  }

  void readRefresh() {
    readPage.value = 1;
    readHasMore.value = true;
    readLoading.value = false;
    readNotifications.clear();
    readNotification();
  }

  Future<void> isRead(int id) async {
    await service.markAsRead(id);
    notifications.removeWhere((e) => e.id == id);
    totalCount.value = totalCount.value - 1;
  }

  Future<void> deleteOne(int id) async {
    await service.deleteNotification(id);
    readNotifications.removeWhere((e) => e.id == id);
  }

  Future<void> markAllRead() async {
    await service.markAllAsRead();
    refresh();
  }

  Future<void> deleteAll() async {
    await service.deleteAll();
    refresh();
    readRefresh();
  }
}
