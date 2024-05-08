import 'CartItem.dart';

class OrderInfo {
  final String orderNumber;
  final List<CartItem> orderItems;
  final String orderDate;
  final String deliveryDate;
  final OrderStatus orderStatus;
  final String account;

  OrderInfo(
    this.orderNumber,
    this.orderItems,
    this.orderDate,
    this.deliveryDate,
    this.orderStatus,
    this.account,
  );
}

enum OrderStatus
{
  Pending,
  Processing,
  InTransit,
  Delivered
}