import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Models/university_list_model.dart';
import '/Providers/university_list_provider.dart';
import 'package:url_launcher/link.dart';

class MeritList extends StatefulWidget {
  final List<MeritResult>? meritResult;
  final int? uniIndex;
  final String? uniId;
  const MeritList({
    Key? key,
    this.meritResult,
    this.uniIndex,
    this.uniId,
  }) : super(key: key);

  @override
  State<MeritList> createState() => _MeritListState();
}

class _MeritListState extends State<MeritList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<UniversityListProvider>(context, listen: true)
        .getUniversityList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merit List"),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: widget.meritResult!.isNotEmpty
            ? ListView.builder(
                itemCount: widget.meritResult!.length,
                itemBuilder: (BuildContext context, int index) {
                  return MeritListTile(
                    id: widget.meritResult![index].id,
                    deptName: widget.meritResult![index].deptName,
                    lastMerit: widget.meritResult![index].lastMerit,
                    lastMeritUrl: widget.meritResult![index].lastMeritUrl,
                    entryTest: widget.meritResult![index].entryTest,
                    index: index,
                    uniIndex: widget.uniIndex,
                  );
                })
            : Center(
                child: Text("No Merit found"),
              ),
      ),
    );
  }
}

class MeritListTile extends StatelessWidget {
  final int? index;
  final int? uniIndex;
  final String? id;
  final String? deptName;
  final String? lastMerit;
  final String? lastMeritUrl;
  final String? entryTest;
  const MeritListTile({
    Key? key,
    this.index,
    this.id,
    this.deptName,
    this.lastMerit,
    this.lastMeritUrl,
    this.entryTest,
    this.uniIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(style: TextStyle(fontWeight: FontWeight.bold), deptName!),
              SizedBox(
                height: 5,
              ),
              Text(
                style: TextStyle(fontWeight: FontWeight.bold),
                entryTest! == "1" ? "Yes Entry Test" : "No Entry Test",
              ),
              Container(
                child: Link(
                  target: LinkTarget.blank,
                  uri: Uri.parse(lastMeritUrl!),
                  builder: (context, followLink) => GestureDetector(
                    onTap: followLink,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "For Merit List",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(lastMerit!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )),
            ],
          )
        ],
      ),
      Divider(
        color: Colors.grey,
      ),
    ]);
  }
}
