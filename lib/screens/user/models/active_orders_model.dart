// To parse this JSON data, do
//
//     final activeOrdersModel = activeOrdersModelFromJson(jsonString);

import 'dart:convert';

ActiveOrdersModel activeOrdersModelFromJson(String str) => ActiveOrdersModel.fromJson(json.decode(str));

String activeOrdersModelToJson(ActiveOrdersModel data) => json.encode(data.toJson());

class ActiveOrdersModel {
  List<ActiveOrder> activeOrders;

  ActiveOrdersModel({
    required this.activeOrders,
  });

  factory ActiveOrdersModel.fromJson(Map<String, dynamic> json) => ActiveOrdersModel(
        activeOrders: List<ActiveOrder>.from(json["activeOrders"].map((x) => ActiveOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activeOrders": List<dynamic>.from(activeOrders.map((x) => x.toJson())),
      };
}

class ActiveOrder {
  ScooperReview scooperReview;
  String id;
  String customer;
  String address;
  int status;
  int deliveryCharges;
  int tip;
  String specialInstructions;
  List<FoodItem> foodItems;
  int tax;
  int total;
  int subtotal;
  dynamic cancelReason;
  dynamic restaurantTime;
  dynamic completeTime;
  String remainingTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ActiveOrder({
    required this.scooperReview,
    required this.id,
    required this.customer,
    required this.address,
    required this.status,
    required this.deliveryCharges,
    required this.tip,
    required this.specialInstructions,
    required this.foodItems,
    required this.tax,
    required this.total,
    required this.subtotal,
    required this.cancelReason,
    required this.restaurantTime,
    required this.completeTime,
    required this.remainingTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ActiveOrder.fromJson(Map<String, dynamic> json) => ActiveOrder(
        scooperReview: ScooperReview.fromJson(json["scooperReview"]),
        id: json["_id"],
        customer: json["customer"],
        address: json["address"],
        status: json["status"],
        deliveryCharges: json["delivery_charges"],
        tip: json["tip"],
        specialInstructions: json["special_instructions"],
        foodItems: List<FoodItem>.from(json["foodItems"].map((x) => FoodItem.fromJson(x))),
        tax: json["tax"],
        total: json["total"],
        subtotal: json["subtotal"],
        cancelReason: json["cancelReason"],
        restaurantTime: json["restaurantTime"],
        completeTime: json["completeTime"],
        remainingTime: json["remainingTime"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "scooperReview": scooperReview.toJson(),
        "_id": id,
        "customer": customer,
        "address": address,
        "status": status,
        "delivery_charges": deliveryCharges,
        "tip": tip,
        "special_instructions": specialInstructions,
        "foodItems": List<dynamic>.from(foodItems.map((x) => x.toJson())),
        "tax": tax,
        "total": total,
        "subtotal": subtotal,
        "cancelReason": cancelReason,
        "restaurantTime": restaurantTime,
        "completeTime": completeTime,
        "remainingTime": remainingTime,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class FoodItem {
  String item;
  int quantity;
  int price;
  String id;

  FoodItem({
    required this.item,
    required this.quantity,
    required this.price,
    required this.id,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        item: json["item"],
        quantity: json["quantity"],
        price: json["price"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "quantity": quantity,
        "price": price,
        "_id": id,
      };
}

class ScooperReview {
  int rating;
  String message;

  ScooperReview({
    required this.rating,
    required this.message,
  });

  factory ScooperReview.fromJson(Map<String, dynamic> json) => ScooperReview(
        rating: json["rating"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "message": message,
      };
}
