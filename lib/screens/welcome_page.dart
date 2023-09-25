import 'package:beatim5/screens/earphones_recommend_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_svg/svg.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  

  Future<String> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var text = 'Ver.${packageInfo.version}';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
              height: 400,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SvgPicture.asset(
                    'images/logo.svg',
                    semanticsLabel: 'Shake Smartphone',
                    width: 250,
                    height: 250,
                  ),
                ),
              )),
          FutureBuilder(
            future: getVersionInfo(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('エラー: ${snapshot.error}');
                } else {
                  return Text(snapshot.data ?? '未取得');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0,),
            child: PageTransitionButton(
              '始める',
              () {
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => EarphoneRecommendPage(),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
