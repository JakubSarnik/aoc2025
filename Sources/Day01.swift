import Algorithms

struct Day01: AdventDay {
  var data: String
  
  func divmod(a: Int, b: Int) -> (Int, Int) {
    let r = (a % b + b) % b
    let q = (a - r) / b
    
    return (q, r)
  }

  func part1() -> Int {
    var position = 50
    var res = 0
    
    data.enumerateLines { line, _ in
      let direction = line.first!
      var amount = Int(line.suffix(from: line.index(line.startIndex, offsetBy: 1)))!
      
      if (direction == "L") {
        amount *= -1
      }
      
      let (_, r) = divmod(a: position + amount, b: 100)
      
      res += r == 0 ? 1 : 0
      position = r
    }
    
    return res
  }

  func part2() -> Int {
    var position = 50
    var res = 0
    
    data.enumerateLines { line, _ in
      let direction = line.first!
      var amount = Int(line.suffix(from: line.index(line.startIndex, offsetBy: 1)))!
      
      if (direction == "L") {
        amount *= -1
      }
      
      let (q, r) = divmod(a: position + amount, b: 100)
      
      res += q < 0 ? -q : q
      position = r
    }
    
    return res
  }
}
