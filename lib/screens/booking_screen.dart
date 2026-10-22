
import 'package:flutter/material.dart';

import '../models/tour_package.dart';

class BookingScreen extends StatefulWidget {
  final TourPackage tour;

  const BookingScreen({super.key, required this.tour});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _participantController = TextEditingController(text: '1');

  DateTime? _departureDate;
  bool _allowPop = false;

  @override
  void dispose() {
    _nameController.dispose();
    _participantController.dispose();
    super.dispose();
  }

  Future<bool> _confirmLeave() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan pemesanan?'),
        content: const Text(
          'Data booking belum dikirim. Apakah kamu yakin ingin kembali?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tetap di sini'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, kembali'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _allowPop) return;

        final shouldLeave = await _confirmLeave();

        if (shouldLeave && mounted) {
          setState(() => _allowPop = true);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Form Pemesanan')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.tour.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama pemesan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _participantController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah peserta',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                validator: (value) {
                  final number = int.tryParse(value ?? '');
                  if (number == null || number < 1) {
                    return 'Jumlah peserta minimal 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 3),
                  );

                  if (date != null && mounted) {
                    setState(() => _departureDate = date);
                  }
                },
                icon: const Icon(Icons.date_range),
                label: Text(
                  _departureDate == null
                      ? 'Pilih tanggal keberangkatan'
                      : 'Tanggal: ${_formatDate(_departureDate!)}',
                ),
              ),
              if (_departureDate == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    'Pilih tanggal keberangkatan terlebih dahulu',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  if (_departureDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tanggal keberangkatan wajib dipilih'),
                      ),
                    );
                    return;
                  }

                  final name = _nameController.text.trim();
                  final participants =
                      int.parse(_participantController.text);
                  final date = _formatDate(_departureDate!);

                  Navigator.pop<Map<String, dynamic>>(
                    context,
                    {
                      'success': true,
                      'name': name,
                      'participants': participants,
                      'date': date,
                    },
                  );
                },
                child: const Text('Konfirmasi Pemesanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
