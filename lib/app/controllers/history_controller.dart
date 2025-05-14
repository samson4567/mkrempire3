import 'package:mkrempire/app/repository/hidtory_repo.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  final HistoryRepo historyRepo;

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxString selectedCategory = 'All'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList transactions = [].obs;
  final RxList filteredTransactions = [].obs;

  // Pagination variables
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;

  HistoryController({required this.historyRepo});

  @override
  void onInit() {
    super.onInit();
    fetchAllTransactions();
  }

  Future<void> fetchAllTransactions() async {
    try {
      isLoading.value = true;
      transactions.clear();

      // Fetch first page to get pagination info
      final response = await historyRepo.fetchTransactions(page: 1);

      if (response.containsKey('transactions')) {
        final transactionData = response['transactions'];

        // Update pagination information
        currentPage.value = 1;
        totalPages.value = transactionData['last_page'] ?? 1;
        totalItems.value = transactionData['total'] ?? 0;

        // Process first page
        List<Map<String, dynamic>> firstPageTransactions =
            processTransactionData(transactionData['data'] ?? []);
        transactions.addAll(firstPageTransactions);

        // Fetch remaining pages
        for (int page = 2; page <= totalPages.value; page++) {
          final pageResponse = await historyRepo.fetchTransactions(page: page);

          if (pageResponse.containsKey('transactions')) {
            final pageData = pageResponse['transactions'];
            List<Map<String, dynamic>> pageTransactions =
                processTransactionData(pageData['data'] ?? []);
            transactions.addAll(pageTransactions);
          }
        }

        // Sort all transactions by date (newest first)
        transactions.sort((a, b) {
          try {
            // final dateFormat = DateFormat('MMM d, HH:mm');
            DateTime dateA = a['dateTime'];
            DateTime dateB = b['dateTime'];
            return dateB.compareTo(dateA);
          } catch (e) {
            print('Date sorting error: $e');
            return 0;
          }
        });

        // Apply filters after loading all data
        applyFilters();
      }
    } catch (e) {
      print('Error fetching all transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Helper method to process transaction data
  List<Map<String, dynamic>> processTransactionData(
      List<dynamic> transactionsList) {
    return transactionsList.map((item) {
      // Extract transaction type from transactional_type
      String category = 'Other';
      if (item['transactional_type'] != null) {
        String type = item['transactional_type'];
        if (type.contains('Electricity')) {
          category = 'Electricity';
        } else if (type.contains('Airtime')) {
          category = 'Airtime';
        } else if (type.contains('Data')) {
          category = 'Data';
        } else if (type.contains('Cable')) {
          category = 'Cable TV';
        } else if (type.contains('Transaction')) {
          category = 'Deposit';
        } else if (type.contains('Payout')) {
          category = 'Transfer';
        } else if (type.contains('WAEC')) {
          category = 'WAEC';
        } else if (type.contains('Internet')) {
          category = 'Internet';
        } else if (type.contains('NECO')) {
          category = 'NECO';
        }
      }

      // Determine status based on transaction details
      String status = 'Successful';
      if (item['transaction_status'] != null) {
        if (item['transaction_status'] == 'failed') {
          status = 'Failed';
        } else if (item['transaction_status'] == 'pending') {
          status = 'Pending';
        }
      }
      if (item['trx_id'] == null || item['trx_id'].isEmpty) {
        status = 'Pending';
      }

      // Format date
      String date = 'Unknown';
      DateTime? dateTime;
      if (item['created_at'] != null) {
        try {
          dateTime = DateTime.parse(item['created_at']);
          date = DateFormat('MM, d HH:MM').format(dateTime);
        } catch (e) {
          date = 'Invalid Date';
        }
      }

      String amount = item['amount'].toString();
      if (item['trx_type'] == '+') {
        amount = '+ ₦$amount';
      }
      if (item['trx_type'] == '-') {
        amount = '- ₦$amount';
      }

      // Build title from transaction type or remarks
      String title = item['remarks'] ?? 'Transaction';
      if (title.isEmpty) {
        title = category + ' Transaction';
      }

      return {
        'id': item['id'],
        'title': title,
        'category': category,
        'status': status,
        'date': date,
        'dateTime':
            dateTime, // Store the actual DateTime for sorting and grouping
        'amount': amount,
        'transactional_type': item['transactional_type'],
        'raw': item, // Keep the raw data for reference if needed
      };
    }).toList();
  }

  // Apply filters based on selected status, category, and date
  void applyFilters() {
    List<Map<String, dynamic>> filtered =
        List<Map<String, dynamic>>.from(transactions);

    // Filter by status
    if (selectedStatus.value != 'All') {
      filtered = filtered
          .where((transaction) => transaction['status'] == selectedStatus.value)
          .toList();
    }

    // Filter by category
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where((transaction) =>
              transaction['category']?.contains(selectedCategory.value) == true)
          .toList();
    }

    // // Filter by date
    // if (selectedDate.value != null) {
    //   final selectedDateStr =
    //       DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    //   filtered = filtered.where((transaction) {
    //     try {
    //       return transaction['date'] == selectedDateStr;
    //     } catch (e) {
    //       return false;
    //     }
    //   }).toList();
    // }
    // Filter by date
    if (selectedDate.value != null) {
      final selectedDay = DateTime(
        selectedDate.value!.year,
        selectedDate.value!.month,
        selectedDate.value!.day,
      );

      filtered = filtered.where((transaction) {
        try {
          if (transaction['dateTime'] == null) return false;

          final transactionDay = DateTime(
            transaction['dateTime'].year,
            transaction['dateTime'].month,
            transaction['dateTime'].day,
          );

          return transactionDay.isAtSameMomentAs(selectedDay);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    Map<String, List<Map<String, dynamic>>> transactionsByMonth = {};

    DateTime now = DateTime.now();
    String currentMonthKey = DateFormat('yyyy-MM').format(now);

    for (var transaction in filtered) {
      if (transaction['dateTime'] != null) {
        DateTime date = transaction['dateTime'];
        String monthKey = DateFormat('yyyy-MM').format(date);

        if (!transactionsByMonth.containsKey(monthKey)) {
          transactionsByMonth[monthKey] = [];
        }
        transactionsByMonth[monthKey]!.add(transaction);
      }
    }

    // Flatten the grouped transactions but keep track of month sections
    List<Map<String, dynamic>> organizedTransactions = [];

    // Add current month first (if exists)
    // if (transactionsByMonth.containsKey(currentMonthKey)) {
    //   organizedTransactions.add({
    //     'isMonthHeader': true,
    //     'monthName': 'Current Month',
    //     'monthKey': currentMonthKey
    //   });
    //   organizedTransactions.addAll(transactionsByMonth[currentMonthKey]!);
    //   transactionsByMonth.remove(currentMonthKey);
    // }

    // Add remaining months in order (newest first)
    List<String> remainingMonths = transactionsByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort in descending order

    for (String monthKey in remainingMonths) {
      DateTime monthDate = DateTime.parse('$monthKey-01');
      String monthName = DateFormat('MMMM yyyy').format(monthDate);

      organizedTransactions.add({
        'isMonthHeader': true,
        'monthName': monthName,
        'monthKey': monthKey
      });
      organizedTransactions.addAll(transactionsByMonth[monthKey]!);
    }

    filteredTransactions.assignAll(organizedTransactions);
  }

  // Update selected status and apply filters
  void updateStatus(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  // Update selected category and apply filters
  void updateCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  // Update selected date and apply filters
  void updateDate(DateTime date) {
    selectedDate.value = date;
    update();
    print(selectedDate.value);
    applyFilters();
  }

  // Method to load next page
  Future<void> loadNextPage() async {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      await fetchAllTransactions();
    }
  }

  // Method to refresh transactions
  Future<void> refreshTransactions() async {
    currentPage.value = 1;
    await fetchAllTransactions();
  }

  // Get available transaction types for filtering
  List<String> getAvailableCategories() {
    Set<String> categories = {'All'};

    for (var transaction in transactions) {
      if (transaction['category'] != null) {
        categories.add(transaction['category']);
      }
    }

    return categories.toList();
  }

  // Get available statuses for filtering
  List<String> getAvailableStatuses() {
    return ['All', 'Successful', 'Pending', 'Failed'];
  }
}
