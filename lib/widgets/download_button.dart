import 'package:flutter/material.dart';
import 'package:beatim5/models/download_status.dart';
import 'package:flutter_svg/svg.dart';

@immutable
class DownloadButton extends StatelessWidget {
  DownloadButton(this.downloadStatus,this.onPressedIfNotDownloaded,this.onPressedIfDownloaded,{Key? key}) : super(key: key);

  final onPressedIfNotDownloaded;
  final onPressedIfDownloaded;
  DownloadStatus downloadStatus;

  @override
  Widget build(BuildContext context) {
    if(downloadStatus == DownloadStatus.notDownloaded){
      return Container(
        height: 50,
        width: 50,
        color: Colors.orange,
        child: ElevatedButton(
          onPressed:onPressedIfNotDownloaded,
          child: SvgPicture.asset(
            'images/download.svg',
            semanticsLabel: 'privacy policy',
            width: 30,
            height: 30,
          ),
        ),
      );
    }else{
      return Container(
          height: 50,
          width: 50,
          color: Colors.grey,
          child: ElevatedButton(
            onPressed:onPressedIfDownloaded,
            child: SvgPicture.asset(
              'images/complete.svg',
              semanticsLabel: 'privacy policy',
              width: 30,
              height: 30,
            ),
          ),
      );
    }
  }
}


