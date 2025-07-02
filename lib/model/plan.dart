class PlanLocal {
  final int id;
  final String type;
  final int clases;
  final double price;

  PlanLocal({
    required this.id,
    required this.type,
    required this.clases,
    required this.price,
  });

  factory PlanLocal.fromMap(Map<String, dynamic> map) {
    return PlanLocal(
      id: map['id'],
      type: map['type'],
      clases: map['clases'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'type': type, 'clases': clases, 'price': price};
  }
}
