class CustomerResponseModel {

  final String? gofixMessage;
  final String? buybackMessage;

  final GoFixCustomerData? gofixResponse;
  final BuyBackCustomerData? buybackResponse;

  CustomerResponseModel({
    this.gofixMessage,
    this.buybackMessage,
    this.gofixResponse,
    this.buybackResponse,
  });

  factory CustomerResponseModel.fromJson(
      Map<String, dynamic> json) {

    return CustomerResponseModel(

      gofixMessage: json['gofix_message'],
      buybackMessage: json['buyback_message'],

      gofixResponse: json['gofix_response'] != null
          ? GoFixCustomerData.fromJson(
          json['gofix_response'])
          : null,

      buybackResponse: json['buyback_response'] != null
          ? BuyBackCustomerData.fromJson(
          json['buyback_response'])
          : null,
    );
  }
}

/// GOFIX MODEL
class GoFixCustomerData {

  final int? customerId;
  final String? name;
  final String? emailAddress;
  final String? alternatePhoneNo;

  GoFixCustomerData({
    this.customerId,
    this.name,
    this.emailAddress,
    this.alternatePhoneNo,
  });

  factory GoFixCustomerData.fromJson(
      Map<String, dynamic> json) {

    return GoFixCustomerData(

      customerId: json['customerId'],
      name: json['name'],
      emailAddress: json['emailAddress'],
      alternatePhoneNo: json['alternatePhoneNo'],
    );
  }
}

/// BUYBACK MODEL
class BuyBackCustomerData {

  final int? customerId;
  final String? customerName;
  final String? mobileNo;
  final String? emailId;
  final int? disabled;

  BuyBackCustomerData({
    this.customerId,
    this.customerName,
    this.mobileNo,
    this.emailId,
    this.disabled,
  });

  factory BuyBackCustomerData.fromJson(
      Map<String, dynamic> json) {

    return BuyBackCustomerData(

      customerId: json['ch_customer_id'],
      customerName: json['customer_name'],
      mobileNo: json['mobile_no'],
      emailId: json['email_id'],
      disabled: json['disabled'],
    );
  }
}

/// buyback_customer_response_model.dart

class BuyBackCustomerResponseModel {
  bool success;
  String customer;
  String action;

  BuyBackCustomerResponseModel({
    required this.success,
    required this.customer,
    required this.action,
  });

  factory BuyBackCustomerResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BuyBackCustomerResponseModel(
      success: json['success'] ?? false,
      customer: json['customer'] ?? '',
      action: json['action'] ?? '',
    );
  }
}


/// buyback_customer_model.dart

class BuyBackCustomerModel {
  String customerId;
  String customerName;
  String mobileNo;
  String emailId;
  int disabled;
  String owner;
  String modifiedBy;
  List<BuyBackAddressModel> addresses;
  List<BuyBackPaymentAccountModel> paymentAccounts;

  BuyBackCustomerModel({
    required this.customerId,
    required this.customerName,
    required this.mobileNo,
    required this.emailId,
    this.disabled = 0,
    this.owner = '',
    this.modifiedBy = '',
    this.addresses = const [],
    this.paymentAccounts = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "customer_name": customerName,
      "mobile_no": mobileNo,
      "email_id": emailId,
      "disabled": disabled,
      "owner": owner,
      "modified_by": modifiedBy,
      "addresses": addresses.map((e) => e.toJson()).toList(),
      "payment_accounts":
      paymentAccounts.map((e) => e.toJson()).toList(),
    };
  }
}

class BuyBackAddressModel {
  String addressType;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String country;
  String pincode;
  int isPrimaryAddress;

  BuyBackAddressModel({
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    this.isPrimaryAddress = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "address_type": addressType,
      "address_line1": addressLine1,
      "address_line2": addressLine2,
      "city": city,
      "state": state,
      "country": country,
      "pincode": pincode,
      "is_primary_address": isPrimaryAddress,
    };
  }
}

class BuyBackPaymentAccountModel {
  String accountLabel;
  String paymentMode;
  int isDefault;
  String bankName;
  String branch;
  String accountHolderName;
  String accountNo;
  String ifscCode;
  String upiId;

  BuyBackPaymentAccountModel({
    required this.accountLabel,
    required this.paymentMode,
    this.isDefault = 0,
    required this.bankName,
    required this.branch,
    required this.accountHolderName,
    required this.accountNo,
    required this.ifscCode,
    required this.upiId,
  });

  Map<String, dynamic> toJson() {
    return {
      "account_label": accountLabel,
      "payment_mode": paymentMode,
      "is_default": isDefault,
      "bank_name": bankName,
      "branch": branch,
      "account_holder_name": accountHolderName,
      "account_no": accountNo,
      "ifsc_code": ifscCode,
      "upi_id": upiId,
    };
  }
}