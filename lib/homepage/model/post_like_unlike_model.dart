class PostLikeUnlikeModel {
  List<User>? user;
  bool? error;
  String? statusCode;
  String? message;

  PostLikeUnlikeModel({this.user, this.error, this.statusCode, this.message});

  PostLikeUnlikeModel.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
    error = json['error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class User {
  String? id;
  String? likes;
  String? likeStatus;

  User({this.id, this.likes, this.likeStatus});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    likes = json['likes'];
    likeStatus = json['likeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['likes'] = this.likes;
    data['likeStatus'] = this.likeStatus;
    return data;
  }
}
