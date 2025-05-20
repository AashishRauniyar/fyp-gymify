class EsewaPaymentResponse {
  final int amount;
  final int taxAmount;
  final int totalAmount;
  final String transactionUuid;
  final String productCode;
  final int productServiceCharge;
  final int productDeliveryCharge;
  final String successUrl;
  final String failureUrl;
  final String signedFieldNames;
  final String signature;

  EsewaPaymentResponse({
    required this.amount,
    required this.taxAmount,
    required this.totalAmount,
    required this.transactionUuid,
    required this.productCode,
    required this.productServiceCharge,
    required this.productDeliveryCharge,
    required this.successUrl,
    required this.failureUrl,
    required this.signedFieldNames,
    required this.signature,
  });

  factory EsewaPaymentResponse.fromJson(Map<String, dynamic> json) {
    return EsewaPaymentResponse(
      amount: json['amount'],
      taxAmount: json['tax_amount'],
      totalAmount: json['total_amount'],
      transactionUuid: json['transaction_uuid'],
      productCode: json['product_code'],
      productServiceCharge: json['product_service_charge'],
      productDeliveryCharge: json['product_delivery_charge'],
      successUrl: json['success_url'],
      failureUrl: json['failure_url'],
      signedFieldNames: json['signed_field_names'],
      signature: json['signature'],
    );
  }
}
