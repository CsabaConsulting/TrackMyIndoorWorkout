import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../persistence/preferences.dart';

class DataFormatPickerBottomSheet extends StatefulWidget {
  @override
  DataFormatPickerBottomSheetState createState() => DataFormatPickerBottomSheetState();
}

class DataFormatPickerBottomSheetState extends State<DataFormatPickerBottomSheet> {
  int _formatIndex;
  List<String> _formatChoices;
  double _sizeDefault;
  TextStyle _selectedTextStyle;
  TextStyle _largerTextStyle;

  @override
  void initState() {
    super.initState();

    _sizeDefault = Get.mediaQuery.size.width / 10;
    _selectedTextStyle = TextStyle(fontFamily: FONT_FAMILY, fontSize: _sizeDefault);
    _largerTextStyle = _selectedTextStyle.apply(color: Colors.black);

    _formatChoices = ["FIT", "TCX"];
    _formatIndex = max(0, _formatChoices.indexOf("FIT"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _formatChoices
            .asMap()
            .entries
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 2,
                    child: Radio(
                      value: e.key,
                      groupValue: _formatIndex,
                      onChanged: (value) {
                        setState(() {
                          _formatIndex = value;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _formatIndex = e.key;
                      });
                    },
                    child: Text(e.value,
                        style: _formatIndex == e.key ? _selectedTextStyle : _largerTextStyle),
                  ),
                ],
              ),
            )
            .toList(growable: false),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: Icon(Icons.check),
        onPressed: () => Get.back(result: _formatChoices[_formatIndex]),
      ),
    );
  }
}
