import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import 'notification_detail_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  bool _isLoadingBrands = true;
  String? _errorNotif;
  String? _errorBrands;

  List<dynamic> _notifications = [];
  List<dynamic> _brands = [];

  int? _selectedBrandId; // null = semua brand

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _loadNotifications();
  }

  Future<void> _loadBrands() async {
    setState(() {
      _isLoadingBrands = true;
      _errorBrands = null;
    });

    try {
      final data = await ApiService().getBrands();
      setState(() {
        _brands = data;
        _isLoadingBrands = false;
      });
    } catch (e) {
      setState(() {
        _errorBrands = e.toString();
        _isLoadingBrands = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorNotif = null;
    });

    try {
      final data = await ApiService().getNotifications(
        brandId: _selectedBrandId,
      );
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorNotif = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onBrandChanged(int? brandId) {
    setState(() {
      _selectedBrandId = brandId;
    });
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: _buildNotificationList(),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Notifikasi Berdasarkan Brand',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoadingBrands)
            const LinearProgressIndicator(minHeight: 2)
          else if (_errorBrands != null)
            Text(
              'Gagal memuat brand:\n$_errorBrands',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            )
          else
            DropdownButtonFormField<int?>(
              value: _selectedBrandId,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Semua Brand'),
                ),
                ..._brands.map((b) {
                  return DropdownMenuItem<int?>(
                    value: b['id'] as int,
                    child: Text(b['name']?.toString() ?? 'Unknown'),
                  );
                }).toList(),
              ],
              onChanged: _onBrandChanged,
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorNotif != null) {
      return Center(
        child: Text(
          'Gagal memuat notifikasi:\n$_errorNotif',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(
        child: Text('Belum ada notifikasi'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notif = _notifications[index];

          // STRUKTUR DATA YANG DIHARAPKAN DARI BACKEND:
          // {
          //   "id": 1,
          //   "title": "Promo BMW",
          //   "message": "Diskon spesial akhir tahun",
          //   "createdAt": "2025-12-01T10:00:00.000Z",
          //   "imageUrl": "...", (opsional)
          //   "brand": {
          //      "id": 1,
          //      "name": "BMW",
          //      "logoUrl": "https://..."
          //   }
          // }
          final String title = notif['title']?.toString() ?? 'Notifikasi';
          final String message =
              notif['message']?.toString() ?? 'Tidak ada pesan';
          final String? imageUrl = notif['imageUrl']?.toString();
          final String? createdAt = notif['createdAt']?.toString();

          final brand = notif['brand'];
          final String brandName =
              brand != null ? (brand['name']?.toString() ?? '') : '';
          final String? brandLogo =
              brand != null ? brand['logoUrl']?.toString() : null;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationDetailPage(
                    id: notif['id'] as int,
                    title: title,
                    message: message,
                    imageUrl: imageUrl,
                    createdAt: createdAt,
                    brandName: brandName,
                    brandLogo: brandLogo,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO BRAND / GAMBAR
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18),
                  ),
                  child: brandLogo != null
                      ? Image.network(
                          brandLogo,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.car_rental),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.notifications),
                        ),
                ),
                const SizedBox(width: 10),

                // TEKS NOTIFIKASI
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (brandName.isNotEmpty)
                          Text(
                            brandName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (createdAt != null)
                          Text(
                            createdAt,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // OPTIONAL GAMBAR IKLAN DI KANAN KECIL
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(18),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade200,
                      ),
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
}
