import 'package:flutter/material.dart';

enum CellState{
  open,
  closed,
  checked
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<List<CellState>> _grid;
  List<List<int>> _topNumbers;
  List<List<int>> _sideNumbers;
  List<TableRow> _tableRows;
  List<List<bool>> _sidesLocked;
  List<List<bool>> _topsLocked;
  final _gridSize = 10;
  int solvingStep = 0;

  @override
  void initState() {
    _reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double numbersSize = MediaQuery.of(context).size.width / 6.0;
    double cellSize = ((MediaQuery.of(context).size.width - numbersSize) / 10.0) - 0.6;

    _createTableRows(cellSize);

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
                Table(
                  children: _tableRows,
                  defaultColumnWidth: FixedColumnWidth(cellSize),
                  border: TableBorder(
                    top: BorderSide(width: 2.0),
                    bottom: BorderSide(width: 2.0),
                    right: BorderSide(width: 2.0),
                    left: BorderSide(width: 2.0),
                    horizontalInside: BorderSide(color: Colors.grey[400]),
                    verticalInside: BorderSide(color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
            Padding(padding: new EdgeInsets.all(15.0),),
            RaisedButton(
              color: Colors.green,
              child: Text("Solve - Step ${solvingStep+1}"),
              onPressed: (){

              },
            ),
          ],
        ),
      ),
    );
  }

  void _createTableRows(double cellSize) {
    _tableRows = [];

    for(int i=0; i<_gridSize; i++){
      List<Widget> cells = [];

      for(int j=0; j<_gridSize; j++){
        if(i == _gridSize/2 - 1 && j == _gridSize/2 - 1){
          cells.add(Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0),
                right: BorderSide(width: 2.0),
              ),
            ),
            height: cellSize,
          ));
        }
        else if(i == _gridSize/2 - 1){
          cells.add(Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0),
              ),
            ),
            height: cellSize,
          ));
        }
        else if(j == _gridSize/2 - 1){
          cells.add(Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 2.0),
              ),
            ),
            height: cellSize,
          ));
        }
        else {
          cells.add(Container(
            height: cellSize,
          ));
        }
      }

      _tableRows.add(TableRow(
        children: cells
      ));
    }
  }

  Widget sideNumbers(double cellSize, double numbersSize) {
    List<Widget> children = [];
    for(int i=0; i<_gridSize; i++){
      children.add(_numbersWidget(numbersSize, cellSize, true, i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget topNumbers(double cellSize, double numbersSize) {
    List<Widget> children = [];
    for(int i=0; i<_gridSize; i++){
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
        setState(() {
          if(horizontal) {
            if (_sidesLocked[index].length < 4 || !_sidesLocked[index].last) {
              if (_sideNumbers[index].isEmpty || _sidesLocked[index].last) {
                _sidesLocked[index].add(false);
                _sideNumbers[index].add(1);
              }
              else {
                _sideNumbers[index].last++;
              }
            }
          }
          else{
            if (_topsLocked[index].length < 4 || !_topsLocked[index].last) {
              if (_topNumbers[index].isEmpty || _topsLocked[index].last) {
                _topsLocked[index].add(false);
                _topNumbers[index].add(1);
              }
              else {
                _topNumbers[index].last++;
              }
            }
          }
        });
      },
      onLongPress: (){
        if(horizontal) {
          if (_sidesLocked[index].isNotEmpty)
            _sidesLocked[index].last = true;
        }
        else{
          if (_topsLocked[index].isNotEmpty)
            _topsLocked[index].last = true;
        }
      },
      child: Container(
        margin: horizontal ? new EdgeInsets.symmetric(vertical: 1.0) : new EdgeInsets.symmetric(horizontal: 1.0),
        height: horizontal ? cellSize - 2.0 : numbersSize*1.3,
        width: horizontal ? numbersSize : cellSize - 2.0,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _sideNumbers[index].isNotEmpty ? _sideNumbers[index].map((number){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(number.toString(),
                  style: TextStyle(fontSize: 17.0),
                ),
              );
            }).toList().reversed.toList() : <Widget>[SizedBox()],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _topNumbers[index].isNotEmpty ? _topNumbers[index].map((number){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(number.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
              );
            }).toList().reversed.toList() : <Widget>[SizedBox()],
          ),
      ),
    );
  }

  void _reset(){
    _topNumbers = [];
    _sideNumbers = [];
    _sidesLocked = [];
    _topsLocked = [];
    _grid = [];

    for(int i=0; i<_gridSize; i++) {
      _grid.add(List<CellState>());
      _topNumbers.add(List<int>());
      _sideNumbers.add(List<int>());
      _sidesLocked.add(List<bool>());
      _topsLocked.add(List<bool>());
      for (int j = 0; j < _gridSize; j++) {
        _grid[i].add(CellState.open);
      }
    }
  }
}
