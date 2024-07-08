import 'package:disposebag/disposebag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home_state.dart';
import 'package:flutter_danain/pages/login/login_page.dart';
import 'package:flutter_danain/utils/utils.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../../../component/borrower/home/home_component_borrower.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  final int? index;
  final int? subIndex;

  const HomePage({Key? key, this.index, this.subIndex}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage>, DisposeBagMixin {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  Object? listen;
  int contentIndex = 0;
  int subIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as HomePage?;
    if (args != null && args.index != null) {
      setState(() {
        contentIndex = args.index!;
      });
    }
    if (args != null && args.subIndex != null) {
      setState(() {
        subIndex = args.subIndex!;
      });
    }
    listen ??= BlocProvider.of<HomeBloc>(context)
        .message$
        .flatMap(handleMessage)
        .collect()
        .disposedBy(bag);
  }

  @override
  void initState() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    homeBloc.setBeranda();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return HomeComponentBorrower(
      index: contentIndex,
      subIndex: subIndex,
    );
  }

  Stream<void> handleMessage(HomeMessage message) async* {
    debugPrint('[DEBUG] homeBloc message=$message');

    if (message is LogoutMessage) {
      if (message is LogoutSuccessMessage) {
        // context.showSnackBarSuccess('Logout successfully!');
        // ignore: use_build_context_synchronously
        await Navigator.of(context).pushNamedAndRemoveUntil(
          LoginPage.routeName,
          (_) => false,
        );
        return;
      }
      if (message is LogoutErrorMessage) {
        context.showSnackBar('Error when logout: ${message.message}');
        return;
      }
      return;
    }
  }
}
