
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AggreementWidget extends StatelessWidget
{
  final String text;
  final bool useHtmlFormat;
  final VoidCallback onAggrementAppliedPressed;

  const AggreementWidget({
    Key? key,
    required this.text,
    required this.useHtmlFormat,
    required this.onAggrementAppliedPressed,
}) : super(key: key);

  Widget buildScrollableView_TextComponent(){
    return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Text(text , style: TextStyle(fontSize: 32),)
    );
  }

  Widget buildScrollableView_HTMLComponent(){
    return SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Html(data: text ,
        style: {
          "h2": Style(
            color: Colors.blue,
            fontSize: FontSize(24),
          ),
          "p": Style(
            fontSize: FontSize(16),
          ),
          "li": Style(
            margin: Margins.only(left: 16),
          ),}
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: [
          Expanded(
            child: buildScrollableView_TextComponent(),
            ),
          ElevatedButton(
              onPressed: onAggrementAppliedPressed.call,
              child: Text("Agree")
          )
        ],
      );
  }

}