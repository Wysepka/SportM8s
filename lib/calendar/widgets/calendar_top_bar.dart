import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarTopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calendar" , style: Theme.of(context).textTheme.titleLarge,),
              Text("Discover & Join upcoming sport events" , style: Theme.of(context).textTheme.labelSmall,),
          ],),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*
            Card(
              child: IconButton(
                  onPressed: _searchButtonClicked,
                  icon: Icon(Icons.search)
              ),
            ),
             */
          ],
        )
      ],
    );
  }

  void _searchButtonClicked(){

  }
}