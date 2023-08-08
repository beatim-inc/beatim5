import 'package:flutter/material.dart';
import 'package:beatim5/models/DLstatus.dart';

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
        height: 40,
        width: 160,
        color: Colors.orange,
        child: ElevatedButton(
          child: Text('Download'),
          onPressed:onPressedIfNotDownloaded,
        ),
      );
    }else{
      return Container(
          height: 40,
          width: 80,
          color: Colors.grey,
          child: ElevatedButton(
            child: Text('Download Completed'),
              onPressed:onPressedIfDownloaded,
          ),
      );
    }
  }
}


