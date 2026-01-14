import 'package:brodbay/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final appInitProvider = FutureProvider<void>((ref) async {
  // 1️⃣ Fetch campaign from backend
  final String campaignName = await _fetchCampaignFromApi();

  // 2️⃣ Apply theme BEFORE Home loads
  ref.read(themeProvider.notifier).applyCampaign(campaignName);

  // 3️⃣ Small splash delay (UX only)
  await Future.delayed(const Duration(seconds: 5));
});

// Mock API call (replace later)
Future<String> _fetchCampaignFromApi() async {
  await Future.delayed(const Duration(milliseconds: 700));
  return ''; 
}
