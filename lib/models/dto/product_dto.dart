class ProductDto {
  final String id;
  final String nombre;
  final String businessId;
  final int stock;

  ProductDto({
    required this.id,
    required this.nombre,
    required this.businessId,
    required this.stock,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      businessId: json['business_id'] as String,
      stock: json['stock'] as int? ?? 0, // Si 'stock' no está presente o es null, se asigna 0
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'business_id': businessId, 'stock': stock};
  }
}
