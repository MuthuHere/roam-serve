class RequestModel {
  RequestData requestData;

  RequestModel({this.requestData});

  RequestModel.fromJson(Map<String, dynamic> json) {
    requestData = json['requestData'] != null
        ? new RequestData.fromJson(json['requestData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestData != null) {
      data['requestData'] = this.requestData.toJson();
    }
    return data;
  }
}

class RequestData {
  String imageUrl;
  String location;
  String category;
  String additionalInfo;
  String dateTime;

  RequestData(
      {this.imageUrl,
        this.location,
        this.category,
        this.additionalInfo,
        this.dateTime});

  RequestData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    location = json['location'];
    category = json['category'];
    additionalInfo = json['additionalInfo'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['location'] = this.location;
    data['category'] = this.category;
    data['additionalInfo'] = this.additionalInfo;
    data['dateTime'] = this.dateTime;
    return data;
  }
}