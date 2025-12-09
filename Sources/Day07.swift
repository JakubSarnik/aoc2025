import Algorithms

enum Cell {
  case empty, beam, splitter, outside
}

struct Point: Hashable {
  let row: Int
  let column: Int
}

func +(lhs: Point, rhs: (Int, Int)) -> Point {
  Point(row: lhs.row + rhs.0, column: lhs.column + rhs.1)
}

struct Manifold {
  let origin: Point
  let rows: Int
  let columns: Int
  var cells: [Point: Cell]
  
  subscript(_ point: Point) -> Cell {
    get {
      isInside(point: point) ? cells[point, default: .empty] : .outside
    } set(value) {
      if isInside(point: point) {
        cells[point] = value
      }
    }
  }
  
  func isInside(point: Point) -> Bool {
    return 0 <= point.row && point.row < rows && 0 <= point.column && point.column < columns
  }
}

struct Day07: AdventDay {
  var data: String
  
  func loadManifold(from input: String) -> Manifold {
    assert(!input.isEmpty)
    
    let chars: [[Character]] = input.split(separator: "\n").map { Array($0) }
    var cells: Dictionary<Point, Cell> = [:]
    var origin: Point? = nil
    let rows = chars.count
    let cols = chars.first!.count
    
    for (row, rowChars) in chars.enumerated() {
      for (column, char) in rowChars.enumerated() {
        let point = Point(row: row, column: column)
        
        if (char == "S") {
          origin = point
        } else if (char == "^") {
          cells[point] = .splitter
        }
      }
    }
    
    return Manifold(origin: origin!, rows: rows, columns: cols, cells: cells)
  }

  func part1() -> Int {
    var manifold = loadManifold(from: data)
    
    // The level array contains points on which we are to place the beam
    // in the current iteration.
    var level = [manifold.origin]
    var nextLevel: [Point] = []
    
    var splits = 0
    
    while !level.isEmpty {
      nextLevel.removeAll()
      
      for beamPoint in level {
        guard (manifold[beamPoint] == .empty) else {
          continue
        }
        
        manifold[beamPoint] = .beam
        
        let below = beamPoint + (1, 0)
        
        if manifold[below] == .splitter {
          nextLevel.append(beamPoint + (1, -1))
          nextLevel.append(beamPoint + (1, +1))
          
          splits += 1
        } else {
          nextLevel.append(below)
        }
      }
      
      level = nextLevel
    }
    
    return splits
  }

  func part2() -> Int {
    var manifold = loadManifold(from: data)
    
    var pathCounts: [Point: Int] = [:]
    
    func dfs(from beamPoint: Point) -> Int {
      if pathCounts[beamPoint] != nil {
        return pathCounts[beamPoint]!
      }
      
      guard (manifold[beamPoint] == .empty) else {
        return 0
      }
      
      manifold[beamPoint] = .beam
      
      let below = beamPoint + (1, 0)
      
      let paths = switch manifold[below] {
      case .beam:
        pathCounts[below]!
      case .empty:
        dfs(from: below)
      case .outside:
        1
      case .splitter:
        dfs(from: beamPoint + (1, -1)) + dfs(from: beamPoint + (1, +1))
      }

      pathCounts[beamPoint] = paths
      return paths
    }
    
    return dfs(from: manifold.origin)
  }
}
