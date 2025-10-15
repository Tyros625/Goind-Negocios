class VatTaxModel {
  int? id;
  String? name;
  double? taxRate;

  VatTaxModel({this.id, this.name, this.taxRate});

  VatTaxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    taxRate = double.tryParse(json['tax_rate'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_rate'] = taxRate;
    return data;
  }
}
