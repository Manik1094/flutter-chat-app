class User {
  String name;
  String status;
  String uid;
  String profilePhoto;

  User({this.name, this.status, this.uid, this.profilePhoto});

  String get _name => name;

  String get _status => status;

  String get _uid => uid;

  String get _profilePhoto => profilePhoto;

  set _name(String name) {
    this.name = name;
  }

  set _status(String status) {
    this.status = status;
  }

  set _uid(String uid) {
    this.uid = uid;
  }

  set _profilePhoto(String profilePhoto) {
    this.profilePhoto = profilePhoto;
  }

  Map toMap() {
    var data = Map<String, String>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['uid'] = this.uid;
    data['profilePhoto'] = this.profilePhoto;

    return data;
  }

  User fromMap(Map<String, String> mMap) {
    var data = User();
    data.name = mMap['name'];
    data.status = mMap['status'];
    data.uid = mMap['uid'];
    data.profilePhoto = mMap['profilePhoto'];
    return data;
  }
}
