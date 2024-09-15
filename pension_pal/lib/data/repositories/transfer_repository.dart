import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transfer.dart';

class TransferRepository {
  final String baseUrl;
  final http.Client httpClient;
  final List<Transfer> _transfers = []; // Simulated data store

  TransferRepository({
    this.baseUrl = 'https://api.example.com',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Fetch all transfer data
  Future<List<Transfer>> fetchTransferData() async {
    // TODO: Replace with actual API call
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Transfer>.from(_transfers);
  }

  /// Add a new transfer
  Future<void> addTransfer(Transfer transfer) async {
    // TODO: Replace with actual API call
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _transfers.add(transfer);
  }

  /// Remove an existing transfer by ID
  Future<void> removeTransfer(String transferId) async {
    // TODO: Replace with actual API call
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _transfers.removeWhere((transfer) => transfer.id == transferId);
  }

  /// Transfer funds to a recipient
  Future<bool> transferFunds(double amount, String recipient) async {
    final Uri url = Uri.parse('$baseUrl/transfer');
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final String body = jsonEncode({
      'amount': amount,
      'recipient': recipient,
    });

    try {
      final http.Response response = await httpClient.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] as bool? ?? false;
      } else {
        throw Exception(
            'Failed to transfer funds. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Consider using a logging library instead of print in production
      print('Error transferring funds: $e');
      return false;
    }
  }
}