import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWidget extends StatefulWidget {
  const MarkdownWidget({Key? key}) : super(key: key);

  @override
  _MarkdownWidgetState createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  String? markDown;

  @override
  void initState() {
    loadMarkDown();
    super.initState();
  }

  void loadMarkDown() async {
    markDown = await rootBundle.loadString('assets/Nutrition.md', cache: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width > 400
            ? 400
            : MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          bottom: 120,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 70, bottom: 50, left: 16, right: 16),
            child: MarkdownBody(data: markDown ?? ''),
          ),
        ),
      ),
    );
  }
}
