class customerOrderData{
  String name ;
  int price , qty , totalPrice;
  customerOrderData(this.name,this.price,this.qty,this.totalPrice);

  toJson(){
    return {
      "name":name,
      "price":price,
      "quantity":qty,
      "totalPrice": totalPrice
    };
  }
}