import 'package:flutter/material.dart';

class SwapCryptoScreen extends StatelessWidget {
  const SwapCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController fromController = TextEditingController();
    final TextEditingController toController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap Crypto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('From', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: fromController,
              decoration: InputDecoration(
                hintText: 'Amount in BTC',
                prefixIcon: const Icon(Icons.currency_bitcoin),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Icon(Icons.swap_vert, size: 30)),
            const SizedBox(height: 20),
            const Text('To', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: toController,
              decoration: InputDecoration(
                hintText: 'Amount in ETH',
                prefixIcon: const Icon(Icons.currency_exchange),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // handle swap
                },
                child: const Text('Swap Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
