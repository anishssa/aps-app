import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './index.dart';
import '../components/SnackBarComponent.dart';
import '../components/ServiceComponent.dart';
import '../controllers/service_controller.dart';

class Service extends StatefulWidget {
  const Service({Key? key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  final serviceController = Get.put(ServiceController());
  final _scrollController = ScrollController();
  final _completedScrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(serviceController.loadMore);
    _completedScrollController.addListener(serviceController.completedLoadMore);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _completedScrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshServices() async {
    try {
      await serviceController.listService(refresh: true);
    } catch (e) {
      SnackBarComponent.showError(context, 'Failed to refresh services: $e');
    }
  }

  Future<void> _completedRefreshServices() async {
    try {
      await serviceController.completedListService(refresh: true);
    } catch (e) {
      SnackBarComponent.showError(context, 'Failed to refresh services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexPage(
      title: 'Services',
      index: 0,
      page: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _searchFocusNode.requestFocus();
                },
                child: Obx(
                  () => TextFormField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    onChanged: (value) {
                      serviceController.searchQuery.value = value;
                      serviceController.completedRefresh();
                      serviceController.refresh();
                    },
                    decoration: InputDecoration(
                      suffixIcon: serviceController.searchQuery.value.isEmpty
                          ? const Icon(Icons.search)
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                serviceController.searchQuery.value = '';
                                _searchController.clear();
                                serviceController.refresh();
                                serviceController.completedRefresh();
                                _searchFocusNode.unfocus();
                              },
                            ),
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(4),
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black87,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child:const Text(
                        "All",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Tab(
                      child:  const Text(
                        "Completed",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All services
                  Obx(() {
                    return RefreshIndicator(
                      onRefresh: _refreshServices,
                      child:
                          serviceController.services.isEmpty &&
                              !serviceController.loading.value
                          ? ListView(
                              children:  [
                                SizedBox(height: 100),
                                Image.asset(
                                  'assets/images/not-found.png',
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.contain,
                                )
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount:
                                  serviceController.services.length +
                                  (serviceController.hasMore.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index ==
                                    serviceController.services.length) {
                                  if (serviceController.loading.value) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (serviceController.hasMore.value) {
                                    return const Center(
                                      child: Text('Loading more...'),
                                    );
                                  } else {
                                    return const SizedBox(); // No more items
                                  }
                                }
                                return ServiceComponent(
                                  service: serviceController.services[index],
                                );
                              },
                            ),
                    );
                  }),
                  // Completed services
                  Obx(() {
                    return RefreshIndicator(
                      onRefresh: _completedRefreshServices,
                      child:
                          serviceController.completedServices.isEmpty &&
                              !serviceController.completedLoading.value
                          ? ListView(
                              children: [
                                SizedBox(height: 100),
                                Center(
                                  child: Image.asset(
                                    'assets/images/completed-not-found.png',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _completedScrollController,
                              itemCount:
                                  serviceController.completedServices.length +
                                  (serviceController.completedHasMore.value
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index ==
                                    serviceController
                                        .completedServices
                                        .length) {
                                  if (serviceController
                                      .completedLoading
                                      .value) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (serviceController
                                      .completedHasMore
                                      .value) {
                                    return const Center(
                                      child: Text('Loading more...'),
                                    );
                                  } else {
                                    return const SizedBox(); // No more items
                                  }
                                }
                                return ServiceComponent(
                                  service: serviceController
                                      .completedServices[index],
                                );
                              },
                            ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

