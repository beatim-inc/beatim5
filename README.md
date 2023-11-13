# Beatim5

## おまじない

```shell
flutter pub get

cd ios
pod install
cd ..

flutter run
```

### エラーが起こったら

とりあえず`flutter clean`を実行しおまじないコマンド

### profile問題

- Bundle Identifier を `beatim5.com.beatim5` に設定する

## Document

### movePace, speed に関して

単位
 - movePace (分/km)
 - speed (m/s)

movePaceとspeedの関係
 - movePace * speed = 1000/60
