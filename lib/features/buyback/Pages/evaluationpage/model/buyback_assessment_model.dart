class BuybackPostModel {
  final String customer;

  final String customerName;
  final String email;

  final String mobileNo;

  final String chCustomerId;

  final String itemCode;

  final String itemName;

  final String brand;

  final String imeiSerial;

  final String source;

  final String company;

  final String itemGroup;

  final String owner;

  final List<ResponseModel> responses;

  BuybackPostModel({
    required this.customer,

    required this.customerName,

    required this.email,
    required this.mobileNo,

    required this.chCustomerId,

    required this.itemCode,

    required this.itemName,

    required this.brand,

    required this.imeiSerial,

    required this.source,

    required this.company,

    required this.itemGroup,

    required this.owner,

    required this.responses,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer": customer,

      "customer_name": customerName,
      "email": email,
      "mobile_no": mobileNo,

      "ch_customer_id": chCustomerId,

      "item_code": itemCode,

      "item_name": itemName,

      "brand": brand,

      "imei_serial": imeiSerial,

      "source": source,

      "company": company,

      "item_group": itemGroup,

      "owner": owner,

      "responses": responses.map((e) => e.toJson()).toList(),
    };
  }
}

class ResponseModel {
  final String questionId;

  final String answerValue;

  ResponseModel({required this.questionId, required this.answerValue});

  Map<String, dynamic> toJson() {
    return {"question_id": questionId, "answer_value": answerValue};
  }
}
