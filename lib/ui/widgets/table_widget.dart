import 'package:flutter/material.dart';
import 'package:nonogram_solution/services/grid_service.dart';

class TableWidget extends StatelessWidget {

  final double cellSize;

  TableWidget({@required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Table(
          children: _createTableRows(setState),
          defaultColumnWidth: FixedColumnWidth(cellSize),
          border: TableBorder(
            top: BorderSide(width: 2.0),
            bottom: BorderSide(width: 2.0),
            right: BorderSide(width: 2.0),
            left: BorderSide(width: 2.0),
            horizontalInside: BorderSide(color: Colors.grey[400]),
            verticalInside: BorderSide(color: Colors.grey[400]),
          ),
        );
      }
    );
  }

  List<TableRow> _createTableRows(StateSetter setState) {
    List<TableRow> tableRows = [];

    for(int i=0; i<GridService.gridSize; i++){
      List<Widget> cells = [];

      for(int j=0; j<GridService.gridSize; j++){
        Border border;

        if(i == GridService.gridSize/2 - 1 && j == GridService.gridSize/2 - 1){
          border = Border(
            bottom: BorderSide(width: 2.0),
            right: BorderSide(width: 2.0),
          );
        }
        else if(i == GridService.gridSize/2 - 1){
          border = Border(
            bottom: BorderSide(width: 2.0),
          );
        }
        else if(j == GridService.gridSize/2 - 1){
          border = Border(
            right: BorderSide(width: 2.0),
          );
        }
        cells.add(
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: border != null ? border : Border(),
                color: _getColor(GridService.getCell(i, j).cellState),
              ),
              height: cellSize,
            ),
            onTap: (){
              if(GridService.solvingStep == 0) {
                setState(() {
                  if (GridService.getCell(i, j).cellState == CellState.open)
                    GridService.getCell(i, j).cellState = CellState.closed;
                  else
                    GridService.getCell(i, j).cellState = CellState.open;
                });
              }
            },
          )
        );
      }

      tableRows.add(TableRow(
          children: cells
      ));
    }

    return tableRows;
  }

  Color _getColor(CellState cellState) {
    switch(cellState){
      case CellState.open: return Colors.white;
      case CellState.closed: return Colors.red;
      case CellState.checked: return Colors.green;
    }
  }
}
