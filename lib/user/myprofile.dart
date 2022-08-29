import 'dart:async';
import 'dart:io';

//import 'package:card_settings/card_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/user/formations.dart';
import 'package:enamconnect/user/laureat/Formmule.dart';
import 'package:enamconnect/user/textf_widget.dart';
import 'package:enamconnect/widgets/custom_widgets/app_textfield.dart';
import 'package:enamconnect/widgets/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:enamconnect/communities/communities.dart';
import 'package:enamconnect/models/community.dart';
import 'package:enamconnect/user/phonewidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enamconnect/func/parsefunc.dart';
import 'package:enamconnect/models/user.dart';
import 'package:photo_view/photo_view.dart';
import 'package:enamconnect/pages/conditions.dart';
import 'package:enamconnect/pages/politique.dart';
import 'package:enamconnect/services/Fonts.dart';
import 'package:enamconnect/user/bio.dart';
import 'package:enamconnect/user/competences.dart';
import 'package:enamconnect/user/link_profile.dart';
import 'package:enamconnect/user/name_info_user.dart';
import 'package:enamconnect/user/objectifs.dart';
import 'package:enamconnect/user/organisme_title.dart';
import 'package:enamconnect/widgets/arc_clip.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';



enum AppBarBehavior { normal, pinned, floating, snapping }

class MyProfile extends StatefulWidget {
  MyProfile(this.user, this.show, this.show_myprofile, this.lat, this.lng,
      this.list_partners, this.analytics);

  User user;
  bool show = true;
  var lat;
  var lng;
  bool show_myprofile = true;
  var list_partners;
  var analytics;

  @override
  _Details_userState createState() => _Details_userState();
}

class _Details_userState extends State<MyProfile>
    with TickerProviderStateMixin {
  AnimationController _containerController;
  bool uploading = false;
  TextEditingController birthDateCtrl = TextEditingController();

  double _appBarHeight = 0.0.h;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  Animation<double> width;
  Animation<double> heigth;
  Distance distance = new Distance();
  ParseServer parse_s = new ParseServer();
  bool val1 = true;
  String type = "";
  bool val2 = false;
  bool val = true;
  bool competences = false;
  bool adresses = false;
  bool contact = false;
  bool emploi = false;
  bool genre = false ;
  bool date_ness = false;
  bool formation = false;
  bool social_media = false ;
  bool Curriculum = false;
  final _adrCtrl = new TextEditingController();
  FocusNode _adrfcous = new FocusNode();

  final _adraCtrl = new TextEditingController();
  FocusNode _adrafcous = new FocusNode();

  final _adrpCtrl = new TextEditingController();
  FocusNode _adrpFocus = new FocusNode();

  final _phoneCtrl = new TextEditingController();
  FocusNode _phonefocus = new FocusNode();

  final _emailCtrl = new TextEditingController();
  FocusNode _emailfocus = new FocusNode();

  String selected_secteur = 'Public';
  String selected_domain = 'Agricol';
  int id = 1;
  int id_domaine = 1;

  List<NumberList> secteur = [
    NumberList(
      index: 1,
      number: "Public",
    ),
    NumberList(
      index: 2,
      number: "Privé",
    ),
  ];
  List<NumberList> demaine = [
    NumberList(
      index: 1,
      number: "Agricol",
    ),
    NumberList(
      index: 2,
      number: "Non_Agricol",
    ),
  ];

  update() async {
    Map<String, dynamic> mapp = User.toMap(widget.user);
    print(mapp);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", mapp.toString());
  }

  save_image(image) async {
    setState(() {
      uploading = true;
    });

    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("profile/img_" + timestamp.toString() + ".jpg");
    await storageReference.put(image).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        var js = {
          "photoUrl": val.toString(),
        };

        parse_s.putparse("users/" + widget.user.id, js);

        if (!mounted) return;

        setState(() {
          widget.user.image = val.toString();
          update();
          uploading = false;
        });
      });
    });
  }

  make_user_online() async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["online"] = true;
    map["offline"] = "";

    map["last_active"] = 0;
    await Firestore.instance
        .collection('users')
        .document(widget.user.auth_id)
        .updateData(map);

    FirebaseDatabase.instance
        .reference()
        .child("status")
        .update({widget.user.auth_id: true});
    FirebaseDatabase.instance
        .reference()
        .child("status")
        .onDisconnect()
        .update({widget.user.auth_id: false});
  }

  getOnlineUser() async {
    DocumentSnapshot a = await Firestore.instance
        .collection('users')
        .document(widget.user.auth_id)
        .get();

    if (!this.mounted) return;
    print(
        "yess----------------------------------------------------------------------------------");
    print(a.data);
    if (a.data["offline"].toString() == "offline") {
      setState(() {
        widget.user.online = false;
        widget.user.offline = "offline";
        val = false;
      });
    } else
      setState(() {
        val = true;
      });
  }

  Future _cropImage(image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    if (croppedFile != null) {
      image = croppedFile;
      //ImageProperties properties = await FlutterNativeImage.getImageProperties(image.path);
      File compressedFile =
      await FlutterNativeImage.compressImage(image.path, quality: 70);
      save_image(compressedFile);
    }
  }

//        prefs.setString("user", json.encode(res["results"][0]));

  getUserInfo() async {
    var response = await parse_s.getparse(
        'users?where={"objectId":"${widget.user.id}"}&include=user_formations,role');
    if (!this.mounted) return;
    setState(() {
      widget.user = new User.fromMap(response["results"][0]);
      print("---------------------------------------------");
      print(widget.user.sexe);
      if (widget.user.sexe == "Femme") {
        type = "Femme";
        val1 = false;
        val2 = true;
      } else {
        type = "Homme";
        val1 = true;
        val2 = false;
      }

      if (widget.user.role.id == "twAD2BVIbK") {
        print(widget.user.actual_address);
        _adrCtrl.text = widget.user.address;
        _adraCtrl.text = widget.user.actual_address;
        _adrpCtrl.text = widget.user.permanent_address;
        birthDateCtrl.text = widget.user.birthday;
        _phoneCtrl.text = widget.user.phone;
        _emailCtrl.text = widget.user.email_pro;

        selected_secteur = widget.user.secteur;
        if (selected_secteur == "Privé") {
          id = 2;
        } else {
          id = 1;
        }
        selected_domain = widget.user.domain;

        if (selected_domain == "Non Agricol") {
          id_domaine = 2;
        } else {
          id_domaine = 1;
        }
      }
      if (widget.show == false) {
        widget.user.online = false;
        getOnlineUser();
        widget.user.list = [];
        widget.user.list_obj = [];

        if (widget.user.objectif != null) {
          for (var i in widget.user.objectif) {
            setState(() {
              widget.user.list_obj.add(i);
            });
          }
        }

        if (widget.user.cmpetences != null) {
          for (var i in widget.user.cmpetences) {
            widget.user.list.add(i);
          }
        }
      }
    });
  }

  @override
  void initState() {
    getUserInfo();
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 160.0,
      end: 160.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 160.0,
      end: 160.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  _handleCameraButtonPressed() async {
    Navigator.of(context).pop(true);
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(image);
  }

  _handleGalleryButtonPressed() async {
    Navigator.of(context).pop(true);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(image);
  }

  open_bottomsheet() {
    showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 112.0,
              child: new Container(
                // padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new ListTile(
                            onTap: _handleCameraButtonPressed,
                            title: new Text("Prendre une photo")),
                        new ListTile(
                            onTap: _handleGalleryButtonPressed,
                            title: new Text("Photo depuis la gallerie")),
                      ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    /*Widget gsm = Widgets.textfield0(
      "GSM",
      _focusphone,
      user.phone,
      _phonecontroller,
      TextInputType.phone,
    );*/

    // var divider = new Container(
    //   color: Colors.grey[300],
    //   width: 10000.0,
    //   height: 1.0,
    // );

    Widget a(text) => new Container(
      padding: new EdgeInsets.all(6.0),
      //  width: 150.0,
      //alignment: Alignment.center,
      decoration: new BoxDecoration(
        border: new Border.all(color: Fonts.col_app, width: 1.0),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: new Text(
        "#" + text,
        style: new TextStyle(color: Fonts.col_app),
      ),
    );

    edit_name() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new InfoUser1(widget.user);
          }));

      setState(() {
        widget.user = us;
      });
    }

    edit_titre() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new OrganismeTitle(widget.user);
          }));

      setState(() {
        widget.user = us;
      });
    }

    edit_comp() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Cmpetences(widget.user);
          }));

      setState(() {
        widget.user = us;
      });
    }

    Community community;

    edit_community() async {
      /* User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Communities(
          null,
          null,
          widget.list_partners,
          true,
          widget.user.id,
        );
      }));

      print(us.community);

      setState(() {
        widget.user = us;
      });*/

      if (community.toString() != "null") {
        setState(() {
          widget.user.community = community.name;
          widget.user.communitykey = community.id;
        });
      }
    }

    edit_link(type) async {
      //
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Link_profile(widget.user, type);
          }));

      setState(() {
        widget.user = us;
      });
    }

    make_user_offline() async {
      Map<String, dynamic> map = new Map<String, dynamic>();
      map["online"] = false;
      map["last_active"] = new DateTime.now().millisecondsSinceEpoch;
      map["offline"] = "offline";

      Firestore.instance
          .collection('users')
          .document(widget.user.auth_id)
          .updateData(map);

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({widget.user.auth_id: false});

      FirebaseDatabase.instance
          .reference()
          .child("status")
          .update({widget.user.auth_id: false});
    }

    edit_formation() async {
      User us = await Navigator.push(
        context,
        new PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> _,
              Animation<double> __) {
            return new Formations(widget.user);
          },
        ),
      );

      setState(() {
        widget.user = us;
      });
    }

    save_niveau(va) {
      var js = {
        "niveau": va,
      };

      parse_s.putparse("users/" + widget.user.id, js);
    }

    edit_bio() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new Bio(widget.user);
          }));

      setState(() {
        widget.user = us;
      });
    }

    edit_num() async {
      User us = await Navigator.push(context,
          new MaterialPageRoute(builder: (BuildContext context) {
            return new PhoneWidget(widget.user);
          }));

      setState(() {
        widget.user = us;
      });
    }

    edit_phone() {}

    editwidget(colors, tap) {
      return new InkWell(
          child: new Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: new Icon(
                Icons.edit,
                color: colors,
              )),
          onTap: () {
            tap();
          });
    }

    Widget phone_widget = new Row(
      children: <Widget>[
        new Text("Numéro de téléphone:"),
        new Expanded(child: new Container()),
        editwidget(Fonts.col_app, edit_phone)
      ],
    );

    Widget page = new Container(

      width: width.value,
      height: heigth.value,
      color: Colors.grey[50],
      child: Container(
          color: Colors.white,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight : Radius.circular(39.r)),
              child: Container(
                  color: Colors.white,
                  child: new Container(
                    color: Colors.transparent,
                    child: new Container(
                      //alignment: Alignment.center,
                      width: width.value,
                      height: heigth.value,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        // borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          new CustomScrollView(
                            shrinkWrap: false,
                            slivers: <Widget>[
                              // new SliverAppBar(
                              //   backgroundColor: Colors.transparent,
                              //   automaticallyImplyLeading: false,
                              //   elevation: 0.0,
                              //   forceElevated: true,
                              //   expandedHeight: _appBarHeight,
                              //   pinned:
                              //   _appBarBehavior == AppBarBehavior.pinned,
                              //   floating: _appBarBehavior ==
                              //       AppBarBehavior.floating ||
                              //       _appBarBehavior == AppBarBehavior.snapping,
                              //   snap:
                              //   _appBarBehavior == AppBarBehavior.snapping,
                              //   flexibleSpace: new FlexibleSpaceBar(
                              //     title: new Text(""),
                              //     background: ClipPath(
                              //         clipper: new ArcClipper2(),
                              //         child: new Stack(
                              //           fit: StackFit.expand,
                              //           children: <Widget>[
                              //             new Container(
                              //               width: width.value,
                              //               height: _appBarHeight,
                              //               /* decoration: new BoxDecoration(
                              //     image: new DecorationImage(
                              //       image: new NetworkImage(widget.user.image),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),*/
                              //               // child: new Container(
                              //                 /* decoration: new BoxDecoration(
                              //         color: Colors.grey[800],
                              //         image: new DecorationImage(
                              //           fit: BoxFit.cover,
                              //           colorFilter: new ColorFilter.mode(
                              //               Colors.black.withOpacity(0.3),
                              //               BlendMode.dstATop),
                              //           image: new NetworkImage(
                              //             widget.user.image,
                              //           ),
                              //         ),
                              //       ),*/
                              //                   // child: new Column(children: <
                              //                   //     Widget>[
                              //                   //   new Row(
                              //                   //     children: <Widget>[
                              //                   //       new Expanded(
                              //                   //           child: new Container()
                              //                   //       ),
                              //                   //     ],
                              //                   //   ),
                              //                     // new Container(
                              //                     //   height: 4.0,
                              //                     // ),
                              //                     /*new GestureDetector(
                              //         onTap: (){
                              //           Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                 builder: (context) => FullScreenWrapper(
                              //                   imageProvider: NetworkImage(widget.user.image),
                              //                 ),
                              //               )
                              //           );
                              //         },
                              //         child:*/ /*new Hero(
                              //           tag: widget.user.id,
                              //           child: */
                              //                     // Container(
                              //                     //   height: 20.h,
                              //                     // ),
                              //                     // new Container(
                              //                     //   height: 16.0.h,
                              //                     // ),
                              //
                              //                     // new Container(
                              //                     //   height: 2.0.h,
                              //                     // ),
                              //
                              //                     // Container(
                              //                     //   // color: Colors.red,
                              //                     //   child: new Row(
                              //                     //       mainAxisAlignment:
                              //                     //       MainAxisAlignment.center,
                              //                     //       children: <Widget>[
                              //                     //         // new Container(width: 28.0),
                              //                     //         new Expanded(
                              //                     //             child: new Center(
                              //                     //                 child: Container(
                              //                     //                   width: MediaQuery.of(context).size.width * 0.7,
                              //                     //                   child: new Text(
                              //                     //                     // widget.user.age.toString() !=
                              //                     //                     //     ""
                              //                     //                     //     ?
                              //                     //                     // widget.user.fullname.toString() + " " + widget.user.firstname.toString() + ", " + widget.user.age.toString() + " ans"
                              //                     //                     //     :
                              //                     //
                              //                     //
                              //                     //                     widget.user.school.toString() != null ? widget.user.school.toString() : "a"
                              //                     //                         + " " +
                              //                     //                         widget.user.course.toString() != null ? widget.user.course.toString() : "b"
                              //                     //                         + " " +
                              //                     //                         widget.user.school_field.toString() != null ? widget.user.school_field.toString() : "c"
                              //                     //                         +"  " +
                              //                     //                         widget.user.niveau.toString() != null ? widget.user.niveau.toString() : "d",
                              //                     //                    maxLines: 2,
                              //                     //                     // textAlign: Alignmenzt.center,
                              //                     //                     style: new TextStyle(
                              //                     //
                              //                     //                         color: Fonts.col_app_grey,
                              //                     //                         fontSize: 13.0.sp,
                              //                     //                         fontWeight:
                              //                     //                         FontWeight.w500),
                              //                     //                   ),
                              //                     //                 ))),
                              //                     //         // editwidget(Colors.white, edit_name),
                              //                     //       ]),
                              //                     // ),
                              //                     // new Container(
                              //                     //   height: 6.0.h,
                              //                     // ),
                              //                     /*new Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             children: <Widget>[
                              //               new Container(width: 28.0),
                              //               new Expanded(
                              //                   child: new Container(
                              //                       padding: EdgeInsets.only(
                              //                           left: 8, right: 8),
                              //                       width: MediaQuery.of(context)
                              //                               .size
                              //                               .width *
                              //                           0.9,
                              //                       child: new Text(
                              //                           widget.user.organisme == ""
                              //                               ? widget.user.titre
                              //                               : widget.user.titre
                              //                                       .toString() +
                              //                                   " à " +
                              //                                   widget.user
                              //                                       .organisme,
                              //                           style: new TextStyle(
                              //                               color: Colors
                              //                                   .grey[400],
                              //                               fontSize: 16.0,
                              //                               fontWeight:
                              //                                   FontWeight.w500),
                              //                           textAlign: TextAlign.center))),
                              //               editwidget(
                              //                   Colors.white, edit_titre),
                              //             ]),*/
                              //                     // new Container(
                              //                     //   height: 10.0.h,
                              //                     // ),
                              //
                              //                     // new Container(width: 12.0),
                              //
                              //                     /*editwidget(
                              //                   Colors.white, edit_community),*/
                              //                     // Container(width: 4,)
                              //                   // ])
                              //               // ),
                              //             ),
                              //           ],
                              //         )),
                              //   ),
                              // ),
                              new SliverList(
                                delegate: new SliverChildListDelegate(<Widget>[
                                  new Container(height: 100.0),
                                  // new Container(
                                  //   height: 14.0,
                                  // ),
                                  new Container(
                                    // color: Colors.red,
                                      margin: EdgeInsets.only(top: 20.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Container(
                                          //   height: 20.h,
                                          // ),
                                          SizedBox(width: 20.w,),
                                          new Stack(children: [
                                            new Center(
                                                child: new Container(
                                                  // color : Colors.green,
                                                  margin: EdgeInsets.only(
                                                      top: 13.h,left: 20.w,right: 20.w
                                                  ),
                                                  height: 104.h,
                                                  width: 104.w,
                                                  child: Image(
                                                      image: NetworkImage(
                                                          widget.user.image)),
                                                  // child : NetworkImage(widget.user.image),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(22.r)),
                                                    // color: Color(0xffD4D4D6),
                                                    // color : Colors.green,
                                                    shape: BoxShape.rectangle,
                                                    // color : Colors.green,
                                                    // image: DecorationImage(image: NetworkImage(widget.user.image)),
                                                    border: Border.all(
                                                        color: Fonts.col_app,
                                                        width: 1.w),
                                                    // borderRadius: BorderRadius.all(Radius.circular(39.r))
                                                  ),
                                                )),
                                            // new Positioned(
                                            //     bottom: 90.0,
                                            //     //bottom: 8.0,
                                            //     left: 46.0,
                                            //     right: -8.0,
                                            //     child: new
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 105.w,
                                                    bottom: 30.h),
                                                height: 28.h,
                                                width: 28.w,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffD4D4D6),

                                                    // color: Colors.green,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                                                    border: Border.all(color: Fonts.col_app , width: 1)
                                                  // borderRadius: BorderRadius.all(Radius.circular(12.r)),
                                                  // border: Border.all(color: Fonts.col_app,width: 1.w),
                                                ),
                                                child: new IconButton(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(bottom: 5.h),
                                                    color: Fonts.col_app,
                                                    icon: new Icon(
                                                      Icons.edit,
                                                      color: Fonts.col_app,
                                                    ),
                                                    onPressed: () {
                                                      open_bottomsheet();
                                                    })
                                            )
                                            // )
                                            ,
                                            uploading
                                                ? new Positioned(
                                                top: 10.0.h,
                                                //bottom: 8.0,
                                                left: 8.0.w,
                                                right: 8.0.w,
                                                child: new Center(
                                                    child: new CircularProgressIndicator(
                                                      // backgroundColor: Colors.grey,
                                                      //value: 16.0,
                                                    )))
                                                : new Container()
                                          ]),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Container(
                                                height: 10.h,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 180.w,
                                                    child: new Text(
                                                      widget.user.age
                                                          .toString() !=
                                                          ""
                                                          ? widget
                                                          .user.fullname
                                                          .toString() +
                                                          " " +
                                                          widget.user
                                                              .firstname
                                                              .toString() +
                                                          ", " +
                                                          widget.user.age
                                                              .toString() +
                                                          " ans"
                                                          : widget.user.fullname
                                                          .toString() +
                                                          " " +
                                                          widget.user
                                                              .firstname
                                                              .toString(),
                                                      style: new TextStyle(
                                                          color: Fonts.col_app,
                                                          fontSize: 18.0.sp,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(width: 30.w ,color: Colors.blue,)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ),


                                  new Container(height: 20.0.h),

                                  new Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 25.w),
                                      decoration: BoxDecoration(
                                          color: Fonts.colors_container,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.r))),
                                      child: Column(
                                        children: [
                                          Container(
                                            // color: Colors.grey[100],
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  new Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[

                                                      new Row(children: <Widget>[
                                                        SizedBox(
                                                          width: 27.w,
                                                        ),
                                                        new Container(
                                                            child: new Text(
                                                              "SEXE :",
                                                              style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                                            )),
                                                        new Container(width: 12.0),
                                                        new Text("$type".toString(),
                                                            style: new TextStyle(
                                                                fontSize: 12.0.sp,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                color: Fonts.col_app_grey
                                                            )
                                                        ),
                                                      ]),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment
                                                        .centerRight,
                                                    child: IconButton(
                                                      icon: Icon(!genre
                                                          ? Icons
                                                          .arrow_drop_down
                                                          : Icons.arrow_drop_up, color: Fonts.col_app_grey,size: 30.r,),
                                                      onPressed: () {
                                                        setState(() {
                                                          print(genre);
                                                          genre =
                                                          genre
                                                              ? false
                                                              : true;
                                                          print(genre);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )),

                                          genre ?   new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Text("Homme".toString()),
                                              new Checkbox(
                                                value: val1,
                                                activeColor:
                                                Fonts.col_app_fon,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    val1 = value;
                                                    val2 = !value;
                                                    type = "Homme";
                                                  });
                                                },
                                              ),
                                              new Container(width: 16.0.w),
                                              new Text("Femme".toString()),
                                              new Checkbox(
                                                value: val2,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    val2 = value;
                                                    val1 = !value;
                                                    type = "Femme";
                                                  });
                                                },
                                              )
                                            ],
                                          ) : Container(),
                                        ],
                                      )),
                                  // twAD2BVIbK
                                  widget.user.role.id == "twAD2BVIbK"
                                      ? Column(children: [
                                    Container(
                                      height: 12.h,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 25.w),
                                      // padding: EdgeInsets.symmetric(vertical: 3.h),
                                      decoration: BoxDecoration(
                                          color: Fonts.colors_container,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.r))),
                                      child: Column(
                                        children: [

                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 27.w,
                                                    ),
                                                    new Container(
                                                        child: new Text(
                                                          "ADRESSES",
                                                          style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                                        )),
                                                  ],
                                                ),
                                                Container(
                                                  alignment: Alignment
                                                      .centerRight,
                                                  child: IconButton(
                                                    icon: Icon(!adresses
                                                        ? Icons
                                                        .arrow_drop_down
                                                        : Icons
                                                        .arrow_drop_up , color: Fonts.col_app_grey,size: 30,),
                                                    onPressed: () {
                                                      setState(() {
                                                        print(adresses);
                                                        adresses =
                                                        adresses
                                                            ? false
                                                            : true;
                                                        print(adresses);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          adresses
                                              ? Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 7.w),

                                                  child: TextFieldWidget(
                                                    "Adresse actuelle :",
                                                    _adrafcous,
                                                    _adraCtrl,
                                                    TextInputType
                                                        .text,
                                                    // widget.user.bio,
                                                    null,
                                                    suffixIcon: "",
                                                  ),
                                                ),
                                                // Widgets.textfield0_dec(
                                                //   "Adresse actuelle :",
                                                //   _adrafcous,
                                                //   widget.user.bio,
                                                //   _adraCtrl,
                                                //   TextInputType.text,
                                                // ),
                                                Container(
                                                  height: 12,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 7.w),

                                                  child: TextFieldWidget(
                                                    "Adresse permanente :",
                                                    _adrpFocus,
                                                    _adrpCtrl,
                                                    TextInputType
                                                        .text,
                                                    null,
                                                    suffixIcon: "",
                                                  ),
                                                ),
                                                // Widgets.textfield0_dec(
                                                //   "Adresse permanente :",
                                                //   _adrpFocus,
                                                //   widget.user.bio,
                                                //   _adrpCtrl,
                                                //   TextInputType.text,
                                                // ),
                                                Container(
                                                  height: 12.h,
                                                ),
                                              ],
                                            ),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),

                                    // divider,

                                    //CONTACTS
                                    Column(
                                      children: [
                                        Container(
                                          height: 12.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          // padding: EdgeInsets.symmetric(vertical: 3.h),
                                          decoration: BoxDecoration(
                                              color: Fonts.colors_container,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.r))),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 27.w,
                                                        ),
                                                        new Container(
                                                            child: new Text(
                                                              "CONTACTS",
                                                              style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),
                                                            )),
                                                      ],
                                                    ),
                                                    Container(
                                                      alignment: Alignment
                                                          .centerRight,
                                                      child: IconButton(
                                                        icon: Icon(!contact
                                                            ? Icons
                                                            .arrow_drop_down
                                                            : Icons
                                                            .arrow_drop_up , color: Fonts.col_app_grey,size: 30.r,),
                                                        onPressed: () {
                                                          setState(() {
                                                            print(contact);
                                                            contact = contact
                                                                ? false
                                                                : true;
                                                            print(contact);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              contact
                                                  ? Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 7.w),

                                                      child: TextFieldWidget(
                                                        "Numéro de téléphone :",
                                                        _phonefocus,
                                                        _phoneCtrl,
                                                        TextInputType
                                                            .number,
                                                        null,
                                                        suffixIcon: "",
                                                      ),
                                                    ),

                                                    // Widgets.textfield0_dec(
                                                    //   "Numéro de téléphone :",
                                                    //   _phonefocus,
                                                    //   widget.user.bio,
                                                    //   _phoneCtrl,
                                                    //   TextInputType.text,
                                                    // ),
                                                    Container(
                                                      height: 12,
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 7.w),

                                                      child: TextFieldWidget(
                                                        "Email professionnel :",
                                                        _emailfocus,
                                                        _emailCtrl,
                                                        TextInputType
                                                            .emailAddress,
                                                        null,
                                                        suffixIcon: "",
                                                      ),
                                                    ),

                                                    // Widgets.textfield0_dec(
                                                    //   "Email professionnel :",
                                                    //   _emailfocus,
                                                    //   widget.user.bio,
                                                    //   _emailCtrl,
                                                    //   TextInputType.text,
                                                    // ),
                                                    Container(
                                                      height: 12.h,
                                                    ),
                                                    // divider,
                                                    Container(
                                                      height: 12.h,
                                                    ),
                                                  ],
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    //Emploi actuel
                                    Column(
                                      children: [
                                        Container(
                                          height: 12.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 25.w),
                                          // padding: EdgeInsets.symmetric(vertical: 3.h),
                                          decoration: BoxDecoration(
                                              color: Fonts.colors_container,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.r))),
                                          child: Column(
                                            children: [

                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 27.w,
                                                        ),
                                                        new Container(
                                                            child: new Text(
                                                              "EMPLOI ACTUEL ",
                                                              style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),
                                                            )),
                                                      ],
                                                    ),
                                                    Container(
                                                      alignment: Alignment
                                                          .centerRight,
                                                      child: IconButton(
                                                        icon: Icon(!emploi
                                                            ? Icons
                                                            .arrow_drop_down
                                                            : Icons
                                                            .arrow_drop_up,color: Fonts.col_app_grey,size: 30.r,),
                                                        onPressed: () {
                                                          setState(() {
                                                            print(emploi);
                                                            emploi = emploi
                                                                ? false
                                                                : true;
                                                            print(emploi);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              emploi
                                                  ? Container(
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Container(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        "Secteur :",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[
                                                            800],
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      ),
                                                      Expanded(
                                                        child:
                                                        Container(),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: secteur
                                                              .map((data) => Container(
                                                              width: MediaQuery.of(context).size.width * 0.35,
                                                              child: RadioListTile(
                                                                title:
                                                                Text(
                                                                  "${data.number}",
                                                                  style: TextStyle(fontSize: 13),
                                                                ),
                                                                activeColor: Fonts.col_app,
                                                                groupValue:
                                                                id,
                                                                value:
                                                                data.index,
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    selected_secteur = data.number;
                                                                    id = data.index;
                                                                  });
                                                                },
                                                              )))
                                                              .toList(),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                        Container(),
                                                      ),
                                                    ]),
                                                    Container(
                                                        height: 12.h),
                                                    Row(children: [
                                                      Container(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        "Domaine d'activité :",
                                                        style: TextStyle(
                                                            color: Colors.grey[
                                                            800],
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      ),
                                                      Expanded(
                                                        child:
                                                        Container(),
                                                      ),
                                                      Container(
                                                        // height: 150.0,
                                                        child: Row(
                                                          children: demaine
                                                              .map((data) => Container(
                                                              width: MediaQuery.of(context).size.width * 0.27,
                                                              child: RadioListTile(
                                                                activeColor: Fonts.col_app,
                                                                contentPadding:
                                                                EdgeInsets.all(0),
                                                                title:
                                                                Text(
                                                                  "${data.number}",
                                                                  style: TextStyle(fontSize: 13),
                                                                ),
                                                                groupValue:
                                                                id_domaine,
                                                                value:
                                                                data.index,
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    selected_domain = data.number;
                                                                    id_domaine = data.index;
                                                                  });
                                                                },
                                                              )))
                                                              .toList(),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                        Container(),
                                                      ),
                                                    ]),
                                                    Container(
                                                      height: 12,
                                                    ),

                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                                                      child: TextFieldWidget(
                                                        "ADRESSES",
                                                        _adrfcous,
                                                        _adrCtrl,
                                                        TextInputType
                                                            .text,
                                                        null,
                                                        suffixIcon: "",
                                                      ),
                                                    ),
                                                    // Widgets.textfield0_dec(
                                                    //   "Adresse :",
                                                    //   _adrfcous,
                                                    //   "",
                                                    //   _adrCtrl,
                                                    //   TextInputType.text,
                                                    // ),
                                                    Container(
                                                      height: 12,
                                                    ),
                                                  ],
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Column(
                                      children: [
                                        SizedBox(height: 20.h,),
                                        Center(
                                          // alignment: Alignment.bottomCenter,
                                            child: Container(

                                              //margin: EdgeInsets.only(bottom: 100.h),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.7,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.05,
                                                child: RaisedButton(
                                                  child: Text(
                                                    "Appliquer les changements",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 18.sp),
                                                  ),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          25.0),
                                                      side: BorderSide(
                                                          width: 0.1,
                                                          style:
                                                          BorderStyle
                                                              .solid)),
                                                  color: Fonts.col_app,
                                                  onPressed: () async {
                                                    print("***********");
                                                    var js = {
                                                      "actual_address":
                                                      _adraCtrl.text,
                                                      "permanent_address":
                                                      _adrpCtrl.text,
                                                      "address":
                                                      _adrCtrl.text,
                                                      "birthday":
                                                      birthDateCtrl.text,
                                                      "secteur":
                                                      selected_secteur,
                                                      "sexe": type,
                                                      "domain":
                                                      selected_domain,
                                                      "email_pro":
                                                      _emailCtrl.text,
                                                      "phone": _phoneCtrl.text
                                                    };

                                                    print({
                                                      "actual_address":
                                                      _adraCtrl.text,
                                                      "permanent_address":
                                                      _adrpCtrl.text,
                                                      "address":
                                                      _adrCtrl.text,
                                                      "birthday":
                                                      birthDateCtrl.text,
                                                      "secteur":
                                                      selected_secteur,
                                                      "domain":
                                                      selected_domain,
                                                      "email_pro":
                                                      _emailCtrl.text,
                                                      "phone":
                                                      _phoneCtrl.text,
                                                      "sexe": type
                                                    });

                                                    var a = await parse_s
                                                        .putparse(
                                                        "users/" +
                                                            widget
                                                                .user.id,
                                                        js);
                                                    print(a);

                                                    Scaffold.of(context)
                                                        .showSnackBar(new SnackBar(
                                                        content: new Text(
                                                            "Les information ont été bien modifiées !")));
                                                  },
                                                ))),
                                      ],
                                    ),

                                    // divider,
                                    Container(
                                      height: 12,
                                    ),
                                  ])
                                      : Container(),
                                  widget.user.role.id == "auSFKtqlF5"
                                      ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 25.w),
                                    // padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                        color: Fonts.colors_container,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.r))),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 27.w,
                                                  ),
                                                  new Container(
                                                      child: new Text(
                                                        "DATE DE NAISSANCE",
                                                        style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                alignment:
                                                Alignment.centerRight,
                                                child: IconButton(
                                                  icon: Icon(!date_ness
                                                      ? Icons
                                                      .arrow_drop_down
                                                      : Icons
                                                      .arrow_drop_up ,color: Fonts.col_app_grey,size: 30.r,),
                                                  onPressed: () {
                                                    setState(() {
                                                      print(date_ness);
                                                      date_ness =
                                                      date_ness
                                                          ? false
                                                          : true;
                                                      print(emploi);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        date_ness
                                            ? Column(
                                          children: [
                                            Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          print(
                                                              "yessss");
                                                          showDialog(
                                                              context:
                                                              context,
                                                              builder:
                                                                  (BuildContext
                                                              context) {
                                                                return AlertDialog(
                                                                  content:
                                                                  Container(
                                                                    width:
                                                                    double.maxFinite,
                                                                    child:
                                                                    SfDateRangePicker(
                                                                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                                                        print(args.value.toString().substring(0, 10));
                                                                        birthDateCtrl.text = args.value.toString().substring(0, 10);
                                                                        Navigator.pop(context);
                                                                      },
                                                                      selectionMode: DateRangePickerSelectionMode.single,
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                            width: 150.w,
                                                            color: Fonts.colors_container,
                                                            child: IgnorePointer(
                                                                child: MyTextFormField(
                                                                    name: "Date de naissance :  JJ-MM-AAAA",
                                                                    ctrl: birthDateCtrl,
                                                                    focus: FocusNode(),
                                                                    // validation: validateDate,
                                                                    type: TextInputType.text)
                                                            )
                                                        )
                                                    ),
                                                    GestureDetector(
                                                      child: Icon(Icons
                                                          .date_range),
                                                      onTap: () {
                                                        showDialog(
                                                            context:
                                                            context,
                                                            builder:
                                                                (BuildContext
                                                            context) {
                                                              return AlertDialog(
                                                                content:
                                                                Container(
                                                                  width:
                                                                  double.maxFinite,
                                                                  child:
                                                                  SfDateRangePicker(
                                                                    onSelectionChanged:
                                                                        (DateRangePickerSelectionChangedArgs args) {
                                                                      print(args.value.toString().substring(0, 10));
                                                                      birthDateCtrl.text = args.value.toString().substring(0, 10);
                                                                      Navigator.pop(context);
                                                                    },
                                                                    selectionMode:
                                                                    DateRangePickerSelectionMode.single,
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width:
                                                      ScreenUtil()
                                                          .setWidth(
                                                          0),
                                                    )
                                                  ],
                                                )
                                            ),
                                          ],
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                      : Container(),
                                  Container(
                                    height: 12.h,
                                  ),
                                  // divider,
                                  //COMPÉTENCES
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 25.w),
                                      // padding: EdgeInsets.symmetric(vertical: 3.h),
                                      decoration: BoxDecoration(
                                          color: Fonts.colors_container,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.r))),
                                      child: Column(
                                        children: [
                                          new Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 27.w,
                                                    ),
                                                    new Text("COMPÉTENCES",
                                                      style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    editwidget(Fonts.col_app,
                                                        edit_comp),
                                                    Container(
                                                      alignment:
                                                      Alignment.centerRight,
                                                      child: IconButton(
                                                        icon: Icon(!competences
                                                            ? Icons.arrow_drop_down
                                                            : Icons.arrow_drop_up,color: Fonts.col_app_grey,size: 30.r,),
                                                        onPressed: () {
                                                          setState(() {
                                                            print(competences);
                                                            competences =
                                                            competences
                                                                ? false
                                                                : true;
                                                            print(competences);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                          competences
                                              ? Column(
                                            children: [
                                              new Container(height: 12.0.h),

                                              Container(
                                                child: Column(
                                                  children: [
                                                    widget.user.list !=
                                                        null &&
                                                        widget.user.list
                                                            .isNotEmpty
                                                        ? new Center(
                                                        child: new Wrap(
                                                            crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .start,
                                                            spacing: 8.0,
                                                            runSpacing:
                                                            8.0,
                                                            children: widget
                                                                .user.list
                                                                .map((String
                                                            item) {
                                                              return a(
                                                                  item);
                                                            }).toList()))
                                                        : new Container(
                                                        padding:
                                                        new EdgeInsets
                                                            .only(
                                                            top: 16.0,
                                                            bottom:
                                                            24.0),
                                                        child: new Center(
                                                          child: new Text(
                                                            "Aucune compétence n'a été mentionnée ",
                                                            style: new TextStyle(
                                                                color: Colors
                                                                    .grey[
                                                                500],
                                                                fontSize:
                                                                16.0),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                              : Container()
                                        ],
                                      ))
                                  /* new Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[

                              a("PHP"),
                              a("#CSS"),
                              a("#Javascript")
                            ],
                          )*/
                                  ,
                                  // new Container(
                                  //   height: 14.0,
                                  // ),
                                  // new Container(
                                  //   height: 1.0,
                                  //   width: 1000.0,
                                  //   color: Colors.grey[300],
                                  // ),
                                  // new Container(
                                  //   height: 12.0,
                                  // ),

                                  // new Container(
                                  //   height: 1.0,
                                  //   width: 1000.0,
                                  //   color: Colors.grey[300],
                                  // ),
                                  new Container(
                                    height: 12.0.h,
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 25.w),
                                    // padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                        color: Fonts.colors_container,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.r))),
                                    child: Column(
                                      children: [
                                        new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 27.w,
                                                  ),
                                                  new Text(
                                                    "FORMATION",
                                                    style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(width: 12.0),
                                                  editwidget(Fonts.col_app,
                                                      edit_formation),
                                                  Container(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: IconButton(
                                                      icon: Icon(!formation
                                                          ? Icons.arrow_drop_down
                                                          : Icons.arrow_drop_up, color: Fonts.col_app_grey,size: 30.r,),
                                                      onPressed: () {
                                                        setState(() {
                                                          print(formation);
                                                          formation = formation
                                                              ? false
                                                              : true;
                                                          print(formation);
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]
                                        ),
                                        formation
                                            ?
                                        Container(
                                          child: widget.user.formations !=
                                              null
                                              ? Column(
                                              children:
                                              widget
                                                  .user.formations
                                                  .map((Formation
                                              e) =>
                                                  Container(
                                                    padding:
                                                    EdgeInsets.all(
                                                        10),
                                                    decoration:
                                                    BoxDecoration(
                                                      color: Fonts
                                                          .colors_container,
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      // border: Border.all(color:Color.fromRGBO(208, 207, 207, 1) )
                                                    ),
                                                    child:
                                                    Column(
                                                      children: [
                                                        Container(
                                                            height: 20,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    "Diplôme :",
                                                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                    child: Text(
                                                                      "${e.name}",
                                                                      style: TextStyle(),
                                                                    )),
                                                              ],
                                                            )),
                                                        Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  child: Text("annèe :", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                    child: Text(
                                                                      "${e.year}",
                                                                      style: TextStyle(),
                                                                    )),
                                                              ],
                                                            )),
                                                        Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  child: Text("Fillière de Formation ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Container(
                                                                    child: Text(
                                                                      "${e.filliere}",
                                                                      style: TextStyle(),
                                                                    )),
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          height:
                                                          7.5,
                                                        ),
                                                        Divider(
                                                          color:
                                                          Fonts.col_grey,
                                                          height:
                                                          2,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                          7.5,
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                  .toList())
                                              : new Container(
                                              padding:
                                              new EdgeInsets.only(
                                                  top: 16.0,
                                                  bottom: 24.0),
                                              child: new Center(
                                                child: new Text(
                                                  "Aucune formation n'a été mentionnée ",
                                                  style: new TextStyle(
                                                      color: Colors
                                                          .grey[500],
                                                      fontSize: 16.0),
                                                ),
                                              )),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    height: 12.0.h,
                                  ),
                                  // new Container(
                                  //   height: 1.0,
                                  //   width: 1000.0,
                                  //   color: Colors.grey[300],
                                  // ),
                                  // new Container(
                                  //   height: 12.0,
                                  // ),
                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 25.w),
                                    // padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                        color: Fonts.colors_container,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.r))),
                                    child: Column(
                                      children: [
                                        new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  new Text("CURRICULUM VITAE ",
                                                    style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  new Container(width: 12.0),
                                                  editwidget(
                                                      Fonts.col_app, edit_bio),
                                                  Container(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: IconButton(
                                                      icon: Icon(!Curriculum
                                                          ? Icons.arrow_drop_down
                                                          : Icons.arrow_drop_up,color: Fonts.col_app_grey,size: 30,),
                                                      onPressed: () {
                                                        setState(() {
                                                          Curriculum =
                                                          Curriculum
                                                              ? false
                                                              : true;
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),

                                        Curriculum
                                            ? Column(
                                          children: [
                                            new Container(
                                              height: 8.0,
                                            ),
                                            Container(
                                              child: widget.user.bio != "" &&
                                                  widget.user.bio
                                                      .toString() !=
                                                      "null" &&
                                                  widget.user.bio != null
                                                  ? new Container(
                                                padding:
                                                new EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0),
                                                width: 300.0,
                                                child: new Text(widget
                                                    .user.bio
                                                    .toString()),
                                              )
                                                  : new Container(
                                                child: new Center(
                                                  child: new Text(
                                                      "Ajouter une description ...",
                                                    style: new TextStyle(
                                                        color: Colors
                                                            .grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Container(
                                              height: 5.0.h,
                                            ),
                                          ],
                                        )
                                            : Container(
                                          height: 0,
                                        ),
                                        // SizedBox(height: 12.h,),
                                      ],
                                    ),
                                  ),
                                  // new Container(height: 8.0),
                                  // new Container(
                                  //   height: 1.0,
                                  //   width: 1000.0,
                                  //   color: Colors.grey[300],
                                  // ),

                                  ///social_media
                                  new Container(
                                    height: 8.0,
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 25.w),
                                    // padding: EdgeInsets.symmetric(vertical: 3.h),
                                    decoration: BoxDecoration(
                                        color: Fonts.colors_container,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.r))),
                                    child: Column(
                                      children: [
                                        new Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 27.w,
                                                  ),
                                                  new Text("SOCIAL MEDIA",
                                                    style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  new Container(width: 12.0),
                                                  Container(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: IconButton(
                                                      icon: Icon(!social_media
                                                          ? Icons.arrow_drop_down
                                                          : Icons.arrow_drop_up,color: Fonts.col_app_grey,size: 30.r,),
                                                      onPressed: () {
                                                        setState(() {
                                                          social_media =
                                                          social_media
                                                              ? false
                                                              : true;
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),

                                        // new Container(height: 8.0),

                                        social_media
                                            ?
                                        Column(
                                          children: [
                                            // new Container(height: 20.0.h),
                                            new GestureDetector(
                                                onTap: () {},
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      width: 12.0.w,
                                                    ),
                                                    new Image.asset(
                                                      // "images/linkedin.png",
                                                      "images/linkk.png",

                                                      width: 20.0.w,
                                                      height: 20.0.h,
                                                    ),
                                                    new Container(
                                                      width: 12.0.w,
                                                    ),
                                                    widget.user.linkedin_link != "" &&
                                                        widget.user.linkedin_link
                                                            .toString() !=
                                                            "null"
                                                        ? new Center(
                                                        child: new Container(
                                                            width: 180.0.w,
                                                            child: new Text(
                                                              widget
                                                                  .user.linkedin_link
                                                                  .toString(),
                                                              style: new TextStyle(
                                                                  color: Colors
                                                                      .grey[600]),
                                                            )))
                                                        : new Text(
                                                      "Profil Linkedin:",
                                                      style: new TextStyle(
                                                          color: Colors.grey[800],fontSize:11.sp,
                                                          fontWeight:
                                                          FontWeight.w100),
                                                    ),
                                                    new Expanded(child: Container()),
                                                    new InkWell(
                                                        child: new Container(
                                                            padding:
                                                            new EdgeInsets.all(4.0),
                                                            decoration: new BoxDecoration(
                                                              // boxShadow: [
                                                              //   new BoxShadow(
                                                              //     color: Colors.blue[50],
                                                              //     offset: new Offset(0.0, 0.8),
                                                              //     blurRadius: 30.0,
                                                              //   ),
                                                              // ],
                                                            ),
                                                            child: new Icon(
                                                              Icons.edit,
                                                              color: Fonts.col_app,
                                                            )),
                                                        onTap: () {
                                                          edit_link("linkedin");

                                                          // open_bottomsheet();
                                                        }),
                                                  ],
                                                )),
                                            // new Container(height: 5.0),
                                            new GestureDetector(
                                                onTap: () {},
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      width: 12.0,
                                                    ),
                                                    new Image.asset(
                                                      // "images/instagram.png",
                                                      "images/instaa.png",

                                                      width: 20.0.w,
                                                      height: 20.0.w,
                                                    ),
                                                    new Container(
                                                      width: 12.0,
                                                    ),
                                                    widget.user.instargram_link != "" &&
                                                        widget.user.instargram_link
                                                            .toString() !=
                                                            "null"
                                                        ? new Center(
                                                        child: new Text(
                                                          widget.user.instargram_link
                                                              .toString(),
                                                          style: new TextStyle(
                                                              color: Colors.grey[600]),
                                                        ))
                                                        : new Text(
                                                      "Profil Instagram :",
                                                      style: new TextStyle(
                                                          color: Colors.grey[800],fontSize: 11.sp,
                                                          fontWeight:
                                                          FontWeight.w100),
                                                    ),
                                                    new Expanded(child: Container()),
                                                    new InkWell(
                                                        child: new Container(
                                                            padding:
                                                            new EdgeInsets.all(4.0),
                                                            decoration: new BoxDecoration(
                                                              // boxShadow: [
                                                              //   new BoxShadow(
                                                              //     color: Colors.blue[50],
                                                              //     offset: new Offset(0.0, 0.8),
                                                              //     blurRadius: 30.0,
                                                              //   ),
                                                              // ],
                                                            ),
                                                            child: new Icon(
                                                              Icons.edit,
                                                              color: Fonts.col_app,
                                                            )),
                                                        onTap: () {
                                                          edit_link("instagram");

                                                          // open_bottomsheet();
                                                        }),
                                                  ],
                                                )),
                                            // new Container(height: .0),
                                            new GestureDetector(
                                                onTap: () {},
                                                child: new Row(
                                                  children: <Widget>[
                                                    new Container(
                                                      width: 12.0,
                                                    ),
                                                    new Image.asset(
                                                      // "images/twitter.png",
                                                      "images/twitt.png",

                                                      width: 25.0.w,
                                                      height: 25.0.h,
                                                    ),
                                                    new Container(
                                                      width: 12.0,
                                                    ),
                                                    widget.user.twitter_link != "" &&
                                                        widget.user.twitter_link
                                                            .toString() !=
                                                            "null"
                                                        ? new Center(
                                                        child: new Text(
                                                          widget.user.twitter_link
                                                              .toString(),
                                                          style: new TextStyle(
                                                              color: Colors.grey[600]),
                                                        ))
                                                        : new Text(
                                                      "Profil Twitter :",
                                                      style: new TextStyle(
                                                          color: Colors.grey[800],fontSize: 11.sp,
                                                          fontWeight: FontWeight.w100),
                                                    ),
                                                    new Expanded(child: Container()),
                                                    new InkWell(
                                                        child: new Container(
                                                            padding:
                                                            new EdgeInsets.all(4.0),
                                                            decoration: new BoxDecoration(
                                                              // boxShadow: [
                                                              //   new BoxShadow(
                                                              //     color: Colors.blue[50],
                                                              //     offset: new Offset(0.0, 0.8),
                                                              //     blurRadius: 30.0,
                                                              //   ),
                                                              // ],
                                                            ),
                                                            child: new Icon(
                                                              Icons.edit,
                                                              color: Fonts.col_app,
                                                            )),
                                                        onTap: () {
                                                          edit_link("twitter");

                                                          // open_bottomsheet();
                                                        }),
                                                  ],
                                                )),
                                            new Container(
                                              height: 12.0,
                                            ),
                                          ],
                                        ) : Container(),
                                      ],
                                    ),
                                  ),

                                  // divider,

                                  //Paramètres

                                  Row(
                                    children: [
                                      Container(
                                        width: 30.w,
                                      ),
                                      Icon(Icons.settings,
                                          size: 25.r, color: Fonts.col_app_grey
                                      ),
                                      new Container(
                                          padding: new EdgeInsets.only(
                                              top: 16.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 16.0),
                                          // color: Colors.grey[100],
                                          child: new Text(
                                            "Paramètres :",
                                            style: new TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  // divider,

                                  //Je veux être visible

                                  new Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 25.w),
                                    // color: Colors.grey[50],
                                    padding: new EdgeInsets.only(
                                        top: 4.0.h, bottom: 4.0),
                                    // color: Colors.grey[100],
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.7,

                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          decoration: BoxDecoration(
                                              color: Fonts.colors_container,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.r))),
                                          child: new Row(
                                            children: <Widget>[
                                              SizedBox(width: 20.h,),
                                              new Text(
                                                "JE VEUX ÊTRE VISIBLE :",
                                                style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                              ),
                                            ],
                                          ),
                                        ),
                                        new Expanded(
                                            child: new Container(width: 5.0.w)),
                                        new Switch(
                                          inactiveTrackColor: Fonts.colors_container,
                                          activeTrackColor: Fonts.colors_container,
                                          activeColor: Fonts.col_app,
                                          inactiveThumbColor: Fonts.col_app_grey,

                                          value: val,
                                          onChanged: (bool value) {
                                            setState(() {
                                              val = value;
                                            });
                                            if (val) {
                                              make_user_online();
                                              print("online");
                                            } else {
                                              make_user_offline();
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  // divider,

                                  //Je veux recevoir des notifications

                                  new Container(
                                    // color: Colors.grey[100],
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 25.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.7,

                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 0.w),
                                          decoration: BoxDecoration(
                                              color: Fonts.colors_container,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.r))),
                                          child: new Row(
                                            children: <Widget>[
                                              SizedBox(width: 20.w,),
                                              new Text(
                                                "JE VEUX RECEVOIR DES NOTIFICATION :",
                                                style: TextStyle(color: Fonts.col_app_grey ,fontSize: 11.5,fontWeight: FontWeight.w500),

                                              ),
                                            ],
                                          ),
                                        ),
                                        new Expanded(
                                            child: new Container(width: 12.0)),
                                        new Switch(

                                            inactiveTrackColor: Fonts.colors_container,
                                            activeTrackColor: Fonts.colors_container,
                                            activeColor: Fonts.col_app,
                                            inactiveThumbColor: Fonts.col_app_grey,

                                            value: true,
                                            onChanged: (val) {})
                                      ],
                                    ),
                                  ),
                                  // divider,
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  //Politique de confidentialité

                                  new InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                new Potique()));
                                      },
                                      child: new Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.78,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        // padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                                        decoration: BoxDecoration(
                                            color: Fonts.colors_container,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.r))),
                                        padding: new EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 4.0,
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        // color: Colors.grey[100],
                                        child: new Row(
                                          children: <Widget>[
                                            SizedBox(width: 20.w,),
                                            new Text(
                                              "POLITIQUE DE CONFIDENTIALITÉ",
                                              style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12,fontWeight: FontWeight.w500),

                                            ),
                                            new Expanded(
                                                child:
                                                new Container(width: 12.0)),
                                            new Icon(Icons.arrow_right ,color: Fonts.col_app_grey ,size: 30,)
                                          ],
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  // divider,

                                  //Conditions générales

                                  new InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                new Conditions()));
                                      },
                                      child: new Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.78,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        // padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
                                        decoration: BoxDecoration(
                                            color: Fonts.colors_container,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.r))),
                                        padding: new EdgeInsets.only(
                                          top: 4.0.h,
                                          bottom: 4.0.h,
                                          left: 8.0.w,
                                          right: 8.0.w,
                                        ),
                                        // color: Colors.grey[100],
                                        child: new Row(
                                          children: <Widget>[
                                            SizedBox(width: 20.w,),
                                            new Text(
                                              "CONDITIONS GÉNÉRALES D'UTILISATIONS :",
                                              style: TextStyle(color: Fonts.col_app_grey ,fontSize: 12.sp,fontWeight: FontWeight.w500),

                                            ),
                                            new Expanded(
                                                child:
                                                new Container(width: 12.0)),
                                            new Icon(Icons.arrow_right ,color: Fonts.col_app_grey ,size: 30.r,)
                                          ],
                                        ),
                                      )),
                                  Container(height: 150.h)
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )))),
    );
    return widget.show
        ? new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey[50],
        platform: Theme.of(context).platform,
      ),
      child: page,
    )
        : page; //
  }

/*
*/
}

class FullScreenWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Color backgroundColor;
  final dynamic minScale;
  final dynamic maxScale;

  FullScreenWrapper(
      {this.imageProvider,
        this.loadingChild,
        this.backgroundColor,
        this.minScale,
        this.maxScale});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.black,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.close,
                  color: Colors.grey[50],
                  size: 26.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        backgroundColor: Colors.black87,
        body: new Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: new PhotoView(
              imageProvider: imageProvider,
              //  loadingChild: loadingChild,
              //backgroundColor: backgroundColor,
              minScale: minScale,
              maxScale: maxScale,
            )));
  }
}
