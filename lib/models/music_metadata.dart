class MusicMetadata{

  MusicMetadata(this.bpm,this.displayName,this.fileName);

  final int bpm;
  final String displayName;
  final String fileName;
}

// TODO: 本来はここにいるべきではないので削除したい
// classが複数あるのでProviderなどを利用して解決？
List<MusicMetadata> musicPlaylist = [];
