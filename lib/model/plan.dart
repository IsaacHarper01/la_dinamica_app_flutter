class Plan_local {
  final int id;
  final String type;
  final int clases;
  final double price;

  Plan_local({
    required this.id,
    required this.type,
    required this.clases,
    required this.price,
  });

  factory Plan_local.fromMap(Map<String, dynamic> map) {
    return Plan_local(
      id: map['id'],
      type: map['type'],
      clases: map['clases'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'clases': clases,
      'price': price,
    };
  }
}
