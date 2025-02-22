class ChatModel {
  final String? dcoId;
  final String? roomId;
  final String? receiverId;
  final String? senderId;
  final String? message;
  final String? timestamp;
  final String? type;
  final String? url;
  final String? fileName;
  final String? fileExtension;
  final bool? isSeen;
  final int? linkCount;
  final List? userIdsOfUsersForStarredMessage;
  final List? userIdsOfUsersForDeletedMessage;
  final String? thumbnailUrl;
  final int? voiceDuration;
  final bool? isAchieved;

  ChatModel({
    this.dcoId,
    this.roomId,
    this.receiverId,
    this.senderId,
    this.message,
    this.timestamp,
    this.type,
    this.url,
    this.linkCount,
    this.fileName,
    this.fileExtension,
    this.isSeen,
    this.userIdsOfUsersForStarredMessage,
    this.userIdsOfUsersForDeletedMessage,
    this.thumbnailUrl,
    this.voiceDuration,
    this.isAchieved,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String docId) {
    return ChatModel(
      roomId: json["roomId"] ?? '',
      dcoId: docId,
      receiverId: json['receiverId'] ?? '',
      senderId: json['senderId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      type: json['type'] ?? '',
      linkCount: json['linkCount'] ?? 0,
      url: json['url'] ?? '',
      isSeen: json['isSeen'] ?? false,
      userIdsOfUsersForStarredMessage:
          json['userIdsOfUsersForStarredMessage'] ?? [],
      userIdsOfUsersForDeletedMessage:
          json['userIdsOfUsersForDeletedMessage'] ?? [],
      fileName: json['fileName'] ?? '',
      fileExtension: json['fileExtension'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      voiceDuration: json['voiceDuration'] ?? 60,
      isAchieved: json['isAchieved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (roomId != null) 'roomId': roomId,
      if (dcoId != null) 'roomId': dcoId,
      if (receiverId != null) 'receiverId': receiverId,
      if (senderId != null) 'senderId': senderId,
      if (message != null) 'message': message,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (fileName != null) 'fileName': fileName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      if (linkCount != null) 'linkCount': linkCount,
      if (isSeen != null) 'isSeen': isSeen,
      if (userIdsOfUsersForStarredMessage != null)
        'userIdsOfUsersForStarredMessage': userIdsOfUsersForStarredMessage,
      if (userIdsOfUsersForDeletedMessage != null)
        'userIdsOfUsersForDeletedMessage': userIdsOfUsersForDeletedMessage,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (voiceDuration != null) 'voiceDuration': voiceDuration,
      if (isAchieved != null) 'isAchieved': isAchieved,
    };
  }
}
