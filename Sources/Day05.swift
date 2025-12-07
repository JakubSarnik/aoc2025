import Algorithms

struct Input {
  let ranges: [(Int, Int)]
  let ids: [Int]
  
  func inRange(id: Int) -> Bool {
    ranges.contains(where: { (lo, hi) in lo <= id && id <= hi })
  }
}

struct Day05: AdventDay {
  var data: String
  
  func loadInput(_ input: String) -> Input {
    let parts = data.split(separator: "\n", omittingEmptySubsequences: false).split(separator: "")
  
    var ranges: [(Int, Int)] = []
    
    for line in parts[0] {
      let endpoints = line.split(separator: "-").map { Int($0)! }
      ranges.append((endpoints[0], endpoints[1]))
    }
    
    let ids = parts[1].map { Int($0)! }
    
    return Input(ranges: ranges, ids: ids)
  }
  
  func merge(ranges: [(Int, Int)]) -> [(Int, Int)] {
    let sorted = ranges.sorted(by: { $0.0 < $1.0 })
    
    assert(!sorted.isEmpty)
    
    var mergedLo = sorted[0].0
    var mergedHi = sorted[0].1
    
    var merged: [(Int, Int)] = []
    
    for (lo, hi) in sorted.dropFirst() {
      if lo > mergedHi {
        merged.append((mergedLo, mergedHi))
        
        mergedLo = lo
        mergedHi = hi
      }
      else if hi > mergedHi {
        mergedHi = hi
      }
    }
    
    merged.append((mergedLo, mergedHi))
    
    return merged
  }

  func part1() -> Int {
    let input = loadInput(data)
    
    var count = 0
    
    for id in input.ids {
      if input.inRange(id: id) {
        count += 1
      }
    }
    
    return count
  }

  func part2() -> Int {
    let input = loadInput(data)
    let mergedRanges = merge(ranges: input.ranges)
    
    var sum = 0
    
    for (lo, hi) in mergedRanges {
      sum += hi - lo + 1
    }
    
    return sum
  }
}
