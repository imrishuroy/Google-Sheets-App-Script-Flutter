class FeedBackModel {
  String name;
  String profilePic;
  String feedback;
  String source;

  FeedBackModel({
    this.name,
    this.profilePic,
    this.feedback,
    this.source,
  });

  factory FeedBackModel.fromJson(dynamic json) {
    return FeedBackModel(
      name: '${json['name']}',
      profilePic: '${json['image_url']}',
      feedback: '${json['feedback']}',
      source: '${json['source']}',
    );
  }

  Map toJson() => {
        'image_url': profilePic,
        'name': name,
        'feedback': feedback,
        'source': source,
      };
}
