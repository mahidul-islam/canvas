import 'package:canvas/clock.dart';
import 'package:canvas/draggable_widget.dart';
import 'package:canvas/generate_image.dart';
import 'package:canvas/rotatable_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PagerWidget extends StatefulWidget {
  const PagerWidget({Key? key}) : super(key: key);

  @override
  _PagerWidgetState createState() => _PagerWidgetState();
}

class _PagerWidgetState extends State<PagerWidget> {
  late PageController _controller;

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
            children: [
              CustomPainterDraggable(),
              CustomPainterRotatble(),
              ClockPage(),
              ImageGenerator(),
            ],
          ),
          Positioned(
            bottom: 32,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(
                  dotWidth: 7,
                  dotHeight: 7,
                  activeDotColor: Colors.blue,
                  dotColor: Colors.blue.withOpacity(0.4),
                  spacing: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
