import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/auxpage/onboarding_borrower_page.dart';
import 'package:flutter_danain/pages/lender/onbarding/onboarding_lender.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class OnboardingMaster extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingMaster({super.key});

  @override
  State<OnboardingMaster> createState() => _OnboardingMasterState();
}

class _OnboardingMasterState extends State<OnboardingMaster> {
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: rxPrefs.getInt('user_status'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future is still in progress, return a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final int userStatus = snapshot.data ?? 0;
          switch (userStatus) {
            case 2:
              return const OnboardingBorrowerPage();
            case 1:
              return const OnboardingLender();
          // Add more cases as needed
            default:
              return CircularProgressIndicator();
          }
        } else {
          return Container();
        }
      },
    );
  }

}
