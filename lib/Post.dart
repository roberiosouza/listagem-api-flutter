class Post {
  int? id;
  int userId;
  String title;
  String body;

  Post(this.userId, this.title, this.body, {this.id});

  Map toJson() {
    return {
      "title": this.title,
      "body": this.body,
      "userId": this.userId,
    };
  }
}
