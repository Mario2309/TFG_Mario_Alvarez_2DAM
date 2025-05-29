import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';
import 'package:nexuserp/core/utils/products_strings.dart';

/// Pantalla de detalles de un producto.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nombre),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, product.nombre),
            const SizedBox(height: 20),
            _buildSectionTitle(ProductsStrings.productInfo),
            _buildDetailItem(ProductsStrings.type, product.tipo as String),
            _buildDetailItem(
              ProductsStrings.price,
              '\u0024${product.precio.toStringAsFixed(2)}',
            ),
            _buildDetailItem(
              ProductsStrings.stock,
              '${product.cantidad} ${ProductsStrings.units}',
            ),
            const SizedBox(height: 15),
            _buildSectionTitle(ProductsStrings.description),
            _buildDescription(product.descripcion),
            const SizedBox(height: 15),
            _buildSectionTitle(ProductsStrings.additionalInfo),
            _buildDetailItem(
              ProductsStrings.providerId,
              product.proveedorId?.toString() ?? ProductsStrings.notAvailable,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Construye el encabezado con el nombre y el icono del producto.
  Widget _buildHeader(BuildContext context, String name) {
    return Row(
      children: [
        Icon(
          Icons.shopping_bag,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Construye el título de una sección.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Construye un ítem de detalle con etiqueta y valor.
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  /// Construye la sección de descripción del producto.
  Widget _buildDescription(String? description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        description ?? ProductsStrings.noDescription,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
