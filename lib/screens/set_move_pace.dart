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
    MovePaceSuggestionItem('速度1', '通常のウォーキング', 12.0, Colors.red, false),
    MovePaceSuggestionItem('速度1', '早歩き', 10.0, Colors.red, false),
    MovePaceSuggestionItem('速度2', '初級ランニング', 8.0, Colors.green, false),
    MovePaceSuggestionItem('速度2', '中級ランニング', 6.0, Colors.green, false),
    MovePaceSuggestionItem('速度2', '上級ランニング', 4.0, Colors.green, false),
    MovePaceSuggestionItem('カスタム', 'ペースを入力してください', 5.0, Colors.blue, true),
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

  String? _inputErrorText;

  void _validateInput() {
    final value = _customPaceController.text;
    final double? parsedValue = double.tryParse(value);
    final isValid =
        parsedValue != null && RegExp(r'^\d+(\.\d+)?$').hasMatch(value);

    setState(() {
      if (isValid && parsedValue > 0) {
        _inputErrorText = null;
      } else if (value.isEmpty) {
        _inputErrorText = null;
      } else if (parsedValue == 0.0) {
        _inputErrorText = '0以外の数値を入力してください。';
      } else {
        _inputErrorText = '正しい数値を入力してください。';
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
                        '移動速度の選択',
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
                        '以下から速度を選択してください',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
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
                          title: Text(paceItem.isEditableMovePace
                              ? _customPaceController.text.isEmpty
                                  ? paceItem.title
                                  : "${paceItem.title}: ${_customPaceController.text}min/km"
                              : "${paceItem.title}: ${paceItem.movePace.toString()}min/km"),
                          subtitle: paceItem.isEditableMovePace
                              ? TextField(
                                  controller: _customPaceController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
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
                                    hintText: paceItem.description,
                                    border: const OutlineInputBorder(),
                                    errorText: _inputErrorText,
                                  ),
                                )
                              : Text(paceItem.description),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: PageTransitionButton('OK', () {
                    final selectedPace = paceItems[_currentIndex];
                    saveMovePaceToPreferences(selectedPace.movePace!);

                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ChoosePlaylistPage(),
                      ),
                    );
                  }),
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
