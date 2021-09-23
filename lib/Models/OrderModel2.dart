
class OrderModel2{
  String productCount;
  String productTotal;
  String product_name;
  String product_image;

  OrderModel2({this.productCount, this.productTotal, this.product_name,
      this.product_image});
  factory OrderModel2.fromJson(Map<String, dynamic> json) => OrderModel2(
    productCount: json['count'].toString(),
    productTotal: json["total"].toString(),
    product_name: json["product_name"],
      product_image:json["product_image"],
  );

}