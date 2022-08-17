class Post {
  String postId;
  String username;
  String description;
  String photoUrl;
  String datePublished;
  String postUrl;

  Post(
      {required this.postId,
      required this.postUrl,
      required this.username,
      required this.description,
      required this.photoUrl,
      required this.datePublished});
}
