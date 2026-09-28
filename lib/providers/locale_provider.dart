import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Langues supportées (FR par défaut).
const supportedLocales = [Locale('fr'), Locale('en')];

final localeProvider = StateProvider<Locale>((ref) => const Locale('fr'));
