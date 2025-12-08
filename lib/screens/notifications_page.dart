import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorite_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_BrandNotification> _notifications = [
    const _BrandNotification(
      brandName: 'BMW',
      title: 'BMW ada seri terbaru loh',
      message:
          'BMW baru saja meluncurkan seri terbaru dengan teknologi terkini. Lihat selengkapnya..',
      date: '10/09/25',
      time: '07.33',
      url: 'https://www.bmw.com/',
    ),
    const _BrandNotification(
      brandName: 'Ferrari',
      title: 'Ferrari Model limited edition',
      message:
          'Beli lah Ferrari terbaru model limited edition yang hanya dijual terbatas. Selengkapnya..',
      date: '16/12/25',
      time: '21.00',
      url: 'https://www.ferrari.com/',
    ),
    const _BrandNotification(
      brandName: 'Lamborghini',
      title: 'Penawaran test drive',
      message:
          'Ada penawaran terbaru untuk test drive Lamborghini di dealer resmi. Selengkapnya..',
      date: '10/20/25',
      time: '11.35',
      url: 'https://www.lamborghini.com/',
    ),
    const _BrandNotification(
      brandName: 'Porsche',
      title: 'Bonus dari Porsche',
      message:
          'Jangan lewatkan hadiah terbaru dari brand kami yaitu bonus spesial bagi pembeli. Selengkapnya..',
      date: '30/06/25',
      time: '19.20',
      url: 'https://www.porsche.com/',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _notifications.shuffle(Random());
  }

  Future<void> _openBrandUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00AEEF),
              Color(0xFF00111F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SizedBox(width: 32),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 28,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 150,
                height: 2,
                color: Colors.black,
              ),

              const SizedBox(height: 16),

              // LIST NOTIFIKASI
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: ListView.separated(
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) =>
                          const Divider(thickness: 0.7, height: 20),
                      itemBuilder: (context, index) {
                        final item = _notifications[index];
                        return GestureDetector(
                          onTap: () => _openBrandUrl(item.url),
                          child: _buildNotificationTile(item),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVBAR
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, -2),
              color: Colors.black26,
            ),
          ],
        ),
        child: Row(
          children: [
            _BottomNavItemNotif(
              icon: Icons.home,
              label: 'Home',
              isActive: false,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
            ),
            _BottomNavItemNotif(
              icon: Icons.favorite_border,
              label: 'Favorite',
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoritePage(),
                  ),
                );
              },
            ),
            _BottomNavItemNotif(
              icon: Icons.notifications,
              label: 'Notifications',
              isActive: true,
              onTap: () {},
            ),
            _BottomNavItemNotif(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(_BrandNotification item) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [
          // logo (placeholder)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.brandName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.date,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.time,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// model notif
class _BrandNotification {
  final String brandName;
  final String title;
  final String message;
  final String date;
  final String time;
  final String url;

  const _BrandNotification({
    required this.brandName,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    required this.url,
  });
}

// bottom nav item
class _BottomNavItemNotif extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItemNotif({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.black : Colors.grey.shade600;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 22,
              height: 3,
              decoration: BoxDecoration(
                color: isActive ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
