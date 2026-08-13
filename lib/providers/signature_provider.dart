import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_signature.dart';

class SignatureNotifier extends Notifier<List<UserSignature>> {
  static const _storageKey = 'unec_post_signatures_v2';

  @override
  List<UserSignature> build() {
    _loadSignatures();
    return [];
  }

  Future<void> _loadSignatures() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        state = decoded.map((item) => UserSignature.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading signatures: $e');
    }
  }

  Future<void> saveSignature(UserSignature signature) async {
    final existingIndex = state.indexWhere((s) => s.id == signature.id);
    
    if (existingIndex != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex) signature else state[i]
      ];
    } else {
      state = [...state, signature];
    }
    await _saveToDisk();
  }

  Future<void> deleteSignature(String id) async {
    state = state.where((s) => s.id != id).toList();
    await _saveToDisk();
  }

  Future<void> _saveToDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving signatures: $e');
    }
  }
}

final signatureProvider = NotifierProvider<SignatureNotifier, List<UserSignature>>(SignatureNotifier.new);
