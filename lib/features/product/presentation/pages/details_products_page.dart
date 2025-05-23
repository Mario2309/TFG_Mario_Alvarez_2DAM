import 'package:flutter/material.dart';
import 'package:nexuserp/features/product/domain/entities/product.dart';

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
            _buildSectionTitle('Información del Producto'),
            _buildDetailItem('Tipo', product.tipo as String),
            _buildDetailItem(
              'Precio',
              '\$${product.precio.toStringAsFixed(2)}',
            ),
            _buildDetailItem('Stock', '${product.cantidad} unidades'),
            const SizedBox(height: 15),
            _buildSectionTitle('Descripción'),
            _buildDescription(product.descripcion),
            const SizedBox(height: 15),
            _buildSectionTitle('Información Adicional'),
            _buildDetailItem(
              'ID del Proveedor',
              product.proveedorId?.toString() ?? 'No disponible',
            ),
            const SizedBox(height: 30),
            // Puedes añadir más secciones o botones aquí
          ],
        ),
      ),
    );
  }

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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

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

  Widget _buildDescription(String? description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        description ?? 'No hay descripción disponible.',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
