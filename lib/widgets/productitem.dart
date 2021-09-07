import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/widgets/product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetails.routeName, arguments: product.id);
            },
            child: Image.network(product.imageUrl!)),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
              onPressed: () {
                product.toggleFavouriteStatus();
              },
              color: Colors.orange,
              icon: Icon(product.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border)),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price!, product.title!);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Cart item added!!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      }),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ),
      ),
    );
  }
}
