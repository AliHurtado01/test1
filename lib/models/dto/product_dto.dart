class ProductDto {
  final String id;
  final String nombre;
  final String businessId;

  ProductDto({
    required this.id,
    required this.nombre,
    required this.businessId,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      businessId: json['business_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'business_id': businessId};
  }
}
