import 'package:flutter/material.dart';

class CarDetailPage extends StatelessWidget {
  final String brandName;
  final String brandLogoPath;
  final String carName;

  const CarDetailPage({
    super.key,
    required this.brandName,
    required this.brandLogoPath,
    required this.carName,
  });

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
              // ====== TOP BAR ======
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),

                    // Logo brand
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        brandLogoPath,
                        height: 50,
                      ),
                    ),

                    const SizedBox(width: 32), // biar simetris
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ====== CARD FOTO MOBIL (placeholder) ======
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // Icon 360 di atas
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '360°',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == 1
                                        ? Colors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Placeholder gambar mobil (abu-abu)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ====== DETAIL TEKS ======
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama mobil
                        Text(
                          carName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          "Spesifikasi Singkat:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),

                        _bullet(
                            "Model ini merupakan varian performa tinggi dari seri $brandName, dengan fokus pada tenaga dan handling."),
                        _bullet(
                            "Mesin dan konfigurasi drivetrain dirancang untuk memberikan akselerasi agresif namun tetap nyaman dipakai harian."),
                        _bullet(
                            "Interior mengusung desain sporty dengan material premium dan fitur infotainment modern."),
                        _bullet(
                            "Cocok bagi pengguna yang mencari mobil sport dengan keseimbangan antara performa, kenyamanan, dan gaya."),

                        const SizedBox(height: 12),

                        const Text(
                          "Perkiraan Harga di Indonesia:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),

                        _bullet(
                            "Harga unit baru bisa berada di kisaran 1–3 miliar rupiah, tergantung varian, pajak, dan tahun produksi."),
                        _bullet(
                            "Unit bekas umumnya lebih terjangkau, menyesuaikan kondisi, kilometer, dan kelengkapan service record."),
                        _bullet(
                            "Harga aktual dapat berbeda di tiap dealer / showroom, serta dipengaruhi kurs dan kebijakan impor."),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widget bullet point kecil
  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ",
              style: TextStyle(
                fontSize: 14,
              )),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}
