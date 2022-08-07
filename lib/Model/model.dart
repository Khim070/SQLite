class User {
  int id;
  String name;

  User({required this.id, required this.name});
  //we use toMap to convert object to Map
  //Map the same to hashtable(in java)
  // Map is similar to ArrayList
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  //we use fromMap to convert Map to object
  // res is the object of Map<String, dynamic>
  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"];
}
