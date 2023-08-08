import 'package:beatim5/models/DLstatus.dart';
import 'package:beatim5/widgets/download_button.dart';
import 'package:flutter/material.dart';

 class header extends StatelessWidget {
  final String thumbnail;
  final String title;
  final String subtitile1;
  final String menu;
  final DownloadStatus downloadStatus;
  final onPressedIfNotDownloaded;
  final onPressedIfDownloaded;

  const header(this.thumbnail,this.title,this.subtitile1,this.menu,this.downloadStatus,this.onPressedIfNotDownloaded,this.onPressedIfDownloaded,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 390,
        height: 96,
        child: Row(
          children: [
            Image.asset(
              thumbnail,
              height: 60,
              width:  60,
            ),
            Column(
              children: [
                Text(title),
                Text(subtitile1),
                Text(menu),
              ],
            ),
            DownloadButton(downloadStatus, onPressedIfNotDownloaded, onPressedIfDownloaded)
          ],
        ),
      ),
    );
  }
}
