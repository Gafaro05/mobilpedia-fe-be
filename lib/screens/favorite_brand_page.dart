import 'package:flutter/material.dart';
import 'favorite_manager.dart';

class FavoriteBrandPage extends StatefulWidget {
  final String brandName;
  final String brandLogoPath;

  const FavoriteBrandPage({
    super.key,
    required this.brandName,
    required this.brandLogoPath,
  });

  @override
  State<FavoriteBrandPage> createState() => _FavoriteBrandPageState();
}

class _FavoriteBrandPageState extends State<FavoriteBrandPage> {
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

  @override
  Widget build(BuildContext context) {
    // ambil semua favorit untuk brand ini
    final allFavorites = FavoriteManager.favorites.where(
      (c) => c.brandName == widget.brandName,
    );

    // terapkan filter
    final filtered = allFavorites.where((car) {
      final matchSeries =
          _selectedSeries == null || car.series == _selectedSeries;
      final matchModel =
          _selectedModel == null || car.model == _selectedModel;
      return matchSeries && matchModel;
    }).toList();

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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: widget.brandLogoPath.isNotEmpty
                          ? Image.asset(
                              widget.brandLogoPath,
                              height: 50,
                            )
                          : const SizedBox(
                              height: 50,
                              width: 50,
                            ),
                    ),
                    const Icon(
                      Icons.search,
                      size: 32,
                      color: Colors.black,
                    ),
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

              const SizedBox(height: 12),

              // ===== TITLE "MOBIL BMW FAVORIT ANDA" =====
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'MOBIL ${widget.brandName.toUpperCase()} FAVORIT ANDA',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ===== LIST FAVORIT UNTUK BRAND INI =====
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada mobil favorit\nuntuk brand ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final car = filtered[index];
                          return _carCard(car);
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemCount: filtered.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====== WIDGET CARD MOBIL FAVORIT ======
  Widget _carCard(FavoriteCar car) {
    final isFavorite =
        FavoriteManager.isFavorite(car.brandName, car.carName);

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  car.carName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${car.series} • ${car.model}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // icon love merah (bisa di-tap untuk un-favorite)
          GestureDetector(
            onTap: () {
              setState(() {
                if (isFavorite) {
                  FavoriteManager.removeFavorite(
                      car.brandName, car.carName);
                } else {
                  FavoriteManager.addFavorite(car);
                }
              });
            },
            child: Icon(
              Icons.favorite,
              size: 22,
              color: isFavorite ? Colors.red : Colors.black,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '3.8K Suka',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ====== FILTER UI & SHEET ======
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
}
