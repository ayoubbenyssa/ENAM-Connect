import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_bloc.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_event.dart';
import 'package:enamconnect/app/filters_users_bloc/filter_state.dart';
import 'package:enamconnect/models/user.dart';
import 'package:enamconnect/networking/user_item.dart';
import 'package:enamconnect/services/Fonts.dart';

class FilterByLasteUsesr extends StatefulWidget {
  FilterByLasteUsesr(this.user);

  User user;

  @override
  _FilterByLasteUsesrState createState() => _FilterByLasteUsesrState();
}

class _FilterByLasteUsesrState extends State<FilterByLasteUsesr> {
  FilterUsersBloc _filteBloc;

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
              : ListView(
                  children: users
                      .map((e) => UserItem(e, widget.user, "newer"))
                      .toList());
        } else {
          return Container();
        }
      }),
      appBar: new AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text(
          "Dernière connexion",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
