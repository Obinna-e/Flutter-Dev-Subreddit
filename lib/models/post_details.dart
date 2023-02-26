class Post {
  String? title;
  int? likes;
  int? dislikes;
  int? score;
  String? author;
  String? description;
  int? commentCount;

  Post({
    required this.title,
    required this.likes,
    required this.dislikes,
    required this.author,
    required this.score,
    this.description,
    required this.commentCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        title: json["title"],
        likes: json["ups"],
        dislikes: json["downs"],
        score: json["score"],
        author: json["author"],
        description: json["selftext"] ?? '',
        commentCount: json["num_comments"],
      );
}
