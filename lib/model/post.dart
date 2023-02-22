//likes
class Like {
  final int likes;
  final List<String> users;

  Like({required this.likes, required this.users});
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
}

//post
class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.postId,
      required this.userId,
      required this.title,
      required this.detail,
      required this.imageUrl,
      required this.like,
      required this.comments});
}
