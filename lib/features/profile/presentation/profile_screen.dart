import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'M M',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Профессиональный водитель',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _InfoSection(
              title: 'Контакты',
              children: [
                _ProfileField(
                  label: 'Телефон',
                  value: '+00000000000',
                  icon: Icons.phone_outlined,
                ),
                _ProfileField(
                  label: 'Email',
                  value: 'm@gmail.com',
                  icon: Icons.email_outlined,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _InfoSection(
              title: 'Документы',
              children: [
                _ProfileField(
                  label: 'Водительские права',
                  value: 'AB 1234567',
                  icon: Icons.badge_outlined,
                ),
                _ProfileField(
                  label: 'Страховка',
                  value: 'Действует до 12.2027',
                  icon: Icons.shield_outlined,
                ),
                _ProfileField(
                  label: 'СТС / транспорт',
                  value: 'Toyota / KZ 654A',
                  icon: Icons.local_shipping_outlined,
                ),
              ],
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Профиль обновлён'),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Обновить профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}