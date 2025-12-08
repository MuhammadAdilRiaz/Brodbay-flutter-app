// lib/providers/detail_state_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// index of the currently selected image in the thumbnails
final selectedImageIndexProvider = StateProvider<int>((ref) => 0);

// chosen quantity for the product
final quantityProvider = StateProvider<int>((ref) => 1);
