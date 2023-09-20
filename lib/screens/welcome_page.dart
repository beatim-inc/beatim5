import 'package:beatim5/screens/data_collect_agree_page.dart';
import 'package:beatim5/templates/base_layout.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: SizedBox(
              width: 352,
              // explanation SizedBox の Width が 83　なので 52, 135
              height: 52,
              child: Center(
                child: Text(
                  'Beatim Runner (β版)',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
          SizedBox(
              height: 480,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset(
                    'images/logo.png',
                    width: 300,
                    height: 300,
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PageTransitionButton(
              '始める',
              () {
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => DataCollectAgreePage(),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
