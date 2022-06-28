import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Components/my_drawer_app.dart';
import '/Models/university_list_model.dart';
import '/Providers/university_list_provider.dart';
import 'package:url_launcher/link.dart';
import 'merit_list.dart';

class UniList extends StatefulWidget {
  const UniList({Key? key}) : super(key: key);

  @override
  State<UniList> createState() => _UniListState();
}

class _UniListState extends State<UniList> {
  TextEditingController _searchTextController = TextEditingController();
  bool dataLoad = false;

  List<Result>? universityList = [];

  fetchUniversity() async {
    var universityListProvider =
        Provider.of<UniversityListProvider>(context, listen: false);
    if (universityListProvider.isLoadingUniversityListProvider == true) {
      UniversityListModel data =
          await universityListProvider.fetchUniversityListApi();
      universityListProvider.setUniversityData(data);
      setState(() {
        dataLoad = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    fetchUniversity();
    super.didChangeDependencies();
  }

  void _searchJob(String val) {
    List<Result>? results = [];
    if (val.isEmpty) {
      results = Provider.of<UniversityListProvider>(context, listen: false)
          .getUniversityList();
    } else {
      results = Provider.of<UniversityListProvider>(context, listen: false)
          .getUniversityList()!
          .where((element) =>
              element.name!.toLowerCase().contains(val.toLowerCase()))
          .toList();
    }
    setState(() {
      universityList = results;
    });
  }

  bool _searchField = false;
  void _searchFiledFun() {
    setState(() {
      _searchField = !_searchField;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchTextController.text.isEmpty) {
      setState(() {
        universityList =
            Provider.of<UniversityListProvider>(context, listen: true)
                .getUniversityList();
      });
    }
    bool isHave = Provider.of<UniversityListProvider>(context, listen: false)
        .isLoadingUniversityListProvider;
    return Scaffold(
      appBar: AppBar(title: const Text("All University"), actions: [
        GestureDetector(
          onTap: _searchFiledFun,
          child: Container(
            padding: EdgeInsets.only(right: 5),
            child: _searchField ? Icon(Icons.close) : Icon(Icons.search),
          ),
        )
      ]),
      drawer: MyDrawerApp(),
      body: universityList == null || isHave == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _searchField
                    ? Form(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blueGrey,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                              hintText: 'Search University',
                              labelText: 'Search',
                            ),
                            onChanged: (value) {
                              _searchJob(value);
                              setState(() {
                                _searchTextController.text = value;
                              });
                            },
                          ),
                        ),
                      )
                    : Text(""),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: universityList!.isNotEmpty
                        ? ListView.builder(
                            itemCount: universityList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return UniversityListTile(
                                id: universityList![index].id,
                                name: universityList![index].name,
                                ranking: universityList![index].ranking,
                                registerLink:
                                    universityList![index].registerLink,
                                requirementLink:
                                    universityList![index].requirementLink,
                                index: index,
                                meritResult: universityList![index].meritResult,
                                worldRanking:
                                    universityList![index].worldRanking,
                              );
                            })
                        : Center(
                            child: Text("No University found"),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}

class UniversityListTile extends StatelessWidget {
  final int? index;
  final String? id;
  final String? name;
  final String? ranking;
  final String? worldRanking;
  final String? registerLink;
  final String? requirementLink;
  final List<MeritResult>? meritResult;
  const UniversityListTile({
    Key? key,
    this.id,
    this.name,
    this.ranking,
    this.worldRanking,
    this.registerLink,
    this.requirementLink,
    this.index,
    this.meritResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
              name!,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Link(
                target: LinkTarget.blank,
                uri: Uri.parse(registerLink!),
                builder: (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "For Registration",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Link(
                target: LinkTarget.blank,
                uri: Uri.parse(requirementLink!),
                builder: (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "For Requirement",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("No ${ranking!} in Pakistan",
                    style: TextStyle(
                      fontSize: 12.0,
                    )),
              ],
            ),
            Column(
              children: [
                Text("No ${worldRanking!} in World",
                    style: TextStyle(
                      fontSize: 12.0,
                    )),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MeritList(
                        uniIndex: index,
                        uniId: id,
                        meritResult: meritResult,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Merit List",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
