import 'package:flutter/material.dart';

import '../../constant.dart';
import 'mapToRestaurant.dart';

class SkooperRideRequestDetails extends StatefulWidget {
  var orderDetails;
  bool isAccepted;
  SkooperRideRequestDetails(this.orderDetails, this.isAccepted);

  @override
  State<SkooperRideRequestDetails> createState() =>
      _SkooperRideRequestDetailsState();
}

class _SkooperRideRequestDetailsState extends State<SkooperRideRequestDetails> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> itemsLength = widget.orderDetails['foodItems'];
    int orderStatus = widget.orderDetails['status'];
    print('askjf length');
    print(itemsLength.length.toString());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBG,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: !isDark ? kSecondaryColor : kSupportiveGrey,
            ),
            // Within the `FirstRoute` widget
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CartScreen()),
              // );
            }),
        title: Text(
          'Order Details',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: itemsLength.length,
                itemBuilder: (context, index) {
                  final foodItem = itemsLength[index];
                  print('foodItem');
                  print(foodItem);
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MapToRestaurantScreen(
                                  foodItem,
                                  widget.orderDetails,
                                  widget.isAccepted,
                                  orderStatus)));
                    },
                    title: Text(
                      '${foodItem['item']['name']} (x${foodItem['quantity'].toString()})',
                      style:
                          TextStyle(color: !isDark ? kSecondaryColor : kWhite),
                    ),
                    subtitle: Text(
                      foodItem['item']['restaurant']['restaurant_name'],
                      style:
                          TextStyle(color: !isDark ? kSupportiveGrey : kWhite),
                    ),
                    trailing: Text(
                      '\$${foodItem['price'].toString()}.00',
                      style:
                          TextStyle(color: !isDark ? kSecondaryColor : kWhite),
                    ),
                    // Add more widgets to display additional information
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
