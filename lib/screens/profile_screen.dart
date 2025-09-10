// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final ImageProvider avatar =
        (user?.profileImage != null && (user!.profileImage!.isNotEmpty))
        ? NetworkImage(user.profileImage!)
        : const NetworkImage('https://via.placeholder.com/150');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const SizedBox(height: 8),
            Container(
              width: 92, // 2 * radius
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              clipBehavior: Clip.antiAlias, // keeps it circular
              child: Image(
                image: avatar, // your existing ImageProvider
                fit: BoxFit.contain, // shows the whole photo, no extra zoom
                // If you prefer slight crop but less zoom, try: BoxFit.fitWidth or BoxFit.fitHeight
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              user?.userName ?? 'Guest User',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'guest@example.com',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),

            _MenuTile(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.settings_outlined,

              title: 'Setting',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            _MenuTile(icon: Icons.mail_outline, title: 'Contact', onTap: () {}),
            _MenuTile(
              icon: Icons.share_outlined,
              title: 'Share App',
              onTap: () {},
            ),
            _MenuTile(icon: Icons.help_outline, title: 'Help', onTap: () {}),

            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Loginpage()),
                    (route) => false, // remove all previous routes
                  );
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Color(0xFFFF6A00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
