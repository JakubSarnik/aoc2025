import Algorithms

struct Day02: AdventDay {
  var data: String

  func isInvalidPart1(_ num: Int) -> Bool {
    let digits = String(num).compactMap { Int(String($0)) }
    
    guard digits.count % 2 == 0 else {
      return false
    }
    
    for i in 0 ..< digits.count / 2 {
      if digits[i] != digits[digits.count / 2 + i] {
        return false
      }
    }
    
    return true
  }
  
  func isInvalidPart2(_ num: Int) -> Bool {
    let digits = String(num).compactMap { Int(String($0)) }
    
    for endpoint in 0 ..< digits.count / 2 {
      guard digits.count % (endpoint + 1) == 0 else {
        continue
      }
      
      let slice = digits[...endpoint]
      let numSlices = digits.count / slice.count
      
      if digits == Array(slice.cycled(times: numSlices)) {
        return true
      }
    }
    
    return false
  }
  
  func solve(isInvalid: (Int) -> Bool) -> Int {
    let ranges = data.trimmingSuffix(while: { $0 == "\n" }).split(separator: ",")
    var sum = 0
    
    for range in ranges {
      let endpoints = range.split(separator: "-").compactMap { Int($0) }
      
      for num in endpoints[0] ... endpoints[1] {
        if isInvalid(num) {
          sum += num
        }
      }
    }
    
    return sum
  }
  
  func part1() -> Int {
    solve(isInvalid: isInvalidPart1)
  }

  func part2() -> Int {
    solve(isInvalid: isInvalidPart2)
  }
}
