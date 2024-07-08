import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_danain/data/serializers.dart';

part 'payment_response.g.dart';

abstract class PaymentResponse
    implements Built<PaymentResponse, PaymentResponseBuilder> {

  String get message;

  static Serializer<PaymentResponse> get serializer => _$paymentResponseSerializer;

  PaymentResponse._();

  factory PaymentResponse([void Function(PaymentResponseBuilder) updates]) =
      _$PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<PaymentResponse>(serializer, json)!;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;
}