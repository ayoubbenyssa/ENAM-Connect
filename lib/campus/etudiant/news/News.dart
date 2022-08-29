import 'dart:math';

import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:enamconnect/campus/etudiant/classPackge/News.dart';
import 'package:enamconnect/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:enamconnect/services/Fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:convert';
import './NewsDetail.dart';

class NewsPage extends StatefulWidget {
  final int _userId;
  final int _studentId;
  final int _token;

  NewsPage(this._userId, this._studentId, this._token);
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  ListNews news;
  var data;
  String sub;
  bool loading = true;
  String message = "";

  final Random _random = Random();


  Future<http.Response> getNews(int user_id, int student_id, int token) async {
    final param = {
      "user_id": "$user_id",
      "student_id": "$student_id",
      "auth_token": "$token",
    };

    final absenceData = await http.post(
      "${Config.url_api_scole}/news",
      body: param,
    );
    setState(() {
      data = json.decode(absenceData.body);
      news = new ListNews.fromJson(data["student"]);
      loading = false;
    });
    return absenceData;
  }

  Widget _buildNewsItem(BuildContext context, int index) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border(
              left: BorderSide(
                  width: 6.0,
                  color: Color.fromARGB(
                    //or with fromRGBO with fourth arg as _random.nextDouble(),
                    _random.nextInt(266),
                    _random.nextInt(266),
                    _random.nextInt(266),
                    _random.nextInt(266),
                  ).withOpacity(0.9)),
            ),
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 16.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.black12))),
              child: Icon(Icons.account_circle,size: 50,)
            ),
            title: Text(
              news.newToos[index].newToo.title,
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Détail...",
              style: TextStyle(
                  color: Fonts.col_app,
                  decoration: TextDecoration.underline),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                  //  padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                        "Crée le : ${_formatDate(news.newToos[index].newToo.created_at)}"),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(news.newToos[index].newToo)));
            },
          ),
        ));
  }

  Widget _buildNewsList() {
    Widget moduleItems;
    if (news.newToos.length > 0) {
      moduleItems = ListView.builder(
        itemBuilder: _buildNewsItem,
        itemCount: news.newToos.length,
      );
    } else {
      moduleItems = Container();
    }
    return moduleItems;
  }
  Widget  boton_appbar(){
    PreferredSize(preferredSize : Size.fromHeight(0.h));
  }

  @override
  void initState() {
    getNews(widget._userId, widget._studentId, widget._token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize : Size.fromHeight(128.h),
            child: ApBar("assets/images/app1.svg" ,"images/nes.png", "News",boton_appbar())),
      // appBar: AppBar(
      //   title: Text("News",style:
      //   TextStyle(color: Colors.white),),
      //   iconTheme: IconThemeData(color: Colors.white),
      //
      // ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _buildNewsList(),
                  )
                ],
              ));
  }

  String _formatDate(String date) {
    String day = DateTime.parse(date).day.toString();
    String month = DateTime.parse(date).month.toString();
    String year = DateTime.parse(date).year.toString();
    String m = int.parse(month) < 10 ? "0$month" : "$month";

    return "$day/$m/$year";
  }
}
/*Image.asset(
                "assets/images/newspaper.png",
                height: 35.0,
                width: 35.0,
              ),*/