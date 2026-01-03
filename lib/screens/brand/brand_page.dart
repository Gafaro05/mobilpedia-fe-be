import 'package:flutter/material.dart';
import '../../api/api_service.dart';
import 'view_car_page.dart';

class BrandPage extends StatefulWidget {
  final int brandId;
  final String brandName;

  const BrandPage({
    super.key,
    required this.brandId,
    required this.brandName,
  });

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _cars = [];

  // ====== FILTER STATE ======
  String? _selectedSeries;
  String? _selectedBodyType;

  // Sesuaikan dengan data di DB (seed Prisma)
  final List<String> _seriesOptions = const [
    'M Series',
    'X Series',
    'Series 3',
    'Series 4',
  ];

  final List<String> _bodyTypeOptions = const [
    'SUV',
    'MPV',
    'SEDAN',
    'COUPE',
    'HATCHBACK',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiService().getCarsByBrand(
        brandId: widget.brandId,
        series: _selectedSeries,
        bodyType: _selectedBodyType,
      );

      setState(() {
        _cars = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleSeries(String value) {
    setState(() {
      if (_selectedSeries == value) {
        _selectedSeries = null; // klik lagi = reset
      } else {
        _selectedSeries = value;
      }
    });
    _loadCars();
  }

  void _toggleBodyType(String value) {
    setState(() {
      if (_selectedBodyType == value) {
        _selectedBodyType = null; // klik lagi = reset
      } else {
        _selectedBodyType = value;
      }
    });
    _loadCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildFilterPanel(),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(
                          'Gagal memuat data mobil:\n$_error',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : _cars.isEmpty
                        ? const Center(child: Text('Tidak ada mobil yang cocok'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _cars.length,
                            itemBuilder: (context, index) {
                              final car = _cars[index];

                              final int carId = car['id'] as int;
                              final String carName =
                                  car['name']?.toString() ?? 'Unknown';
                              final String? imageUrl =
                                  car['imageUrl']?.toString();
                              final String? series =
                                  car['series']?.toString();
                              final String? bodyType =
                                  (car['bodyType'] ?? car['model'])
                                      ?.toString();

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
                                        model: bodyType,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Gambar mobil
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: imageUrl == null
                                            ? Container(
                                                height: 160,
                                                color: Colors
                                                    .grey.shade300,
                                              )
                                            : Image.network(
                                                imageUrl,
                                                height: 160,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                        error,
                                                        stackTrace) =>
                                                    Container(
                                                  height: 160,
                                                  color: Colors
                                                      .grey.shade300,
                                                ),
                                              ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              carName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if (series != null)
                                              Text("Series: $series"),
                                            if (bodyType != null)
                                              Text("Model: $bodyType"),
                                            const SizedBox(height: 10),
                                            Align(
                                              alignment:
                                                  Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ViewCarPage(
                                                        carId: carId,
                                                        carName: carName,
                                                        imageUrl: imageUrl,
                                                        series: series,
                                                        model: bodyType,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton
                                                    .styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "View",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFF3F3F3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Series",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _seriesOptions.map((s) {
              final bool selected = _selectedSeries == s;
              return ChoiceChip(
                label: Text(
                  s,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                ),
                selected: selected,
                selectedColor: Colors.blueAccent,
                backgroundColor: Colors.white,
                onSelected: (_) => _toggleSeries(s),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            "Filter Model (Body Type)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _bodyTypeOptions.map((b) {
              final bool selected = _selectedBodyType == b;
              return ChoiceChip(
                label: Text(
                  b,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                ),
                selected: selected,
                selectedColor: Colors.blueAccent,
                backgroundColor: Colors.white,
                onSelected: (_) => _toggleBodyType(b),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
