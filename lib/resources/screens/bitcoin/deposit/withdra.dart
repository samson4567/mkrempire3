import 'package:flutter/material.dart';

class DepositWithdrawScreen extends StatefulWidget {
  const DepositWithdrawScreen({super.key});

  @override
  State<DepositWithdrawScreen> createState() => _DepositWithdrawScreenState();
}

class _DepositWithdrawScreenState extends State<DepositWithdrawScreen> {
  String _selectedAction = 'Deposit';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposit & Withdraw')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedAction,
              items: const [
                DropdownMenuItem(value: 'Deposit', child: Text('Deposit')),
                DropdownMenuItem(value: 'Withdraw', child: Text('Withdraw')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAction = value);
                }
              },
              decoration: InputDecoration(
                labelText: 'Action',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (e.g. USDT)',
                prefixIcon: const Icon(Icons.attach_money),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _walletController,
              decoration: InputDecoration(
                labelText: 'Wallet Address',
                prefixIcon: const Icon(Icons.wallet),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // handle deposit or withdrawal
                },
                child: Text(_selectedAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
