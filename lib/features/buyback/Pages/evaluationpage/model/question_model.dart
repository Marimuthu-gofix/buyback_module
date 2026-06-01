class BuybackResponse {
  final bool success;
  final String itemCode;
  final int count;
  final List<CategoryModel> data;

  BuybackResponse({
    required this.success,
    required this.itemCode,
    required this.count,
    required this.data,
  });

  factory BuybackResponse.fromJson(Map<String, dynamic> json) {
    return BuybackResponse(
      success: json['success'] ?? false,
      itemCode: json['item_code'] ?? "",
      count: json['count'] ?? 0,
      data: List<CategoryModel>.from(
        (json['data'] ?? []).map((x) => CategoryModel.fromJson(x)),
      ),
    );
  }
}

class CategoryModel {
  final String category;
  final List<QuestionModel> questions;

  CategoryModel({required this.category, required this.questions});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['Category'] ?? "",
      questions: List<QuestionModel>.from(
        (json['Questions'] ?? []).map((x) => QuestionModel.fromJson(x)),
      ),
    );
  }
}

class QuestionModel {
  final String questionName;
  final String questionCode;
  final String questionText;
  final String questionType;
  final int displayOrder;
  final List<OptionModel> options;

  QuestionModel({
    required this.questionName,
    required this.questionCode,
    required this.questionText,
    required this.questionType,
    required this.displayOrder,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      questionName: json['QuestionName'] ?? "",
      questionCode: json['QuestionCode'] ?? "",
      questionText: json['QuestionText'] ?? "",
      questionType: json['QuestionType'] ?? "",
      displayOrder: json['DisplayOrder'] ?? 0,
      options: List<OptionModel>.from(
        (json['Options'] ?? []).map((x) => OptionModel.fromJson(x)),
      ),
    );
  }
}

class OptionModel {
  final String optionLabel;
  final String optionValue;
  final double priceImpactPercent;

  OptionModel({
    required this.optionLabel,
    required this.optionValue,
    required this.priceImpactPercent,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      optionLabel: json['OptionLabel'] ?? "",
      optionValue: json['OptionValue'] ?? "",
      priceImpactPercent: (json['PriceImpactPercent'] ?? 0).toDouble(),
    );
  }
}
