

class ProductsModel{
  int id;
  String image;
  String mainName;
  String nameAr;
  String nameEn;
  String price;
  int liked;



  ProductsModel(this.id, this.image,this.mainName, this.nameAr, this.nameEn,this.price,this.liked);


  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    json['id'],
    json["image_one"],
    json["name"],
    json['translations'][0]['name'],
    json['translations'][1]['name'],
    json["price"],
    json["in_favourite"]

  );
}


