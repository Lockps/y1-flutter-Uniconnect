import 'package:location/location.dart';

class DataPost {
  String header;
  String essays;
  DateTime date;
  int iconint;
  Future<LocationData> currentLocationpost;
  int? like;

  DataPost(this.header, this.essays, this.date, this.iconint,
      this.currentLocationpost, this.like);

  get getHeader => this.header;

  set setHeader(header) => this.header = header;

  get getEssays => this.essays;

  set setEssays(essays) => this.essays = essays;

  get getDate => this.date;

  set setDate(date) => this.date = date;

  get getIconint => this.iconint;

  set setIconint(iconint) => this.iconint = iconint;

  get getCurrentLocationpost => this.currentLocationpost;

  set setCurrentLocationpost(currentLocationpost) =>
      this.currentLocationpost = currentLocationpost;
}

class DataList {
  List<DataPost> listdata = [];
}
