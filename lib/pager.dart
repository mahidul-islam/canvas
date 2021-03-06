import 'package:canvas/font/basic_font.dart';
import 'package:canvas/font/font_resize.dart';
import 'package:canvas/font/network_font.dart';
import 'package:canvas/markdown/first_markdown.dart';
import 'package:canvas/random/clock.dart';
import 'package:canvas/color_picker/color_picker.dart';
import 'package:canvas/color_picker/custom_color_picker.dart';
import 'package:canvas/interactive/draggable_widget.dart';
import 'package:canvas/random/drawing_page.dart';
import 'package:canvas/random/flower.dart';
import 'package:canvas/image/generate_image.dart';
import 'package:canvas/image/image_in_rect.dart';
import 'package:canvas/random/image_loader_pskink.dart';
import 'package:canvas/image/multi_rect.dart';
import 'package:canvas/interactive/multiple_interactive_rect.dart';
import 'package:canvas/interactive/rotatable_widget.dart';
import 'package:canvas/interactive/scalable_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'image/hello.dart';
import 'interactive/optimized_draggable.dart';

class PagerWidget extends StatefulWidget {
  const PagerWidget({Key? key}) : super(key: key);

  @override
  _PagerWidgetState createState() => _PagerWidgetState();
}

class _PagerWidgetState extends State<PagerWidget> {
  late PageController _controller;
  List<Widget> _pages = <Widget>[
    MarkdownWidget(),
    // CustomPainterDraggable(),
    // CustomPainterRotatble(),
    // OptimizedDraggable(),
    CustomPainterScalable(),
    MultipleRectangle(),
    NetworkFontExample(),
    // CustomFontResizeAuto(),
    // DynamicFontLoadingInsideCanvas(), // TODO: complete it,
    // ImageInsideRectPage(),
    MultiRectRotatedAroundCenterPage(),
    // FlowerPage(),
    // Draw(),
    // BlurView('assets/img.png'),
    // ClockPage(),
    // ColorPickerFirst(),
    CustomColorPicker(),
    ImageGenerator(),
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 32),
              FloatingActionButton(
                  onPressed: () {
                    _controller.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: Icon(Icons.arrow_back_ios_new)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 32),
              FloatingActionButton(
                  onPressed: () {
                    _controller.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: Icon(Icons.arrow_forward_ios_sharp)),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          Positioned(
            bottom: 32,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: WormEffect(
                  dotWidth: 7,
                  dotHeight: 7,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.blue.withOpacity(0.4),
                  spacing: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
