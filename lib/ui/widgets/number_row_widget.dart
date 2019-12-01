import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nonogram_solution/services/grid_service.dart';

class NumberRowWidget extends StatelessWidget {

  final bool horizontal;
  final double cellSize;
  final double numbersSize;
  final int index;
  final List<bool> locked;

  NumberRowWidget({
    @required this.horizontal,
    @required this.cellSize,
    @required this.numbersSize,
    @required this.index,
    @required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    List<int> numbers = horizontal
        ? GridService.sideNumbers[index]
        : GridService.topNumbers[index];

    List<Widget> children = [];
    for(int i=0; i<numbers.length; i++){
      children.add(
        Expanded(
          child: Center(
            child: AutoSizeText(numbers[i].toString(),
              style: TextStyle(
                fontSize: 18.0,
                color: locked[i] ? Colors.black : Colors.green,
              ),
              minFontSize: 12.0,
            ),
          ),
        )
      );
    }

    return Container(
      margin: horizontal ? new EdgeInsets.symmetric(vertical: 1.0) : new EdgeInsets.symmetric(horizontal: 1.0),
      height: horizontal ? cellSize - 2.0 : numbersSize*1.3,
      width: horizontal ? numbersSize : cellSize - 2.0,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: horizontal
        ? Row(
            children: children.isNotEmpty
              ? children.reversed.toList() : <Widget>[SizedBox()],
          )
        : Column(
            children: children.isNotEmpty
              ? children.reversed.toList() : <Widget>[SizedBox()],
          ),
    );
  }
}
