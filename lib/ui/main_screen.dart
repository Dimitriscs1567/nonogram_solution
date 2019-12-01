import 'package:flutter/material.dart';
import 'package:nonogram_solution/services/grid_service.dart';
import 'package:nonogram_solution/ui/widgets/number_row_widget.dart';
import 'package:nonogram_solution/ui/widgets/table_widget.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<bool>> _sidesLocked;
  List<List<bool>> _topsLocked;

  @override
  void initState() {
    _reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double numbersSize = MediaQuery.of(context).size.width / 6.0;
    double cellSize = ((MediaQuery.of(context).size.width - numbersSize) / 10.0) - 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text("Nonogram Solution"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(right: 3.0, left: 3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.yellow,
              child: Text("Reset"),
              onPressed: (){
                setState(() {
                  _reset();
                });
              },
            ),
            Padding(padding: new EdgeInsets.all(15.0),),
            topNumbers(cellSize, numbersSize),
            Row(
              children: <Widget>[
                sideNumbers(cellSize, numbersSize),
                TableWidget(cellSize: cellSize)
              ],
            ),
            Padding(padding: new EdgeInsets.all(15.0),),
            RaisedButton(
              color: Colors.green,
              child: Text("Solve - Step ${GridService.solvingStep+1}"),
              onPressed: (){
                setState(() {
                  GridService.solve();
                });
              },
            ),
          ],
        ),
      ),
    );
  }



  Widget sideNumbers(double cellSize, double numbersSize) {
    List<Widget> children = [];
    for(int i=0; i<GridService.gridSize; i++){
      children.add(_numbersWidget(numbersSize, cellSize, true, i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget topNumbers(double cellSize, double numbersSize) {
    List<Widget> children = [];
    for(int i=0; i<GridService.gridSize; i++){
      children.add(_numbersWidget(numbersSize, cellSize, false, i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: children,
    );
  }

  Widget _numbersWidget(double numbersSize, double cellSize, bool horizontal, int index){
    return GestureDetector(
      onTap: (){
        if(GridService.solvingStep == 0) {
          setState(() {
            if (horizontal) {
              if ((_sidesLocked[index].length < 4 || !_sidesLocked[index].last)
                  && !equalsMax(index, horizontal)) {
                if (GridService.sideNumbers[index].isEmpty ||
                    _sidesLocked[index].last) {
                  _sidesLocked[index].add(false);
                  GridService.sideNumbers[index].add(1);
                }
                else {
                  GridService.sideNumbers[index].last++;
                }
              }
            }
            else {
              if ((_topsLocked[index].length < 4 || !_topsLocked[index].last)
                  && !equalsMax(index, horizontal)) {
                if (GridService.topNumbers[index].isEmpty ||
                    _topsLocked[index].last) {
                  _topsLocked[index].add(false);
                  GridService.topNumbers[index].add(1);
                }
                else {
                  GridService.topNumbers[index].last++;
                }
              }
            }
          });
        }
      },
      onLongPress: (){
        if(GridService.solvingStep == 0) {
          setState(() {
            if (horizontal) {
              if (_sidesLocked[index].isNotEmpty)
                _sidesLocked[index].last = true;
            }
            else {
              if (_topsLocked[index].isNotEmpty)
                _topsLocked[index].last = true;
            }
          });
        }
      },
      child: NumberRowWidget(
        horizontal: horizontal,
        numbersSize: numbersSize,
        cellSize: cellSize,
        index: index,
        locked: horizontal ? _sidesLocked[index] : _topsLocked[index],
      ),
    );
  }

  void _reset(){
    GridService.initializeGrid();

    _sidesLocked = [];
    _topsLocked = [];

    for(int i=0; i<GridService.gridSize; i++) {
      _sidesLocked.add(List<bool>());
      _topsLocked.add(List<bool>());
    }
  }

  bool equalsMax(int index, bool horizontal) {
    int sum = 0;

    List<int> numbers = horizontal
      ? GridService.sideNumbers[index]
      : GridService.topNumbers[index];

    numbers.forEach((number){
      sum += number + 1;
    });

    sum--;

    if(sum > 0 && sum == GridService.gridSize) {
      if (horizontal && !_sidesLocked[index].last) {
        _sidesLocked[index].last = true;
      }
      else if (!horizontal && !_topsLocked[index].last) {
        _topsLocked[index].last = true;
      }

      return true;
    }

    return false;
  }
}
