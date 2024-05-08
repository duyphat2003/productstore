class CartItem {
  final String productName;
  final double price;
  late int quantity;
  final String imageUrl;
  final String account;
  final String orderNumber;

  CartItem(
    this.productName,
    this.price,
    this.quantity,
    this.imageUrl,
    this.account,
    this.orderNumber,
  );
}