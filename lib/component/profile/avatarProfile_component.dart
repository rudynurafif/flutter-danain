import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/user.dart';
import '../../widgets/text/headline.dart';

class AvatarProfile extends StatelessWidget {
  final User? user;

  const AvatarProfile(BuildContext context, {Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: SvgPicture.asset(
                  'assets/images/home/background.svg',
                  fit: BoxFit.fitWidth,
                  height: 180,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 48,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/home/profile_user_icon.svg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Headline3(text: user?.username ?? ''),
                    const SizedBox(height: 7),
                    StatusAccountControl(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusAccountControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil dataHome dari mana?
    // Perlu diambil dari parameter atau dari tempat lain
    return Container(); // Gantilah ini dengan implementasi yang sesuai
  }
}
