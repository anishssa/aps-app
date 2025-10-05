import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/service.dart';
import '../services/service_service.dart';

class ServiceController extends GetxController  with GetTickerProviderStateMixin {
  var loading = false.obs;
  var actionLoading = false.obs;
  var downloadLoading = false.obs;


  late final TabController tabController;
  final TextEditingController searchController = TextEditingController();
  final scrollController = ScrollController();
  final completedScrollController = ScrollController();
  final FocusNode searchFocusNode = FocusNode();


  var services = <Service>[].obs;
  var hasMore = true.obs;
  var page = 1.obs;
  var limit = 10.obs;

  var completedLoading = false.obs;
  var completedServices = <Service>[].obs;
  var completedHasMore = true.obs;
  var completedPage = 1.obs;
  var completedLimit = 10.obs;

  var statuses = [
    {'status': 'All', 'color': 0xFF000000},
    {'status': 'Pending', 'color': 0xFFFFA500},
    {'status': 'Accept', 'color': 0xFF2196F3},
    {'status': 'On Road', 'color': 0xFF9C27B0},
    {'status': 'Completed', 'color': 0xFF4CAF50},
    {'status': 'Cancelled', 'color': 0xFFF44336},
  ];

  var searchQuery = ''.obs;

  var message = ''.obs;

  var service = ServiceService();

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    scrollController.addListener(loadMore);
    completedScrollController.addListener(completedLoadMore);
    listService();
    completedListService();
  }

  @override
  void onClose() {
    scrollController.dispose();
    completedScrollController.dispose();
    tabController.dispose();
    searchFocusNode.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> deleteService(id) async {
    actionLoading.value = true;
    try {
      var data = await service.deleteService(id);
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> _fetchServices({
    required bool isCompleted,
    bool refresh = false,
  }) async {
    final pageVar = isCompleted ? completedPage : page;
    final hasMoreVar = isCompleted ? completedHasMore : hasMore;
    final loadingVar = isCompleted ? completedLoading : loading;
    final servicesVar = isCompleted ? completedServices : services;
    final limitVar = isCompleted ? completedLimit : limit;
    if (refresh) {
      pageVar.value = 1;
      hasMoreVar.value = true;
      servicesVar.clear();
    }
    if (loadingVar.value) return;
    loadingVar.value = true;
    try {
      var data = await service.listService(
        pageVar.value,
        searchQuery.value,
        isCompleted ? 'completed' : 'all',
      );
      if (data.length < limitVar.value) {
        hasMoreVar.value = false;
      }
      pageVar.value++;
      servicesVar.addAll(data);
    } finally {
      loadingVar.value = false;
    }
  }

  Future<void> listService({bool refresh = false}) async {
    await _fetchServices(isCompleted: false, refresh: refresh);
  }

  void loadMore() {
    if (hasMore.value) {
      listService();
    }
  }

  void refresh() {
    print('refreshing');
    print('------------------------------------------------------');
    page.value = 1;
    hasMore.value = true;
    loading.value = false;
    actionLoading.value = false;
    services.clear();
    listService();
  }

  Future<void> completedListService({bool refresh = false}) async {
    await _fetchServices(isCompleted: true, refresh: refresh);
  }

  void completedLoadMore() {
    if (completedHasMore.value) {
      completedListService();
    }
  }

  void completedRefresh() {
    completedPage.value = 1;
    completedHasMore.value = true;
    completedLoading.value = false;
    completedServices.clear();
    completedListService();
  }

  Future<void> addRating(id, rating, comment) async {
    actionLoading.value = true;
    try {
      var data = await service.ratingService(id, rating, comment);
      message.value = data;
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> downloadInvoice(id) async {
    downloadLoading.value = true;
    try {
      var data = await service.downloadInvoice(id);
      message.value = data;
    } finally {
      downloadLoading.value = false;
    }
  }
}
