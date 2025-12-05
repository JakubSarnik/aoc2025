import Algorithms

struct Day03: AdventDay {
  var data: String
  
  func lineToArray(_ line: Substring) -> Array<Int> {
    line.map { Int(String($0))! }
  }
  
  func getMaxJoltage1(_ line: Array<Int>) -> Int {
    var ix: Int? = nil
    var digit = 9
    
    while ix == nil || ix == line.count - 1 {
      ix = line.firstIndex(of: digit)
      digit -= 1
      assert(digit >= 0)
    }
    
    let secondDigit = line[(ix! + 1)...].max()!
    return Int("\(digit + 1)\(secondDigit)")!
  }
  
  func getMaxJoltage2(_ line: Array<Int>) -> Int {
    // Dynamic programming it is I guess...
    
    // maximums[i][j] is the maximum joltage which can be formed using
    // i digits from elements in line[..<j]
    var maximums: [[Int]] = Array(repeating: Array(repeating: 0, count: line.count + 1), count: 13)
    
    for i in 1...12 {
      for j in 1...line.count {
        maximums[i][j] = max(maximums[i][j - 1], maximums[i - 1][j - 1] * 10 + line[j - 1])
      }
    }
    
    return maximums[12].max()!
  }
  
  func solve(_ getMaxJoltage: (Array<Int>) -> Int) -> Int {
    data.split(separator: "\n").map(lineToArray).map(getMaxJoltage).reduce(0, +)
  }
  
  func part1() -> Int {
    solve(getMaxJoltage1)
  }

  func part2() -> Int {
    solve(getMaxJoltage2)
  }
}
