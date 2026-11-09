import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateLoadScreen extends StatefulWidget {
  const CreateLoadScreen({super.key});

  @override
  State<CreateLoadScreen> createState() => _CreateLoadScreenState();
}

class _CreateLoadScreenState extends State<CreateLoadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _cargoController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _pickupDate;
  DateTime? _deliveryDate;

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _cargoController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isPickup}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstDate = isPickup ? today : (_pickupDate ?? today);
    final initialDate = isPickup ? (_pickupDate ?? today) : (_deliveryDate ?? firstDate);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 5),
      helpText: isPickup ? 'Выберите дату погрузки' : 'Выберите дату доставки',
      cancelText: 'Отмена',
      confirmText: 'Выбрать',
    );

    if (selectedDate == null || !mounted) return;

    setState(() {
      if (isPickup) {
        _pickupDate = selectedDate;
        if (_deliveryDate != null && _deliveryDate!.isBefore(selectedDate)) {
          _deliveryDate = null;
        }
      } else {
        _deliveryDate = selectedDate;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_pickupDate == null || _deliveryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите даты погрузки и доставки.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Форма заполнена'),
        content: const Text(
          'Создание и публикация грузов заработают после подключения backend. '
          'Сейчас данные формы не сохраняются.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return 'Выберите дату';
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String? _requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Укажите $fieldName';
    }
    return null;
  }

  String? _positiveNumber(String? value, String fieldName) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return 'Введите корректное значение для поля «$fieldName»';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Создать груз')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Маршрут',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _originController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Город погрузки',
                  prefixIcon: Icon(Icons.trip_origin),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _requiredText(value, 'город погрузки'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _destinationController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Город доставки',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final error = _requiredText(value, 'город доставки');
                  if (error != null) return error;
                  if (value!.trim().toLowerCase() ==
                      _originController.text.trim().toLowerCase()) {
                    return 'Город доставки должен отличаться от города погрузки';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Информация о грузе',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cargoController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Тип груза',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _requiredText(value, 'тип груза'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Вес, кг',
                  prefixIcon: Icon(Icons.scale_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _positiveNumber(value, 'вес'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Оплата',
                  prefixIcon: Icon(Icons.payments_outlined),
                  hintText: 'Укажите сумму',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _positiveNumber(value, 'оплата'),
              ),
              const SizedBox(height: 24),
              Text(
                'Даты',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _DatePickerTile(
                label: 'Дата погрузки',
                value: _dateLabel(_pickupDate),
                onTap: () => _selectDate(isPickup: true),
              ),
              const SizedBox(height: 8),
              _DatePickerTile(
                label: 'Дата доставки',
                value: _dateLabel(_deliveryDate),
                onTap: _pickupDate == null
                    ? null
                    : () => _selectDate(isPickup: false),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Продолжить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  const _DatePickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      leading: const Icon(Icons.calendar_today_outlined),
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}