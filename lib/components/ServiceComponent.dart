import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';

import '../api.dart';
import '../controllers/service_controller.dart';
import '../models/service.dart';
import './SnackBarComponent.dart';

class ServiceComponent extends StatelessWidget {
  final Service service;

  ServiceComponent({super.key, required this.service});

  final serviceController = Get.find<ServiceController>();
  final RxInt downloadingId = (-1).obs;

  Color _statusColor(
    BuildContext context,
    String? status, {
    bool text = false,
  }) {
    final int hex =
        (serviceController.statuses.firstWhere(
              (e) => e['status'] == status,
              orElse: () => {'color': 0xFF9E9E9E}, // grey fallback
            )['color']
            as int);

    if (text) {
      return Color(hex);
    }
    return Color(hex).withOpacity(0.1);
  }

  void _deleteService(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete service'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(
            () => serviceController.actionLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      try {
                        await serviceController.deleteService(id);
                        serviceController.services.removeWhere(
                          (s) => s.id == id,
                        );
                      } catch (e) {
                        SnackBarComponent.showError(context, e.toString());
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice(BuildContext context, int id) async {
    downloadingId.value = id;
    try {
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = await getDownloadsDirectory();
      } else {
        final baseDir = await getApplicationDocumentsDirectory();
        downloadsDir = Directory('${baseDir.path}');
      }

      if (downloadsDir == null) {
        print('Cannot access Downloads directory');
        return;
      }
      print('-------------------- down   ---------------------');
      print(downloadsDir);
      print(downloadsDir.path);

      final url = '/customer/download-service/$id';

      // First request just to get headers
      final response = await Api.dio().get(
        url,
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        // Extract filename from Content-Disposition header if present
        String fileName = "invoice_$id.pdf"; // fallback
        final contentDisposition = response.headers.value(
          'content-disposition',
        );
        if (contentDisposition != null) {
          final regex = RegExp(r'filename="?([^"]+)"?');
          final match = regex.firstMatch(contentDisposition);
          if (match != null) {
            fileName = match.group(1)!.replaceAll('"', '');
          }
        }
        final filePath = '${downloadsDir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.data);

        await OpenFile.open(filePath);
      } else {
        SnackBarComponent.showError(
          context,
          'Failed to get invoice file info.',
        );
      }
    } catch (e) {
      SnackBarComponent.showError(
        context,
        'Download error: \'${e.toString()}\'',
      );
    } finally {
      downloadingId.value = -1;
    }
  }

  void _showRatingDialog(BuildContext context, int id) {
    final commentController = TextEditingController();
    double rating = 0;
    final RxString errorText = ''.obs;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Rate & comment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => rating = r,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write a short comment…',
              ),
            ),
            Obx(
              () => errorText.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        errorText.value,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Obx(
            () => serviceController.actionLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      if (rating < 1 || commentController.text.trim().isEmpty) {
                        errorText.value = 'Rating and comment are required.';
                        return;
                      }
                      try {
                        await serviceController.addRating(
                          id,
                          rating,
                          commentController.text,
                        );
                        serviceController.completedServices
                                .firstWhere((s) => s.id == id)
                                .commentAdded =
                            1;
                        serviceController.completedServices.refresh();
                        SnackBarComponent.showSuccess(
                          context,
                          serviceController.message.value,
                        );
                      } catch (e) {
                        SnackBarComponent.showError(context, e.toString());
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.only(top: 12, left: 12, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFD682E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  (service.serviceNo ?? 'N/A').toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFFD682E),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  child: Text(
                    service.completedAt != null
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(service.completedAt!))
                        : (service.createdAt != null
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(service.createdAt!))
                        : 'N/A'),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Text(
              service.complaintDetails ?? '',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Expanded(
                  child: _Meta(
                    label: 'Product',
                    value: service.serviceProduct?.name,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _Meta(
                    label: 'Brand',
                    value: service.serviceBrand?.name,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor(context, service.status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  (service.status ?? 'N/A').toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(context, service.status, text: true),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if ((service.commentAdded ?? 0) == 0 &&
                  (service.status ?? '') == 'Completed')
                IconButton(
                  tooltip: 'Add review',
                  splashRadius: 18,
                  iconSize: 20,
                  onPressed: () => _showRatingDialog(context, service.id),
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              if ((service.status ?? '') != 'Completed')
                IconButton(
                  tooltip: 'Delete',
                  splashRadius: 18,
                  iconSize: 20,
                  onPressed: () => _deleteService(context, service.id),
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                  ),
                ),
              if ((service.status ?? '') == 'Completed' &&
                  service.verifyPayment == 1)
                Obx(
                  () => downloadingId.value == service.id
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Download',
                          splashRadius: 18,
                          iconSize: 20,
                          onPressed: () =>
                              _downloadInvoice(context, service.id),
                          icon: Icon(
                            Icons.download_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small helper to render label/value pair with subtle label and bold value.
class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(.6),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          (value ?? '').isEmpty ? '—' : value!,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
