//likes
class Like{
  final int likes;
  final List<String> usernames;
  Like({
    required this.likes,
    required this.usernames
  });

  factory Like.fromJson(Map<String, dynamic> json){
    return Like(
        likes: json['likes'],
        usernames: (json['usernames'] as List).map((e) => e as String).toList()
    );
  }
}

//comments
class Comment {
  final String username;
  final String imageUrl;
  final String comment;

  Comment({
    required this.username,
    required this.imageUrl,
    required this.comment,
  });
  
  factory Comment.fromJson(Map<String, dynamic>json){
    return Comment(
        username: json['username'],
        imageUrl: json['imageUrl'],
        comment: json['comment']
    );
  }
}

//post
class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final String imageId;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.postId,
      required this.userId,
      required this.title,
      required this.detail,
      required this.imageUrl,
      required this.like, required this.imageId,
      required this.comments});
}
