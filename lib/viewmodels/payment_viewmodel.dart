import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';

// ViewModel untuk mengatur saldo & riwayat transaksi pengguna
class PaymentViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isProcessing = false;
  String? _errorMessage;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  // Read: saldo pengguna real-time dari koleksi `users`
  Stream<int> get balanceStream {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(0);
    return _firestore.collection('users').doc(uid).snapshots().map(
          (doc) => (doc.data()?['balance'] as num?)?.toInt() ?? 0,
        );
  }

  // Read: riwayat transaksi milik pengguna dari koleksi `orders`, terbaru di atas
  Stream<List<Map<String, dynamic>>> get transactionHistory {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return _firestore
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
      orders.sort((a, b) {
        final timeA = a['timestamp'] as Timestamp?;
        final timeB = b['timestamp'] as Timestamp?;
        if (timeA == null || timeB == null) return 0;
        return timeB.compareTo(timeA);
      });
      return orders;
    });
  }

  // Delete: hapus satu dokumen riwayat transaksi dari koleksi `orders`
  Future<void> deleteTransaction(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }

  // Update: tambah saldo pengguna (top up) di koleksi `users`
  Future<bool> topUp(int amount) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || amount <= 0) return false;

    try {
      await _firestore.collection('users').doc(uid).update({
        'balance': FieldValue.increment(amount),
      });
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah saldo, silakan coba lagi.';
      notifyListeners();
      return false;
    }
  }

  // Create & Update: checkout -> tulis dokumen ke `orders` & kurangi saldo `users/{uid}`
  Future<bool> checkout(List<CartItemModel> items, int totalPrice) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || items.isEmpty) return false;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    final userRef = _firestore.collection('users').doc(uid);

    try {
      await _firestore.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final currentBalance = (userSnapshot.data()?['balance'] as num?)?.toInt() ?? 0;

        if (currentBalance < totalPrice) {
          throw Exception('Saldo tidak cukup untuk melakukan checkout.');
        }

        final orderRef = _firestore.collection('orders').doc();
        transaction.set(orderRef, {
          'uid': uid,
          'items': items.map((item) => item.toMap()).toList(),
          'total_price': totalPrice,
          'timestamp': FieldValue.serverTimestamp(),
        });

        transaction.update(userRef, {'balance': currentBalance - totalPrice});
      });

      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
