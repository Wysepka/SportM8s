import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapEventTopPanel extends StatelessWidget{
  final Function() _onDismissCreateEventTap;
  final String panelName;

  MapEventTopPanel(this._onDismissCreateEventTap , this.panelName );

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Material(
          elevation: 2,
          color: colorScheme.surface,
          shadowColor: colorScheme.shadow,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(
                horizontal: 10
            ),
            decoration: BoxDecoration(
              /*
                      boxShadow:[ BoxShadow(
                        color: Colors.white.withOpacity(0.5), // shadow color
                        blurRadius: 4,                         // softens the shadow
                        spreadRadius: 4,                       // extends the shadow
                        offset: Offset(1, 2),                  // moves shadow right & down
                      ),],

                       */
                borderRadius:BorderRadius.circular(16),
                border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1
                )
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Align(
                  //widthFactor: 0.1,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: "Back",
                    icon: Icon(Icons.keyboard_return),
                    onPressed: _onDismissCreateEventTap,
                    color: colorScheme.surfaceContainerHighest,

                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: const CircleBorder(),
                    ),
                  )
                    /*
                    label: Text(
                      '',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),),

                     */
                    //TODO add localisation
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 56,
                  ),
                  child: Text(
                    panelName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}