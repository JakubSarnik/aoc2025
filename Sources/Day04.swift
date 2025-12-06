import Algorithms

struct Matrix<T> {
  let rows: Int
  let columns: Int
  private var elements: [T]
  
  init(repeating element: T, rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    elements = Array(repeating: element, count: rows * columns)
  }
  
  subscript(_ row: Int, _ column: Int) -> T {
    get {
      elements[row * rows + column]
    } set(value) {
      elements[row * rows + column] = value
    }
  }
  
  func isValid(row: Int, column: Int) -> Bool {
    row >= 0 && row < rows && column >= 0 && column < columns
  }
  
  func neighboourIndicesOf(row: Int, column: Int) -> [(Int, Int)] {
    var result: [(Int, Int)] = []
    
    for dr in -1...1 {
      for dc in -1...1 {
        if dr == 0 && dc == 0 {
          continue
        }
        
        let newRow = row + dr
        let newColumn = column + dc
        
        guard isValid(row: newRow, column: newColumn) else {
          continue
        }
        
        result.append((newRow, newColumn))
      }
    }
    
    return result
  }
}

struct Day04: AdventDay {
  var data: String
  
  func loadGrid(_ data: String) -> Matrix<Bool> {
    let rows = data.split(separator: "\n").map(Array.init)
    
    assert(!rows.isEmpty)
    
    let cols = rows.first!.count
    var grid = Matrix(repeating: false, rows: rows.count, columns: cols)
    
    for (row, chars) in zip(rows.indices, rows) {
      assert(chars.count == cols)
      
      for (col, char) in zip(chars.indices, chars) {
        if char == "@" {
          grid[row, col] = true
        }
      }
    }
    
    return grid
  }
  
  func part1() -> Int {
    let grid = loadGrid(data)
    var sum = 0
    
    for row in 0..<grid.rows {
      for col in 0..<grid.columns {
        guard grid[row, col] else {
          continue
        }
        
        var adjacentRolls = 0
        
        for (nr, nc) in grid.neighboourIndicesOf(row: row, column: col) {
          if grid[nr, nc] {
            adjacentRolls += 1
          }
        }
        
        if adjacentRolls < 4 {
          sum += 1
        }
      }
    }
    
    return sum
  }

  func part2() -> Int {
    var grid = loadGrid(data)
    var sum = 0
    var removed = true
    
    while removed {
      removed = false
      
      for row in 0..<grid.rows {
        for col in 0..<grid.columns {
          guard grid[row, col] else {
            continue
          }
          
          var adjacentRolls = 0
          
          for (nr, nc) in grid.neighboourIndicesOf(row: row, column: col) {
            if grid[nr, nc] {
              adjacentRolls += 1
            }
          }
          
          if adjacentRolls < 4 {
            sum += 1
            grid[row, col] = false
            removed = true
          }
        }
      }
    }
    
    return sum
  }
}
