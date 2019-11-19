enum CellState{
  open,
  closed,
  checked
}

class Cell{
  int x;
  int y;
  CellState cellState;

  Cell(this.x, this.y, this.cellState);
}

class GridService{

  static final gridSize = 10;
  static List<Cell> grid;
  static List<List<int>> topNumbers;
  static List<List<int>> sideNumbers;
  static int solvingStep;

  static void initializeGrid(){
    solvingStep = 0;

    grid = [];
    topNumbers = [];
    sideNumbers = [];

    for(int i=0; i<gridSize; i++) {
      topNumbers.add(List<int>());
      sideNumbers.add(List<int>());

      for (int j = 0; j < gridSize; j++) {
        grid.add(Cell(i, j, CellState.open));
      }
    }
  }

  static Cell getCell(int i, int j){
    return grid.where((cell) => cell.x == i && cell.y == j).first;
  }

  static void solve(){
    if(solvingStep < topNumbers.length) {
      testRow(topNumbers[solvingStep], solvingStep, false);
      solvingStep++;
    }
  }

  static void testRow(List<int> row, int index, bool horizontal) {
    List<List<Cell>> rowParts = getRowParts(index, horizontal);
    topNumbers[index].reversed.forEach((number){
      for(int i=0; i<rowParts.length; i++){
        if(number <= rowParts[i].length && number >= (rowParts[i].length/2).floor() + 1){
          fillCells(rowParts[i], number);
        }
      }
    });
  }

  static List<List<Cell>> getRowParts(int index, bool horizontal) {
    List<List<Cell>> result = [];

    List<Cell> part = [];
    for(int i=0; i<gridSize; i++){
      if(getCell(i, index).cellState == CellState.open) {
        part.add(getCell(i, index));
      }
      else{
        if(part.isNotEmpty){
          result.add(part);
          part = [];
        }
      }
    }
    if(part.isNotEmpty){
      result.add(part);
    }

    return result;
  }

  static void fillCells(List<Cell> cellsToFill, int number) {
    int dif = cellsToFill.length - number;
    switch(dif){
      case 0: cellsToFill.forEach((cell) => cell.cellState = CellState.checked); break;
      case 1: for(int i=1; i<cellsToFill.length-1; i++){
        cellsToFill[i].cellState = CellState.checked;
      } break;
      case 2: for(int i=2; i<cellsToFill.length-2; i++){
        cellsToFill[i].cellState = CellState.checked;
      } break;
      case 3: for(int i=3; i<cellsToFill.length-3; i++){
        cellsToFill[i].cellState = CellState.checked;
      } break;
      case 4: for(int i=4; i<cellsToFill.length-4; i++){
        cellsToFill[i].cellState = CellState.checked;
      } break;
    }
  }
}