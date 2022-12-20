import 'package:flutter/material.dart';
import 'package:form_validation/models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: _cardBorders(),
        margin: const EdgeInsets.only(
          top: 30,
          bottom: 20,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _BackgroundImage(urlImage: product.picture),
            _ProductDetails(
              id: product.id!,
              name: product.name,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.price),
            ),
            if (!product.available)
              const Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 7),
          blurRadius: 10,
        ),
      ],
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(25);

    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius:
            const BorderRadius.only(topLeft: radius, bottomRight: radius),
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'Unavailable',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({Key? key, required this.price}) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(25);

    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(topRight: radius, bottomLeft: radius),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          '\$$price',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              id,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
    this.urlImage,
  }) : super(key: key);

  final String? urlImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: urlImage == null
            ? const Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(urlImage!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
