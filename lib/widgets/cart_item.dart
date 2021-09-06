import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItems extends StatelessWidget {
  final String? id;
  final String? productId;
  final String? title;
  final double? price;
  final int? quantity;

  const CartItems(
      {Key? key,
      this.id,
      this.title,
      this.price,
      this.quantity,
      this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId!);
      },
      key: ValueKey(id),
      background: Container(
        color: Colors.red.shade400,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text("Rs.$price")),
              ),
            ),
            title: Text(title!),
            subtitle: Text("Total: Rs.${(price! * quantity!)}"),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
