import 'package:beatim5/screens/choose_playlist_page.dart';
import 'package:beatim5/widgets/page_transition_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SetMovePacePage extends StatefulWidget {
  const SetMovePacePage({super.key});

  @override
  _SetMovePacePageState createState() => _SetMovePacePageState();
}

class _SetMovePacePageState extends State<SetMovePacePage> {
  List<MovePaceSuggestionItem> paceItems = [
    MovePaceSuggestionItem(
        'ウォーキング',
        'このペースは日常の散歩やリラックスしたウォーキングに最適です。健康の維持やリフレッシュのために適しています。',
        12.0,
        Colors.white,
        false),
    MovePaceSuggestionItem(
        '早歩き',
        'このペースはやや速めの歩きで、日常の移動や軽い運動として適しています。カロリー消費も増え、健康促進に役立ちます。',
        10.0,
        Colors.white,
        false),
    MovePaceSuggestionItem(
        '初級ランニング',
        'ランニング初心者や久しぶりの方に適したペースです。持続的な運動効果を求める方におすすめです。',
        8.0,
        Colors.white,
        false),
    MovePaceSuggestionItem(
        '中級ランニング',
        'ある程度のランニング経験者や練習を積んでいる方に適したペースです。心肺機能の向上や筋力アップに効果的です。',
        6.0,
        Colors.white,
        false),
    MovePaceSuggestionItem(
        '上級ランニング',
        'ランニング経験豊富で、高い運動能力を持つ方向けのペースです。競技や記録更新を目指す方に適しています。',
        4.0,
        Colors.white,
        false),
    MovePaceSuggestionItem('カスタムペース', 'ご自身に適したペースを把握されている場合は、こちらから設定できます。',
        null, Colors.white, true),
  ];

  int _currentIndex = 0;
  final TextEditingController _customPaceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customPaceController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _customPaceController.removeListener(_validateInput);
    _customPaceController.dispose();
    super.dispose();
  }

  bool _isButtonActive = true;
  String? _inputErrorText;

  void _validateInput() {
    final value = _customPaceController.text;
    final double? parsedValue = double.tryParse(value);
    final isValid =
        parsedValue != null && RegExp(r'^\d+(\.\d+)?$').hasMatch(value);

    setState(() {
      if (isValid && parsedValue > 0) {
        _inputErrorText = null;
        _isButtonActive = true;
      } else if (value.isEmpty) {
        _inputErrorText = null;
        _isButtonActive = false;
      } else if (parsedValue == 0.0) {
        _inputErrorText = '0以外の数値を入力してください。';
        _isButtonActive = false;
      } else {
        _inputErrorText = '正しい数値を入力してください。';
        _isButtonActive = false;
      }
    });
  }

  Future<void> saveMovePaceToPreferences(double pace) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('movePace', pace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: 352,
                    height: 52,
                    child: Center(
                      child: Text(
                        '移動ペースの設定',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: SizedBox(
                    width: 280,
                    height: 83,
                    child: Center(
                      child: Text(
                        '最適なペースを設定しましょう！',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: CarouselSlider.builder(
                    itemCount: paceItems.length,
                    itemBuilder: (context, index, realIdx) {
                      final paceItem = paceItems[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: paceItem.itemColor,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30.0, top: 20.0),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .copyWith(fontSize: 20.0),
                                  children: [
                                    if (paceItem.isEditableMovePace)
                                      TextSpan(text: paceItem.title)
                                    else ...[
                                      TextSpan(
                                          text: paceItem.movePace.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: " 分/km - ${paceItem.title}"),
                                    ]
                                  ],
                                ),
                              )),
                          subtitle: paceItem.isEditableMovePace
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: TextField(
                                        controller: _customPaceController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        onChanged: (value) {
                                          final double? newValue =
                                              double.tryParse(value);
                                          if (newValue != null) {
                                            setState(() {
                                              paceItem.movePace = newValue;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'ペースを入力',
                                          border: const OutlineInputBorder(),
                                          errorText: _inputErrorText,
                                          suffixText: '分/km',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    // これはテキストフィールドと説明文の間のスペースです
                                    Text(paceItem.description),
                                  ],
                                )
                              : Text(paceItem.description),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 350.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;

                          if (paceItems[index].isEditableMovePace) {
                            _validateInput();
                          } else {
                            _isButtonActive = true;
                          }
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: PageTransitionButton(
                      '決定',
                      _isButtonActive
                          ? () {
                              final selectedPace = paceItems[_currentIndex];
                              saveMovePaceToPreferences(selectedPace.movePace!);

                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ChoosePlaylistPage(),
                                ),
                              );
                            }
                          : null),
                ),
              ],
            ),
          ),
        ));
  }
}

class MovePaceSuggestionItem {
  final String title;
  final String description;
  double? movePace;
  final Color itemColor;
  final bool isEditableMovePace;

  MovePaceSuggestionItem(this.title, this.description, this.movePace,
      this.itemColor, this.isEditableMovePace);
}
