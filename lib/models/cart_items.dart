class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  final int quantity;
  final bool isSelected;
  final String sellerId;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.isSelected = true,
    required this.sellerId,
  });

  CartItem copyWith({
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      id: id,
      title: title,
      image: image,
      price: price,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      sellerId: sellerId,
    );
  }
}
