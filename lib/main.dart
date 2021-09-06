import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screen/cartscreen.dart';
import 'package:shopapp/screen/orders_screen.dart';
import 'package:shopapp/widgets/product_details.dart';
import 'package:shopapp/widgets/productoverview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MY Shop App",
        home: ProductOverview(),
        routes: {
          ProductDetails.routeName: (context) => ProductDetails(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
        },
      ),
    );
  }
}