import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

// ViewModel untuk mengatur alur login/register & sesi pengguna via Firebase Auth
class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  // Digunakan oleh View untuk mendeteksi sesi aktif (auto-login)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthViewModel() {
    // Saat aplikasi dibuka, jika sesi masih aktif, ambil data profil dari Firestore
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchUserData(user.uid);
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  // Registrasi pengguna baru: buat akun Firebase Auth + dokumen profil di Firestore
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final newUser = UserModel(
        uid: uid,
        name: name,
        email: email.trim(),
        balance: 100000,
        memberLevel: 'Bronze',
        points: 0,
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      _userModel = newUser;
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  // Login pengguna dengan email & password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await fetchUserData(credential.user!.uid);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  // Ambil data profil pengguna dari koleksi Firestore `users`
  Future<void> fetchUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      _userModel = UserModel.fromMap(doc.data()!);
    }
    notifyListeners();
  }

  // Logout pengguna dari sesi aktif
  Future<void> logout() async {
    await _auth.signOut();
    _userModel = null;
    notifyListeners();
  }

  // Update: ubah nama & foto profil pengguna (tersimpan di Firestore `users`)
  Future<bool> updateProfile({String? name, String? photoBase64}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _userModel == null) return false;

    _setLoading(true);
    try {
      final updates = <String, dynamic>{};
      if (name != null && name.trim().isNotEmpty) updates['name'] = name.trim();
      if (photoBase64 != null) updates['photo_base64'] = photoBase64;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updates);
        _userModel = _userModel!.copyWith(
          name: name != null && name.trim().isNotEmpty ? name.trim() : null,
          photoBase64: photoBase64,
        );
      }

      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui profil, silakan coba lagi.';
      _setLoading(false);
      return false;
    }
  }

  // Update: ubah password pengguna (memerlukan re-autentikasi dengan password saat ini)
  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return false;

    _setLoading(true);
    try {
      final cred = EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      _errorMessage = null;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return e.message ?? 'Terjadi kesalahan, silakan coba lagi.';
    }
  }
}
