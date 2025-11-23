import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './index.dart';
import '../components/ServiceComponent.dart';
import '../controllers/service_controller.dart';

class Service extends StatelessWidget {
  Service({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexPage(
      title: 'Services',
      index: 0,
      page: GetBuilder<ServiceController>(
        init: ServiceController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.searchFocusNode.requestFocus();
                    },
                    child: Obx(
                      () => TextFormField(
                        focusNode: controller.searchFocusNode,
                        controller: controller.searchController,
                        onChanged: (value) {
                          controller.searchQuery.value = value;
                          controller.completedRefresh();
                          controller.refresh();
                        },
                        decoration: InputDecoration(
                          suffixIcon: controller.searchQuery.value.isEmpty
                              ? const Icon(Icons.search)
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    controller.searchQuery.value = '';
                                    controller.searchController.clear();
                                    controller.refresh();
                                    controller.completedRefresh();
                                    controller.searchFocusNode.unfocus();
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
                      controller: controller.tabController,
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
                          child: const Text(
                            "All",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Tab(
                          child: const Text(
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
                    controller: controller.tabController,
                    children: [
                      // All services
                      Obx(() {
                        return RefreshIndicator(
                          onRefresh: () async => controller.refresh(),
                          child:
                              controller.services.isEmpty &&
                                  !controller.loading.value
                              ? ListView(
                                  children: [
                                    SizedBox(height: 100),
                                    Image.asset(
                                      'assets/images/not-found.png',
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: controller.scrollController,
                                  itemCount:
                                      controller.services.length +
                                      (controller.hasMore.value ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == controller.services.length) {
                                      if (controller.loading.value) {
                                        if (controller.page.value == 1) {
                                          return const SizedBox();
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (controller.hasMore.value) {
                                        return const Center(
                                          child: Text('Loading more...'),
                                        );
                                      } else {
                                        return const SizedBox(); // No more items
                                      }
                                    }
                                    return ServiceComponent(
                                      service: controller.services[index],
                                    );
                                  },
                                ),
                        );
                      }),
                      // Completed services
                      Obx(() {
                        return RefreshIndicator(
                          onRefresh: () async => controller.completedRefresh(),
                          child:
                              controller.completedServices.isEmpty &&
                                  !controller.completedLoading.value
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller:
                                      controller.completedScrollController,
                                  itemCount:
                                      controller.completedServices.length +
                                      (controller.completedHasMore.value
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.completedServices.length) {
                                      if (controller.completedLoading.value) {
                                        if (controller.page.value == 1) {
                                          return const SizedBox();
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (controller
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
                                      service:
                                          controller.completedServices[index],
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
          );
        },
      ),
    );
  }
}
