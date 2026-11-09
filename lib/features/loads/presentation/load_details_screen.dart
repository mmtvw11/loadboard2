import 'package:flutter/material.dart';

import '../domain/load.dart';
import 'load_request_screen.dart';

class LoadDetailsScreen extends StatelessWidget {
  const LoadDetailsScreen({
    required this.load,
    super.key,
  });

  final Load load;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали груза'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 190,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.local_shipping_outlined,
                size: 72,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${load.origin} → ${load.destination}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _SummaryItem(
                  icon: Icons.route_outlined,
                  text: '${load.distanceKm} км',
                ),
                _SummaryItem(
                  icon: Icons.payments_outlined,
                  text: '${load.currencyCode} ${load.priceAmount}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailsSection(
              title: 'Погрузка',
              icon: Icons.upload_outlined,
              children: [
                _DetailRow(
                  label: 'Дата и время',
                  value: _formatDateTime(context, load.pickupAt),
                ),
                if (load.pickupAddress != null)
                  _DetailRow(
                    label: 'Адрес',
                    value: load.pickupAddress!,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailsSection(
              title: 'Доставка',
              icon: Icons.flag_outlined,
              children: [
                _DetailRow(
                  label: 'Дата и время',
                  value: _formatDateTime(context, load.deliveryAt),
                ),
                if (load.deliveryAddress != null)
                  _DetailRow(
                    label: 'Адрес',
                    value: load.deliveryAddress!,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailsSection(
              title: 'Информация о грузе',
              icon: Icons.inventory_2_outlined,
              children: [
                _DetailRow(label: 'Тип груза', value: load.cargoType),
                _DetailRow(
                  label: 'Вес',
                  value: '${load.cargoWeightKg} кг',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailsSection(
              title: 'Требования к транспорту',
              icon: Icons.local_shipping_outlined,
              children: [
                _DetailRow(label: 'Тип машины', value: load.truckType),
                _DetailRow(
                  label: 'Длина кузова',
                  value: '${load.truckLengthFt} футов',
                ),
                _DetailRow(
                  label: 'Рефрижератор',
                  value: load.hasRefrigerator ? 'Требуется' : 'Не требуется',
                ),
              ],
            ),
            if (load.notes != null && load.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              _DetailsSection(
                title: 'Дополнительные условия',
                icon: Icons.info_outline,
                children: [
                  Text(load.notes!),
                ],
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LoadRequestScreen(load: load),
      ),
    );
  },
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
  child: const Text('Запросить этот груз'),
),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final localizations = MaterialLocalizations.of(context);
    final localDate = dateTime.toLocal();
    final date = localizations.formatMediumDate(localDate);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDate),
    );

    return '$date, $time';
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}


// Navigator.of(context).push(
//   MaterialPageRoute<void>(
//     builder: (_) => LoadDetailsScreen(load: load),
//   ),
// );