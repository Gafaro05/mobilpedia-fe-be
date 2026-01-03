import 'package:flutter/material.dart';
import '../../api/api_service.dart';

class ViewCarPage extends StatefulWidget {
  final int carId;
  final String carName;
  final String? imageUrl;
  final String? series;
  final String? model;

  const ViewCarPage({
    super.key,
    required this.carId,
    required this.carName,
    required this.imageUrl,
    required this.series,
    required this.model,
  });

  @override
  State<ViewCarPage> createState() => _ViewCarPageState();
}

class _ViewCarPageState extends State<ViewCarPage> {
  bool _isFavorite = false;
  bool _isLoadingFav = false;
  bool _isLoadingDetail = true;
  Map<String, dynamic>? _carDetail;

  @override
  void initState() {
    super.initState();
    _loadCarDetail();
  }

  Future<void> _loadCarDetail() async {
    final api = ApiService();
    final detail = await api.getCarDetail(widget.carId);
    if (mounted) {
      setState(() {
        _carDetail = detail;
        _isLoadingDetail = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => _isLoadingFav = true);

    final api = ApiService();

    bool ok;
    if (_isFavorite) {
      // Hapus favorite
      ok = await api.removeFavorite(widget.carId);
      if (ok) {
        setState(() => _isFavorite = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dihapus dari favorite')),
          );
        }
      }
    } else {
      // Tambah favorite
      ok = await api.addFavorite(widget.carId);
      if (ok) {
        setState(() => _isFavorite = true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ditambahkan ke favorite')),
          );
        }
      }
    }

    setState(() => _isLoadingFav = false);
  }

  String _formatPrice(int? price) {
    if (price == null) return '-';
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  Widget _buildSpecItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsSection() {
    if (_isLoadingDetail) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_carDetail == null) {
      return const Text('Gagal memuat spesifikasi');
    }

    final specs = _carDetail!['specs'] as Map<String, dynamic>?;
    final year = _carDetail!['year'];
    final bodyType = _carDetail!['bodyType'];
    final description = _carDetail!['description'];
    final priceFrom = _carDetail!['priceFrom'] as int?;
    final priceTo = _carDetail!['priceTo'] as int?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Informasi Umum',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildSpecItem('Tahun', year?.toString()),
        _buildSpecItem('Tipe Body', bodyType),
        _buildSpecItem('Harga Mulai', _formatPrice(priceFrom)),
        _buildSpecItem('Harga Sampai', _formatPrice(priceTo)),
        if (description != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 14)),
        ],
        if (specs != null && specs.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Spesifikasi Teknis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...specs.entries.map((e) => _buildSpecItem(
                e.key.toString(),
                e.value?.toString(),
              )),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = _isFavorite ? Icons.favorite : Icons.favorite_border;
    final iconColor = _isFavorite ? Colors.red : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carName),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: _isLoadingFav ? null : _toggleFavorite,
            icon: Icon(icon, color: iconColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageUrl == null
                ? Container(
                    height: 220,
                    color: Colors.grey.shade300,
                  )
                : Image.network(
                    widget.imageUrl!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 220, color: Colors.grey.shade300),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.carName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.series != null)
                    Text("Series: ${widget.series}",
                        style: const TextStyle(fontSize: 16)),
                  if (widget.model != null)
                    Text("Model: ${widget.model}",
                        style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildSpecsSection(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoadingFav ? null : _toggleFavorite,
                      icon: Icon(
                        icon,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      label: Text(
                        _isFavorite
                            ? 'Hapus dari Favorite'
                            : 'Tambahkan ke Favorite',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
