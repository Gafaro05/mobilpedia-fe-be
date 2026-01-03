// import 'package:flutter/material.dart';

// class ViewCarPage extends StatelessWidget {
//   final int carId;
//   final String carName;
//   final String? imageUrl;
//   final String? series;
//   final String? model;

//   const ViewCarPage({
//     super.key,
//     required this.carId,
//     required this.carName,
//     required this.imageUrl,
//     required this.series,
//     required this.model,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(carName),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           imageUrl == null
//               ? Container(
//                   height: 220,
//                   color: Colors.grey.shade300,
//                 )
//               : Image.network(
//                   imageUrl!,
//                   height: 220,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),

//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Series: $series", style: const TextStyle(fontSize: 18)),
//                 Text("Model: $model", style: const TextStyle(fontSize: 18)),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: const Text("Tambahkan ke Favorite"),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
