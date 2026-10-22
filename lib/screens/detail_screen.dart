
import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final TourPackage tour;

  const DetailScreen({super.key, required this.tour});

  String rupiah(double value) {
    return 'Rp ${value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Wisata')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              tour.imageUrl,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 230,
                color: Colors.teal.shade100,
                child: const Icon(Icons.landscape, size: 80),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tour.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(tour.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 14),
          Text(
            '${rupiah(tour.price)} / orang',
            style: const TextStyle(
              fontSize: 21,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingScreen(tour: tour),
                ),
              );

              if (!context.mounted) return;

              if (result != null && result['success'] == true) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Booking ${tour.title} berhasil atas nama '
                        '${result['name']}!',
                      ),
                    ),
                  );
              }
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('Pesan Sekarang'),
          ),
        ],
      ),
    );
  }
}
