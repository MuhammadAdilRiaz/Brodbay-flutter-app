import 'package:brodbay/providers/profile%20provider/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/Custom Text Field/custom_textfield.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _triedSubmit = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider auth) async {
    setState(() => _triedSubmit = true);
    if (!_formKey.currentState!.validate()) return;

    try {
      await auth.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // on success authStateChanges will update auth.user and your screen will react
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode:
              _triedSubmit ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _emailController,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefix: const Icon(Icons.email),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                onFieldSubmitted: (_) {
                  _passwordFocus.requestFocus();
                },
                  validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter email';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                  return null;
                }, textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
                CustomTextField(
                controller: _passwordController,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hint: 'Password',
                prefix: const Icon(Icons.lock),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(auth),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter password';
                  if (v.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFB380)),
                  onPressed: auth.loading ? null : () => _submit(auth),
                  child: auth.loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign in', style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset('assets/icons/Google.png', height: 20, width: 20),
                  label: auth.loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login with Google'),
                  onPressed: auth.loading
                      ? null
                      : () async {
                          try {
                            await auth.signInWithGoogle();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                ),
              ),
              const SizedBox(height: 12),
              const Text('Do not have an account?'),
            ],
          ),
        ),
      ),
    );
  }
}
