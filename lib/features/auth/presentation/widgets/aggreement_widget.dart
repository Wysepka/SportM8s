import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AggreementWidget extends StatefulWidget
{
  final String text;
  final String consentTextKey;
  final Map<String, Style> textHtmlStyles;
  final bool useHtmlFormat;
  final VoidCallback onAggrementAppliedPressed;

  const AggreementWidget({
    super.key,
    required this.text,
    required this.consentTextKey,
    required this.useHtmlFormat,
    required this.onAggrementAppliedPressed,
    required this.textHtmlStyles,
});

  @override
  State<StatefulWidget> createState() => _AggreementWidgetState();
}

class _AggreementWidgetState extends State<AggreementWidget> {

  bool _hasScrolledToBottom = false;
  bool _hasClickedCheckbox = false;
  bool _isCheckboxOn = false;

  Widget buildScrollableView_TextComponent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Text(widget.text, style: TextStyle(fontSize: 32),)
    );
  }

  Widget buildScrollableView_HTMLComponent() {
    return NotificationListener(
      onNotification: _handleScrollNotification,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Html(
          data: widget.text,
          style: widget.textHtmlStyles!
        ),
      )
    );
  }

  bool _handleScrollNotification(ScrollNotification notification){
    if(notification is ScrollEndNotification){
      final metrics = notification.metrics;
      if(metrics.pixels >= metrics.maxScrollExtent){
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.useHtmlFormat 
            ? buildScrollableView_HTMLComponent() 
            : buildScrollableView_TextComponent(),
        ),
        Row(
          children: [
            Row(
              children: [
                Text(widget.consentTextKey),
                Checkbox(value: _hasClickedCheckbox, onChanged: _hasScrolledToBottom ? OnChangedCheckbox : null),
              ]
            ),
            Expanded(child:
                Center(child:
                  ElevatedButton(
                    onPressed: _hasScrolledToBottom && _hasClickedCheckbox ? widget.onAggrementAppliedPressed : null,
                    child: Text("Agree")
                  )
              )
            )
          ]
        )
      ],
    );
  }

  void OnChangedCheckbox(bool? hasChecked)
  {
    setState(() {
      _hasClickedCheckbox = hasChecked ?? false;
    });
  }
}