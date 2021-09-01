import 'package:canvas/color_picker/library/entry_file.dart';
import 'package:flutter/material.dart';

import 'library/picker_file.dart';
import 'library/utils.dart';

class CustomColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  bool lightTheme = true;
  Color currentColor = Colors.limeAccent;
  List<Color> currentColors = [Colors.limeAccent, Colors.green];

  void changeColor(Color color) => setState(() => currentColor = color);
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          elevation: 3.0,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0.0),
                  contentPadding: const EdgeInsets.all(0.0),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                      colorPickerWidth: 300.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hsv,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Change me'),
          color: currentColor,
          textColor: useWhiteForeground(currentColor)
              ? const Color(0xffffffff)
              : const Color(0xff000000),
        ),
        MaterialButton(
          elevation: 3.0,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0.0),
                  contentPadding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  content: SingleChildScrollView(
                    child: SlidePicker(
                      pickerColor: currentColor,
                      onColorChanged: changeColor,
                      paletteType: PaletteType.rgb,
                      enableAlpha: false,
                      displayThumbColor: true,
                      showLabel: false,
                      showIndicator: true,
                      indicatorBorderRadius: const BorderRadius.vertical(
                        top: const Radius.circular(25.0),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Change me again'),
          color: currentColor,
          textColor: useWhiteForeground(currentColor)
              ? const Color(0xffffffff)
              : const Color(0xff000000),
        ),
      ],
    );
  }
}
