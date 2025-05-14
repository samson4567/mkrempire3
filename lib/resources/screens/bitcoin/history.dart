import 'package:flutter/material.dart';

class CryptoHistoryScreen extends StatelessWidget {
  const CryptoHistoryScreen({super.key});

  final List<Map<String, dynamic>> dummyHistory = const [
    {'type': 'Buy', 'amount': '0.5 BTC', 'date': 'Apr 1, 2025'},
    {'type': 'Sell', 'amount': '1.2 ETH', 'date': 'Mar 28, 2025'},
    {'type': 'Swap', 'amount': '0.3 BTC → 4.5 LTC', 'date': 'Mar 15, 2025'},
    {'type': 'Deposit', 'amount': '100 USDT', 'date': 'Mar 1, 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyHistory.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          return ListTile(
            leading: Icon(
              item['type'] == 'Buy' || item['type'] == 'Deposit'
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: item['type'] == 'Deposit' ? Colors.green : Colors.red,
            ),
            title: Text(item['type']),
            subtitle: Text(item['date']),
            trailing: Text(item['amount']),
          );
        },
      ),
    );
  }
}
