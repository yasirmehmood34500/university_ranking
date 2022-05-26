import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../Models/university_list_model.dart';
import 'package:http/http.dart' as http;
import '../base_url.dart';

class UniversityListProvider extends ChangeNotifier {
  bool isLoadingUniversityListProvider = true;
  UniversityListModel _universityListModel = UniversityListModel();
  List<Result>? list;
  UniversityListProvider() {
    _universityListModel.result = list;
  }

  setUniversityData(UniversityListModel? data) {
    _universityListModel = data!;
    isLoadingUniversityListProvider = false;
    notifyListeners();
  }

  List<Result>? getUniversityList() {
    return _universityListModel.result;
  }

  Future<UniversityListModel> fetchUniversityListApi() async {
    var url = Uri.https(BaseUrl.apiBaseUrl,
        '${BaseUrl.apiBaseUrlSecond}university_list.php', {});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      UniversityListModel universityListModel =
          UniversityListModel.fromJson(parsed);
      return universityListModel;
    } else {
      return _universityListModel;
    }
  }
}
