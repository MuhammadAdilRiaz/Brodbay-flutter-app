class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  final double? sale_price; 
  final double? regular_price; 
  final int quantity;
  final int stock;
  final bool isSelected;
  final String sellerId;
  final String currencySymbol; 

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.sale_price,
    this.regular_price,
    required this.stock,
    this.quantity = 1,
    this.isSelected = true,
    required this.sellerId,
    this.currencySymbol = '£',
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
      regular_price: regular_price,
      sale_price: sale_price,
       stock: stock,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      sellerId: sellerId,
    );
  }
}
