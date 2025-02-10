class postRewardCoinModel {
  bool? error;
  String? statusCode;
  String? message;

  postRewardCoinModel({this.error, this.statusCode, this.message});

  postRewardCoinModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
