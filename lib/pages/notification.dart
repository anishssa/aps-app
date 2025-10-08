import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/CustomAppBarComponent.dart';
import '../controllers/notification_controller.dart';
import '../models/notification.dart';

class NotificationsSimplePage extends StatelessWidget {
  NotificationsSimplePage({super.key});

  final RxInt readingId = (-1).obs;
  final RxInt deletingId = (-1).obs;
  final RxBool readingAll = false.obs;
  final RxBool deletingAll = false.obs;

  Widget buildNavIcon(IconData icon) => Container(
    width: 50,
    height: 50,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Icon(icon, color: Colors.white, size: 24),
  );

  Widget _buildNotificationList(
    List<AppNotification> list,
    NotificationController c,
    bool isUnreadTab,
  ) {
    var isEmpty = isUnreadTab
        ? c.notifications.isEmpty && !c.loading.value
        : c.readNotifications.isEmpty && !c.readLoading.value;
    var hasMore = isUnreadTab ? c.hasMore.value : c.readHasMore.value;

    return RefreshIndicator(
      onRefresh: () async {
        if (isUnreadTab) {
          c.refresh();
        } else {
          c.readRefresh();
        }
      },
      child: isEmpty
          ? ListView(
              children: [
                SizedBox(height: 100),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUnreadTab ? Icons.mark_email_unread : Icons.inbox,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isUnreadTab
                            ? 'No unread notifications'
                            : 'No notifications here',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.separated(
              itemCount: list.length + (hasMore ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: isUnreadTab
                  ? c.scrollController
                  : c.readScrollController,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                if (isUnreadTab) {
                  if (i == c.notifications.length) {
                    if (c.loading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (c.hasMore.value) {
                      return const Center(child: Text('Loading more...'));
                    } else {
                      return const SizedBox(); // No more items
                    }
                  }
                } else {
                  if (i == c.readNotifications.length) {
                    if (c.readLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (c.readHasMore.value) {
                      return const Center(child: Text('Loading more...'));
                    } else {
                      return const SizedBox(); // No more items
                    }
                  }
                }
                final n = list[i];
                return Card(
                  color: isUnreadTab ? Colors.blue.shade50 : Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isUnreadTab ? Colors.blue : Colors.grey,
                      child: Icon(
                        isUnreadTab
                            ? Icons.mark_email_unread
                            : Icons.mark_email_read,
                        color: Colors.white,
                      ),
                    ),
                    onTap: isUnreadTab
                        ? () async => {
                            readingId.value = n.id,
                            await c.isRead(n.id),
                            readingId.value = -1,
                          }
                        : null,
                    title: Text(
                      n.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isUnreadTab
                            ? Colors.blue.shade900
                            : Colors.grey.shade700,
                      ),
                    ),
                    subtitle: Text(
                      n.message,
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isUnreadTab)
                          Obx(
                            () => readingId.value == n.id
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    tooltip: 'Mark as read',
                                    icon: Icon(
                                      Icons.mark_email_read,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async => {
                                      readingId.value = n.id,
                                      await c.isRead(n.id),
                                      readingId.value = -1,
                                    },
                                  ),
                          ),
                        if (!isUnreadTab)
                          Obx(
                            () => deletingId.value == n.id
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    tooltip: 'Delete',
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async => {
                                      deletingId.value = n.id,
                                      await c.deleteOne(n.id),
                                      deletingId.value = -1,
                                    },
                                  ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (c) {
        return Scaffold(
          appBar: CustomAppBarComponent(title: 'Notifications'),
          body: Column(
            children: [
              TabBar(
                controller: c.tabController,
                tabs: [
                  Tab(text: 'Unread'),
                  Tab(text: 'Read'),
                ],
              ),
              Expanded(
                child: Obx(() {
                  return TabBarView(
                    controller: c.tabController,
                    children: [
                      _buildNotificationList(c.notifications, c, true),
                      _buildNotificationList(c.readNotifications, c, false),
                    ],
                  );
                }),
              ),
            ],
          ),

          floatingActionButton: Builder(
            builder: (context) {
              return Obx(() {
                if (c.selectedTab.value == 0) {
                  // Unread tab: show "Mark all as read"
                  return readingAll.value
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () async {
                            readingAll.value = true;
                            await c.markAllRead();
                            readingAll.value = false;
                          },
                          child: buildNavIcon(Icons.done_all),
                        );
                } else {
                  // Read tab: show "Delete all"
                  return deletingAll.value
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () async {
                            deletingAll.value = true;
                            await c.deleteAll();
                            deletingAll.value = false;
                          },
                          child: buildNavIcon(Icons.delete_sweep),
                        );
                }
              });
            },
          ),
        );
      },
    );
  }
}
