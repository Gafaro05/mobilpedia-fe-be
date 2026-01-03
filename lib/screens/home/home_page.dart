import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_service.dart';
import '../brand/brand_page.dart';
import '../favorite/favorite_page.dart';
import '../notification/notifications_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _HomeContent(), // 👉 UI Home yang dinamis dari API
      const FavoritePage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notif',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// ===================
/// UI HOME + LOAD BRAND DARI API
/// ===================
class _HomeContent extends StatefulWidget {
  const _HomeContent({super.key});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final PageController _adPageController = PageController();
  final PageController _brandPageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  int _currentAdIndex = 0;
  int _currentBrandPage = 0;
  String _searchQuery = '';

  // ====== DATA IKLAN (sementara masih dummy lokal) ======
  final List<_CarAd> _ads = const [
    _CarAd(
      title: 'Your Dream Car\nCollection',
      imagePath: 'assets/lambo.jpg',
      url: 'https://www.lamborghini.com/',
    ),
    _CarAd(
      title: 'Ferrari Special\nEdition',
      imagePath: 'assets/ferarri.jpg',
      url: 'https://www.ferrari.com/',
    ),
    _CarAd(
      title: 'BMW M Series\nPerformance',
      imagePath: 'assets/bmww.jpg',
      url: 'https://www.bmw.com/',
    ),
    _CarAd(
      title: 'Porsche Turbo\nExperience',
      imagePath: 'assets/poce.jpg',
      url: 'https://www.porsche.com/',
    ),
    _CarAd(
      title: 'Bugatti\nExtreme Speed',
      imagePath: 'assets/bugati.jpg',
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

  // ====== DATA BRAND DARI BACKEND ======
  List<dynamic> _brands = [];
  bool _isLoadingBrands = true;
  String? _brandError;

  List<dynamic> get _filteredBrands {
    if (_searchQuery.isEmpty) return _brands;
    return _brands
        .where((b) => (b['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  int get _brandTotalPages => (_filteredBrands.length / 9).ceil();

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final data = await ApiService().getBrands();
      setState(() {
        _brands = data;
        _isLoadingBrands = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBrands = false;
        _brandError = e.toString();
      });
    }
  }

  Future<void> _openAdUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _adPageController.dispose();
    _brandPageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentBrandPage = 0;
    });
    _brandPageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ====== BACKGROUND GRADIENT ======
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
                        color: const Color.fromARGB(238, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: 'Cari Merk Sport Cars',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(fontSize: 14),
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
                    color: const Color.fromARGB(255, 179, 179, 179),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                  child: _buildBrandPanel(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandPanel(BuildContext context) {
    if (_isLoadingBrands) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_brandError != null) {
      return Center(
        child: Text(
          'Gagal memuat brand\n$_brandError',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_brands.isEmpty) {
      return const Center(
        child: Text('Belum ada data brand'),
      );
    }

    if (_filteredBrands.isEmpty) {
      return const Center(
        child: Text('Brand tidak ditemukan'),
      );
    }

    return Column(
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
              final endIndex = (startIndex + 9 <= _filteredBrands.length)
                  ? startIndex + 9
                  : _filteredBrands.length;
              final pageBrands = _filteredBrands.sublist(startIndex, endIndex);

              return GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...pageBrands.map((b) {
  final int id = b['id'];
  final String name = b['name'];
  final String? logo = b['logoUrl']; // ← ambil dari backend

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BrandPage(
            brandId: id,
            brandName: name,
          ),
        ),
      );
    },
    child: _BrandTile(
      name: name,
      logoUrl: logo,
    ),
  );
                  }),
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
  final String? logoUrl;

  const _BrandTile({
    required this.name,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 223, 223, 223),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: logoUrl == null
                  ? Container(color: const Color.fromARGB(255, 255, 255, 255))
                  : Image.network(
                      logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
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

// ====== DOT KECIL UNTUK PAGE ======
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
        color: isActive ? const Color.fromARGB(255, 0, 0, 0) : Colors.black45,
      ),
    );
  }
}
