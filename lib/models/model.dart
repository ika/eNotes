class Model {
  int id;
  int time;
  String contents;

  Model({this.id, this.contents, this.time});

  // Create a Note from JSON data
  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        time: json["time"],
        contents: json["contents"],
      );

  // Convert our Note to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "contents": contents,
      };
}
