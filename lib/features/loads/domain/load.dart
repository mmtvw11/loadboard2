class Load {
  const Load({
    required this.id,
    required this.origin,
    required this.destination,
    required this.distanceKm,
    required this.priceAmount,
    required this.currencyCode,
    required this.pickupAt,
    required this.deliveryAt,
    required this.cargoType,
    required this.cargoWeightKg,
    required this.truckType,
    required this.truckLengthFt,
    required this.hasRefrigerator,
    this.pickupAddress,
    this.deliveryAddress,
    this.notes,
  });

  final String id;
  final String origin;
  final String destination;
  final int distanceKm;
  final int priceAmount;
  final String currencyCode;
  final DateTime pickupAt;
  final DateTime deliveryAt;
  final String cargoType;
  final int cargoWeightKg;
  final String truckType;
  final int truckLengthFt;
  final bool hasRefrigerator;
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? notes;
}