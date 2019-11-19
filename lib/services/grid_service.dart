enum CellState{
  open,
  closed,
  checked
}

class GridService{

  static final gridSize = 10;
  static List<List<CellState>> grid;
  static List<List<int>> topNumbers;
  static List<List<int>> sideNumbers;
  static int solvingStep = 0;

  static initializeGrid(){
    grid = [];
    topNumbers = [];
    sideNumbers = [];

    for(int i=0; i<gridSize; i++) {
      grid.add(List<CellState>());
      topNumbers.add(List<int>());
      sideNumbers.add(List<int>());

      for (int j = 0; j < gridSize; j++) {
        grid[i].add(CellState.open);
      }
    }
  }


}