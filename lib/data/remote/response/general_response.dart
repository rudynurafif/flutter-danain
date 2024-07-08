class GeneralResponse {
  final dynamic status;
  final String message;
  final dynamic data;

  GeneralResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
      status: json['status'] ?? json['responseStatus'] ?? json['Response']['status'],
      message: json['message'] ??
          json['responseMessage'] ??
          json['Response']['message'] ??
          json['message'] ??
          '',
      data: json['data'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
