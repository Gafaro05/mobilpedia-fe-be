import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'brand_page.dart';
import 'favorite_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _adPageController = PageController();
  final PageController _brandPageController = PageController();

  int _currentAdIndex = 0;
  int _currentBrandPage = 0;

  // ====== DATA IKLAN (10 iklan, bisa swipe kiri–kanan) ======
  final List<_CarAd> _ads = const [
    _CarAd(
      title: 'Your Dream Car\nCollection',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.lamborghini.com/',
    ),
    _CarAd(
      title: 'Ferrari Special\nEdition',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.ferrari.com/',
    ),
    _CarAd(
      title: 'BMW M Series\nPerformance',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.bmw.com/',
    ),
    _CarAd(
      title: 'Porsche Turbo\nExperience',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.porsche.com/',
    ),
    _CarAd(
      title: 'Bugatti\nExtreme Speed',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.bugatti.com/',
    ),
    _CarAd(
      title: 'Pagani\nArt of Speed',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.pagani.com/',
    ),
    _CarAd(
      title: 'McLaren\nTrack Days',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://cars.mclaren.com/',
    ),
    _CarAd(
      title: 'Aston Martin\nLuxury Ride',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.astonmartin.com/',
    ),
    _CarAd(
      title: 'Mercedes-AMG\nPower & Style',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.mercedes-amg.com/',
    ),
    _CarAd(
      title: 'Mustang\nAmerican Muscle',
      imagePath: 'assets/images/home_ad_lamborghini.png',
      url: 'https://www.ford.com/performance/mustang/',
    ),
  ];

  // ====== DATA BRAND (akan dibagi per 9 item / halaman) ======
  final List<String> _brands = const [
    'BMW',
    'LAMBORGHINI',
    'FERRARI',
    'PORSCHE',
    'BUGATTI',
    'PAGANI',
    'KOENIGSEGG',
    'MUSTANG',
    'MERCEDEZ-BENZ',
    'AUDI',
    'MCLAREN',
    'ASTON MARTIN',
    'NISSAN GTR',
    'LEXUS',
    'TOYOTA SUPRA',
    'DODGE CHALLENGER',
    'CHEVROLET CAMARO',
    'ROLLS-ROYCE',
  ];

  Future<void> _openAdUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  int get _brandTotalPages => (_brands.length / 9).ceil();

  @override
  void dispose() {
    _adPageController.dispose();
    _brandPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====== BACKGROUND GRADIENT ======
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00AEEF), // biru atas
              Color(0xFF00111F), // gelap bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ====== SEARCH BAR + AVATAR ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Cari Merk Sport Cars',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/home_profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ====== BANNER IKLAN (PAGEVIEW) ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 190,
                  child: PageView.builder(
                    controller: _adPageController,
                    itemCount: _ads.length,
                    onPageChanged: (index) {
                      setState(() => _currentAdIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final ad = _ads[index];
                      return GestureDetector(
                        onTap: () => _openAdUrl(ad.url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                ad.imagePath,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.35),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    ad.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ====== DOTS IKLAN ======
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _ads.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentAdIndex == index ? 10 : 8,
                    height: _currentAdIndex == index ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentAdIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ====== PANEL BRAND 3x3 DENGAN PAGEVIEW (SWIPE KANAN–KIRI) ======
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _brandPageController,
                            itemCount: _brandTotalPages,
                            onPageChanged: (page) {
                              setState(() => _currentBrandPage = page);
                            },
                            itemBuilder: (context, pageIndex) {
                              final startIndex = pageIndex * 9;
                              final endIndex =
                                  (startIndex + 9 <= _brands.length)
                                      ? startIndex + 9
                                      : _brands.length;
                              final pageBrands =
                                  _brands.sublist(startIndex, endIndex);

                              return GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                children: [
                                  ...pageBrands.map(
                                    (name) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BrandPage(
                                              brandName: name,
                                              // sementara: placeholder logo
                                              brandLogoPath:
                                                  'assets/images/home_profile.png',
                                            ),
                                          ),
                                        );
                                      },
                                      child: _BrandTile(name: name),
                                    ),
                                  ),
                                  for (int i = pageBrands.length; i < 9; i++)
                                    const SizedBox.shrink(),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _brandTotalPages,
                            (index) => _PageDot(
                              isActive: index == _currentBrandPage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ====== BOTTOM NAVIGATION BAR ======
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
            _BottomNavItem(
              icon: Icons.home,
              label: 'Home',
              isActive: true,
              onTap: () {},
            ),
            _BottomNavItem(
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
            _BottomNavItem(
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
            _BottomNavItem(
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
}

// ====== MODEL DATA IKLAN ======
class _CarAd {
  final String title;
  final String imagePath;
  final String url;

  const _CarAd({
    required this.title,
    required this.imagePath,
    required this.url,
  });
}

// ====== TILE BRAND ======
class _BrandTile extends StatelessWidget {
  final String name;

  const _BrandTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCFCFCF),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ====== DOT KECIL ======
class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.black45,
      ),
    );
  }
}

// ====== ITEM NAVBAR BAWAH ======
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
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
