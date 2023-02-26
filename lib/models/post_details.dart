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
        title: json["title"] as String,
        likes: json["ups"] as int,
        dislikes: json["downs"] as int,
        score: json["score"] as int,
        author: json["author"] as String,
        description: json["selftext"] as String,
        commentCount: json["num_comments"] ?? 0,
      );
}
