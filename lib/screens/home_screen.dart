
import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  
final List<TourPackage> packages = const [
  TourPackage(
    id: 1,
    title: 'Pantai Kuta, Bali',
    description: 'Nikmati sunset dan keindahan pantai Bali.',
    price: 750000,
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800',
  ),
  TourPackage(
    id: 2,
    title: 'Gunung Bromo',
    description: 'Saksikan matahari terbit di Gunung Bromo.',
    price: 950000,
    imageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800',
  ),
  TourPackage(
    id: 3,
    title: 'Candi Borobudur',
    description: 'Jelajahi warisan sejarah Indonesia.',
    price: 500000,
    imageUrl: 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?w=800',
  ),
  TourPackage(
    id: 4,
    title: 'Raja Ampat',
    description: 'Nikmati keindahan pulau dan laut Papua.',
    price: 2500000,
    imageUrl: 'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?w=800',
  ),
];


  String rupiah(double value) {
    return 'Rp ${value.toInt().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaTravel'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.splash,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          
IconButton(
  tooltip: 'Tes halaman 404',
  icon: const Icon(Icons.error_outline),
  onPressed: () {
    Navigator.pushNamed(context, '/halaman-tidak-ada');
  },
),

        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Destinasi Pilihan 🏝️',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text('Temukan perjalanan favoritmu.'),
          const SizedBox(height: 12),
          ...packages.map(
            (tour) => Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detail,
                    arguments: tour,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      tour.imageUrl,
                      height: 175,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 175,
                        color: Colors.teal.shade100,
                        child: const Center(
                          child: Icon(Icons.landscape, size: 60),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tour.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${rupiah(tour.price)} / orang',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Lihat Detail'),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
