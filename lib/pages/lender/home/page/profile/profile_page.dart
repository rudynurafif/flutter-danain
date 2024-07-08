import 'package:flutter/material.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/page/profile/profile_loading.dart';
import 'package:flutter_danain/pages/lender/home/page/profile/profile_success.dart';

class ProfilePageLender extends StatefulWidget {
  final HomeLenderBloc homeBloc;
  const ProfilePageLender({
    super.key,
    required this.homeBloc,
  });

  @override
  State<ProfilePageLender> createState() => _ProfilePageLenderState();
}

class _ProfilePageLenderState extends State<ProfilePageLender> {
  @override
  void initState() {
    super.initState();
    widget.homeBloc.getDataProfile();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.homeBloc;
    return RefreshIndicator(
      onRefresh: () async {
        return bloc.getDataProfile();
      },
      child: StreamBuilder<User?>(
        stream: bloc.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return StreamBuilder<Map<String, dynamic>?>(
              stream: bloc.dataHome,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final dataHome = snapshot.data ?? {};
                  return ProfileLenderSuccess(
                    homeBloc: bloc,
                    user: user,
                    dataHome: dataHome,
                  );
                }
                return const ProfileLenderLoading();
              },
            );
          }
          return const ProfileLenderLoading();
        },
      ),
    );
  }
}
