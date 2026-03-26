import '../../models/domain/product.dart';
import '../../models/dto/product_dto.dart';

class ProductMapper {
  List<Product> fromDtoToDomain(List<ProductDto> dtos) {
    return dtos
        .map(
          (dto) => Product(
            id: dto.id,
            nombre: dto.nombre,
            businessId: dto.businessId,
          ),
        )
        .toList(growable: false);
  }
}
