import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
              height: 100,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.directions_car,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'MobilPedia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              icon: Icons.info_outline,
              title: 'Tentang',
              content:
                  'MobilPedia adalah aplikasi ensiklopedia mobil sport yang menyediakan informasi lengkap tentang berbagai brand dan model mobil sport dari seluruh dunia.',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.star_outline,
              title: 'Fitur Utama',
              content:
                  '• Katalog brand mobil sport terkenal\n• Spesifikasi lengkap setiap mobil\n• Fitur favorite untuk menyimpan mobil kesukaan\n• Notifikasi update terbaru\n• Pencarian brand mobil',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.code,
              title: 'Teknologi',
              content: 'Dibangun dengan Flutter dan Node.js Express untuk pengalaman pengguna yang optimal.',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.email_outlined,
              title: 'Kontak',
              content: 'Email: support@mobilpedia.com\nWebsite: www.mobilpedia.com',
            ),
            const SizedBox(height: 30),
            const Text(
              '© 2024 MobilPedia. All rights reserved.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
