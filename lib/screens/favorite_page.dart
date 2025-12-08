import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorite_manager.dart';
import 'favorite_brand_page.dart';
import 'notifications_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final PageController _brandPageController = PageController();
  final PageController _adPageController = PageController();

  int _currentBrandPage = 0;
  int _currentAdPage = 0;

  String? _selectedSeries;
  String? _selectedModel;

  final List<String> _seriesOptions = [
    'Semua Series',
    'Series 1',
    'Series 2',
    'Series 3',
    'Series 4',
  ];

  final List<String> _modelOptions = [
    'Semua Model',
    'SUV',
    'MPV',
    'Sedan',
    'Coupe',
    'Hatchback',
  ];

  late final List<_FavAd> _ads;

  @override
  void initState() {
    super.initState();
    final allAds = <_FavAd>[
      const _FavAd(
        title: 'Discover BMW M Series',
        url: 'https://www.bmw.com/',
      ),
      const _FavAd(
        title: 'Experience Porsche Performance',
        url: 'https://www.porsche.com/',
      ),
      const _FavAd(
        title: 'Lamborghini – Feel the Speed',
        url: 'https://www.lamborghini.com/',
      ),
      const _FavAd(
        title: 'Pagani – Art of Hypercar',
        url: 'https://www.pagani.com/',
      ),
      const _FavAd(
        title: 'Mercedes-AMG Power & Style',
        url: 'https://www.mercedes-amg.com/',
      ),
    ];

    _ads = List<_FavAd>.from(allAds)..shuffle(Random());
  }

  Future<void> _openAdUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final allFavorites = FavoriteManager.favorites;

    final filteredFavorites = allFavorites.where((car) {
      final matchSeries =
          _selectedSeries == null || car.series == _selectedSeries;
      final matchModel =
          _selectedModel == null || car.model == _selectedModel;
      return matchSeries && matchModel;
    }).toList();

    final Map<String, String> brandLogos = {};
    for (var car in filteredFavorites) {
      brandLogos[car.brandName] = car.brandLogoPath;
    }
    final brands = brandLogos.keys.toList();

    final List<List<String>> brandPages = [];
    for (int i = 0; i < brands.length; i += 2) {
      final end = (i + 2 < brands.length) ? i + 2 : brands.length;
      brandPages.add(brands.sublist(i, end));
    }

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
              // ===== TOP BAR =====
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Favorite Car",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(Icons.search, size: 32, color: Colors.black),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ===== FILTER BAR =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showFilterSheet(
                      title: 'Pilih Series',
                      options: _seriesOptions,
                      onSelected: (val) {
                        setState(() {
                          _selectedSeries =
                              (val == 'Semua Series') ? null : val;
                        });
                      },
                    ),
                    child: _dropFilter(_selectedSeries ?? 'Series'),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showFilterSheet(
                      title: 'Pilih Model',
                      options: _modelOptions,
                      onSelected: (val) {
                        setState(() {
                          _selectedModel =
                              (val == 'Semua Model') ? null : val;
                        });
                      },
                    ),
                    child: _dropFilter(_selectedModel ?? 'Model'),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ===== PAGEVIEW BRAND FAVORITE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: (brandPages.isEmpty)
                      ? const Center(
                          child: Text(
                            "Belum ada mobil favorit\natau tidak cocok dengan filter.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _brandPageController,
                                itemCount: brandPages.length,
                                onPageChanged: (i) {
                                  setState(() => _currentBrandPage = i);
                                },
                                itemBuilder: (context, index) {
                                  final pageBrands = brandPages[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: pageBrands.map((brandName) {
                                      final logoPath =
                                          brandLogos[brandName] ?? '';
                                      return _brandCard(
                                        brandName: brandName,
                                        logoPath: logoPath,
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                brandPages.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  width: _currentBrandPage == index ? 10 : 8,
                                  height: _currentBrandPage == index ? 10 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentBrandPage == index
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== IKLAN MOBIL DI BAWAH =====
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _adPageController,
                          itemCount: _ads.length,
                          onPageChanged: (i) {
                            setState(() => _currentAdPage = i);
                          },
                          itemBuilder: (context, index) {
                            final ad = _ads[index];
                            return GestureDetector(
                              onTap: () => _openAdUrl(ad.url),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E5E5),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ad.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _ads.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentAdPage == index ? 10 : 8,
                            height: _currentAdPage == index ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentAdPage == index
                                  ? Colors.black
                                  : Colors.black45,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== BOTTOM NAVBAR =====
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
            _BottomNavItemFav(
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
            _BottomNavItemFav(
              icon: Icons.favorite,
              label: 'Favorite',
              isActive: true,
              onTap: () {},
            ),
            _BottomNavItemFav(
              icon: Icons.notifications_none,
              label: 'Notifications',
              isActive: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsPage(),
                  ),
                );
              },
            ),
            _BottomNavItemFav(
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

  // ===== widget filter label =====
  static Widget _dropFilter(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  void _showFilterSheet({
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...options.map(
                (opt) => ListTile(
                  title: Text(opt),
                  onTap: () {
                    onSelected(opt);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ===== card brand favorit =====
  Widget _brandCard({
    required String brandName,
    required String logoPath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FavoriteBrandPage(
              brandName: brandName,
              brandLogoPath: logoPath,
            ),
          ),
        );
      },
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              brandName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== model iklan di favorite =====
class _FavAd {
  final String title;
  final String url;

  const _FavAd({
    required this.title,
    required this.url,
  });
}

// ===== bottom nav item =====
class _BottomNavItemFav extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItemFav({
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
