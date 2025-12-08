import 'package:brodbay/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;
    final displayName = user.displayName ?? user.email ?? 'No name';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                  child: user.photoURL == null ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(user.email ?? '', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await auth.signOut();
                  },
                  child: const Text('Sign out'),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Welcome to your profile. You can expand this area to show more user specific data or settings.'),
        ],
      ),
    );
  }
}
