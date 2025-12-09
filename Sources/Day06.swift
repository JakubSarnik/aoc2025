import Algorithms

struct Day06: AdventDay {
  var data: String
  
  func transpose<T>(_ array: [[T]]) -> [[T]] {
    guard !array.isEmpty else {
      return []
    }
    
    var result: [[T]] = []
    
    for j in array.first!.indices {
      var column : [T] = []
      
      for i in array.indices {
        column.append(array[i][j])
      }
      
      result.append(column)
    }
    
    return result
  }

  func part1() -> Int {
    let lines = data.split(separator: "\n")
    let cells = lines.dropLast().map { $0.split(separator: " ").map { Int($0)! } }
    let ops: [(Int, (Int, Int) -> Int)] = lines.last!.split(separator: " ").map { $0 == "+" ? (0, +) : (1, *) }
    
    return transpose(cells).enumerated().map { (i, line) in
      let (initial, op) = ops[i]
      return line.reduce(initial, op)
    }.reduce(0, +)
  }

  func part2() -> Int {
    let lines = data.split(separator: "\n")
    let chars: [[Character]] = lines.dropLast().map { Array($0) }
    let ops: [(Int, (Int, Int) -> Int)] = lines.last!.split(separator: " ").map { $0 == "+" ? (0, +) : (1, *) }
    
    return transpose(chars).map { String($0) }.map { $0.trimmingCharacters(in: .whitespaces) }
      .split(separator: "").map { $0.compactMap(Int.init) }.enumerated().map { (i, line) in
        let (initial, op) = ops[i]
        return line.reduce(initial, op)
      }.reduce(0, +)
  }
}
