import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/net_image.dart';

/// Admin sign-in, split-screen: brand photography left, credentials right.
class AdminLoginPage extends ConsumerStatefulWidget {
  const AdminLoginPage({super.key});

  @override
  ConsumerState<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends ConsumerState<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(_email.text, _password.text);
      if (mounted) context.go('/admin');
    } catch (e) {
      setState(() =>
          _error = e.toString().replaceFirst('AuthException: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width > 900;

    final form = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('AUREVIA',
                        style: theme.headlineSmall?.copyWith(
                            letterSpacing: 6, fontWeight: FontWeight.w300)),
                    const SizedBox(width: 6),
                    Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.gold, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('ADMINISTRATION',
                    style: theme.labelSmall?.copyWith(
                        letterSpacing: 4, color: AppColors.inkSoft)),
                const SizedBox(height: 44),
                Text('Welcome back', style: theme.headlineLarge),
                const SizedBox(height: 10),
                Text(
                  AppConfig.isSupabaseConfigured
                      ? 'Sign in with your admin credentials.'
                      : 'Showcase mode — use ${AuthRepository.demoEmail} with password "${AuthRepository.demoPassword}".',
                  style: theme.bodyMedium,
                ),
                const SizedBox(height: 34),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'you@aurevia.travel'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'A valid email'
                      : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  onFieldSubmitted: (_) => _signIn(),
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'At least 6 characters' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(_error!,
                        style: theme.bodySmall
                            ?.copyWith(color: AppColors.danger)),
                  ),
                ],
                const SizedBox(height: 28),
                AureviaButton(
                  label: 'Sign in',
                  expand: true,
                  busy: _busy,
                  onPressed: _signIn,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/'),
                    child: Text('← Back to the site',
                        style: theme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).moveY(begin: 20, curve: Curves.easeOutCubic);

    if (!wide) return Scaffold(backgroundColor: AppColors.ivory, body: form);

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const NetImage(
                    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1600&q=75'),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: AppColors.midnightDeep.withValues(alpha: 0.5)),
                ),
                Padding(
                  padding: const EdgeInsets.all(56),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '“Every itinerary,\ncomposed like a film.”',
                        style: theme.displaySmall?.copyWith(
                            color: Colors.white, fontSize: 38),
                      ),
                      const SizedBox(height: 12),
                      Text('The operations desk, Aurevia',
                          style: theme.bodyMedium
                              ?.copyWith(color: AppColors.onDarkSoft)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 4, child: form),
        ],
      ),
    );
  }
}
