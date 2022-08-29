import 'package:flutter/material.dart';
import 'package:enamconnect/campus/etudiant/classPackge/News.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class NewsDetailPage extends StatefulWidget {
  final New newdetail;
  const NewsDetailPage(this.newdetail);
  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {

  String sub;
  @override
  void initState() {
    sub=widget.newdetail.content.replaceAll('/uploads/Image', 'https://lgi.iav.ac.ma/uploads/Image');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: Text(widget.newdetail.title),),
        body:  ListView(
          children: <Widget>[
            HtmlWidget(sub),
          ],
        )
    );
  }
}
