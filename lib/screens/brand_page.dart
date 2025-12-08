import 'package:flutter/material.dart';
import 'car_detail_page.dart';
import 'favorite_manager.dart';

class BrandPage extends StatefulWidget {
  final String brandName;      // contoh: "BMW"
  final String brandLogoPath;  // contoh: "assets/images/bmw_logo.png"

  const BrandPage({
    super.key,
    required this.brandName,
    required this.brandLogoPath,
  });

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  // Menyimpan mobil yang sudah di-favorite di halaman ini
  final Set<String> _favoriteCars = {};

  // ========= STATE FILTER =========
  String? _selectedSeries; // null = semua
  String? _selectedModel;  // null = semua

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                    // BACK BUTTON
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),

                    // LOGO BRAND
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        widget.brandLogoPath,
                        height: 50,
                      ),
                    ),

                    // SEARCH ICON
                    const Icon(
                      Icons.search,
                      size: 32,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ===== DROPDOWN FILTER (Series & Model) =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Filter Series
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
                    child: _dropFilter(
                      _selectedSeries ?? "Series",
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Model
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
                    child: _dropFilter(
                      _selectedModel ?? "Model",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===== LIST MOBIL =====
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _carCard(
                      context,
                      name: "${widget.brandName} Model 1",
                      likes: "2.3K",
                      series: 'Series 1',
                      model: 'Sedan',
                    ),
                    const SizedBox(height: 16),
                    _carCard(
                      context,
                      name: "${widget.brandName} Model 2",
                      likes: "5.8K",
                      series: 'Series 2',
                      model: 'Coupe',
                    ),
                    const SizedBox(height: 16),
                    _carCard(
                      context,
                      name: "${widget.brandName} Model 3",
                      likes: "3.8K",
                      series: 'Series 3',
                      model: 'SUV',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== WIDGET FILTER DROPDOWN (TAMPILAN) ==================
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

  // ================== BOTTOM SHEET PILIHAN FILTER ==================
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

  // ================== CARD MOBIL (DENGAN LOVE + VIEW + FILTER) ==================
  Widget _carCard(
    BuildContext context, {
    required String name,
    required String likes,
    required String series,
    required String model,
  }) {
    // cek apakah mobil ini lolos filter series & model
    final bool matchSeries =
        _selectedSeries == null || _selectedSeries == series;
    final bool matchModel =
        _selectedModel == null || _selectedModel == model;

    if (!matchSeries || !matchModel) {
      // kalau tidak sesuai filter, tidak ditampilkan
      return const SizedBox.shrink();
    }

    final bool isFavorite =
        _favoriteCars.contains(name) ||
        FavoriteManager.isFavorite(widget.brandName, name);

    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Placeholder gambar mobil
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 12),

          // TEXT + LIKE + LOVE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$series • $model",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // TOMBOL LOVE / FAVORITE
                    GestureDetector(
                      onTap: () => _onFavoriteTap(name, series, model),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$likes Suka",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ====== TOMBOL VIEW (NAVIGASI KE DETAIL) ======
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CarDetailPage(
                    brandName: widget.brandName,
                    brandLogoPath: widget.brandLogoPath,
                    carName: name,
                  ),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "VIEW",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============== LOGIC SAAT LOVE DITEKAN ==================
  void _onFavoriteTap(String carName, String series, String model) {
    final bool isFavorite =
        _favoriteCars.contains(carName) ||
        FavoriteManager.isFavorite(widget.brandName, carName);

    if (isFavorite) {
      setState(() {
        _favoriteCars.remove(carName);
        FavoriteManager.removeFavorite(widget.brandName, carName);
      });
    } else {
      _showFavoriteDialog(carName, series, model);
    }
  }

  void _showFavoriteDialog(String carName, String series, String model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lingkaran hijau dengan centang
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C853),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Anda Berhasil menambahkan ke Favorite!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol OK hijau
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _favoriteCars.add(carName);
                        FavoriteManager.addFavorite(
                          FavoriteCar(
                            brandName: widget.brandName,
                            brandLogoPath: widget.brandLogoPath,
                            carName: carName,
                            series: series,
                            model: model,
                          ),
                        );
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
