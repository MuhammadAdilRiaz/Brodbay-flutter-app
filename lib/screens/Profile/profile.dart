import 'package:brodbay/providers/connectivity_providers.dart';
import 'package:brodbay/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Signin/signin.dart';
import 'profile_detail.dart';
import 'widgets/Buttons/buttons.dart';
import 'widgets/Profile Info/profile_info.dart';
import 'widgets/Search Bar/profile_searchbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // true when the user requested sign in (shows only sign form)
  bool _showSignInForm = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // If auth.user becomes non-null, clear the signing-in flag so we move to signed-in state.
    if (auth.user != null && _showSignInForm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showSignInForm = false;
          });
        }
      });
    }

    final bool isSignedIn = auth.user != null;
    // 2) Signing in -> show only SignInForm
    final bool isSigningIn = !isSignedIn && _showSignInForm;
    // 3) Default -> show ProfileInfo + ButtonsWidget
    final bool isDefault = !isSignedIn && !_showSignInForm;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar content changes depending on state
              SliverAppBar(
                  leading: isSigningIn
                ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                 onPressed: () {
                 setState(() {
                 _showSignInForm = false;
               });
              },
          )
              : null,
            pinned: true,
            backgroundColor: const Color(0xFFFF6304),
            elevation: 0,
            centerTitle: isSigningIn,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isDefault
                  ? const ProfileSearchbar(key: ValueKey('search'))
                  : isSigningIn
                      ? const Text('Sign in', key: ValueKey('signintitle'))
                      : (auth.user != null
                          ? Text(
                              auth.user!.displayName ?? 'Profile',
                              key: const ValueKey('profiletitle'),
                            )
                          : const SizedBox.shrink()),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: auth.user == null
                      ? const CircleAvatar(
                          radius: 18,
                          child: Icon(Icons.person),
                        )
                      : CircleAvatar(
                          radius: 18,
                          backgroundImage: auth.user!.photoURL != null
                              ? NetworkImage(auth.user!.photoURL!)
                              : null,
                          child: auth.user!.photoURL == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                ),
              )
            ],
          ),

          // BODY:
          // Signed in -> only ProfileDetails
          if (isSignedIn) ...[
            SliverFillRemaining(
              child: Column(
                children: const [
                  SizedBox(height: 12),
                  // Optionally you can keep ProfileInfo when signed in. User requested only details,
                  // so we show only ProfileDetails here.
                  ProfileDetails(),
                ],
              ),
            ),
          ] else if (isSigningIn) ...[
            // Signing in -> hide everything else and show sign form centered
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // The sign in form (your existing SignInForm) — kept inline
                      const SignInForm(),
                    ],
                  ),
                ),
              ),
            )
          ] else ...[
            // Default -> show ProfileInfo + ButtonsWidget
            const SliverToBoxAdapter(child: ProfileInfo()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ButtonsWidget triggers the sign-in flow via onAuthTap
                  Buttonswidget(
                    onAuthTap: () {
                      setState(() {
                        _showSignInForm = true;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // If you want some filler so content isn't cramped, you can add a spacer
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(),
            ),
          ],
        ],
      ),
    );
  }
}
