import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import '../brand/view_car_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiService().getFavorites();
      setState(() {
        _favorites = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(int carId) async {
    final ok = await ApiService().removeFavorite(carId);
    if (ok) {
      setState(() {
        _favorites.removeWhere((fav) => fav['carId'] == carId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favorite dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text("Gagal memuat favorite:\n$_error"),
      );
    }

    if (_favorites.isEmpty) {
      return const Center(
        child: Text('Belum ada mobil favorite'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final fav = _favorites[index];
          final car = fav['car']; // backend harus include: { car: {...} }

          if (car == null) {
            return const SizedBox.shrink();
          }

          final int carId = car['id'];
          final String carName = car['name'] ?? 'Unknown';
          final String? imageUrl = car['imageUrl'];
          final String? series = car['series'];
          final String? model = car['model'];
          final String brandName = car['brand']?['name'] ?? '';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewCarPage(
                    carId: carId,
                    carName: carName,
                    imageUrl: imageUrl,
                    series: series,
                    model: model,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Gambar mobil
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(18),
                    ),
                    child: imageUrl == null
                        ? Container(
                            width: 100,
                            height: 90,
                            color: Colors.grey.shade300,
                          )
                        : Image.network(
                            imageUrl,
                            width: 100,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 90,
                              color: Colors.grey.shade300,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),

                  // Info mobil
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            carName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (brandName.isNotEmpty)
                            Text(
                              brandName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          if (series != null)
                            Text(
                              "Series: $series",
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (model != null)
                            Text(
                              "Model: $model",
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => _removeFavorite(carId),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
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
