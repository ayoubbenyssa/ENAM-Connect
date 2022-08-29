import 'package:enamconnect/widgets/custom_widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_event.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/networking/user_item.dart';
import 'package:enamconnect/services/Fonts.dart';

class FilterByNewUsers extends StatefulWidget {
  FilterByNewUsers(this.user);
  User user;
  @override
  _FilterByNewUsersState createState() => _FilterByNewUsersState();
}

class _FilterByNewUsersState extends State<FilterByNewUsers> {

  FilterUsersBloc _filteBloc;

  Widget bottom_appbar (){
    PreferredSize(child: Container(),);

  }

  @override
  void initState() {
    super.initState();



    _filteBloc = BlocProvider.of<FilterUsersBloc>(context);
    _filteBloc.add(FilterUsersquested(type: "newer", user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FilterUsersBloc, FilterUsersState>(
          builder: (context, homeState) {
        if (homeState is FilterUsersLoadInProgress) {
          return Center(
            child: Padding(
                padding: EdgeInsets.only(top: 64),
                child: CupertinoActivityIndicator()),
          );
        } else if (homeState is FilterUsersLoadSuccess) {
          final users = homeState.calResponse.user;

          print(users);
          return (users.isEmpty)
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 64),
                      child: Text("Aucun utilisateur trouvé !")),
                )
              : ListView(children: users.map((e) => UserItem(e,widget.user,"newer")).toList());
        } else {
          return Container();
        }
      }),
      appBar: PreferredSize(
          preferredSize: new Size.fromHeight(128.h),

          child: ApBar("assets/images/ABCENCE.svg","" ,"Nouveaux utilisateurs" , bottom_appbar() )),
    );
  }
}
