import Algorithms

func square<T: Numeric>(_ value: T) -> T {
  value * value
}

struct Point3D: Hashable {
  let x: Int
  let y: Int
  let z: Int
  
  func distanceSquared(to other: Point3D) -> Int {
    square(other.x - x) + square(other.y - y) + square(other.z - z)
  }
}

struct UnionFind {
  public private(set) var parents: [Int]
  public private(set) var sizes: [Int]
  
  init(size: Int) {
    self.parents = Array(0..<size)
    self.sizes = Array(repeating: 1, count: size)
  }
  
  mutating func find(_ x: Int) -> Int {
    var i = x
    
    while i != parents[i] {
      (i, parents[i]) = (parents[i], parents[parents[i]])
    }
    
    return i
  }
  
  mutating func union(_ x: Int, _ y: Int) {
    var i = find(x)
    var j = find(y)
    
    if i == j {
      return
    }
    
    if sizes[i] < sizes[j] {
      (i, j) = (j, i)
    }
    
    parents[j] = i
    sizes[i] += sizes[j]
  }
}

struct Day08: AdventDay {
  var data: String
  
  func loadPoints(from input: String) -> [Point3D] {
    input.split(separator: "\n").map { line in
      let coords = line.split(separator: ",").compactMap { Int($0) }
      return Point3D(x: coords[0], y: coords[1], z: coords[2])
    }
  }
  
  func getEdgesAscending(from points: [Point3D]) -> [(Point3D, Point3D)] {
    var edges: [(Point3D, Point3D)] = []
    
    for i in 0..<points.count {
      for j in (i + 1)..<points.count {
        edges.append((points[i], points[j]))
      }
    }
    
    edges.sort(by: { e1, e2 in
      let (a1, b1) = e1
      let (a2, b2) = e2
      
      return a1.distanceSquared(to: b1) < a2.distanceSquared(to: b2)
    })
    
    return edges
  }

  func part1() -> Int {
    let points = loadPoints(from: data)
    
    let ufIndices = points.enumerated().reduce(into: Dictionary<Point3D, Int>()) { dict, elem in
      let (i, pt) = elem
      dict[pt] = i
    }
    
    let edges = getEdgesAscending(from: points)
    var uf = UnionFind(size: points.count)
    
    for (a, b) in edges.prefix(1000) {
      let i = ufIndices[a]!
      let j = ufIndices[b]!
      
      if uf.find(i) != uf.find(j) {
        uf.union(i, j)
      }
    }
    
    return uf.sizes.max(count: 3).reduce(1, *)
  }

  func part2() -> Int {
    let points = loadPoints(from: data)
    
    let ufIndices = points.enumerated().reduce(into: Dictionary<Point3D, Int>()) { dict, elem in
      let (i, pt) = elem
      dict[pt] = i
    }
    
    let edges = getEdgesAscending(from: points)
    var uf = UnionFind(size: points.count)
    
    var lastTwoPoints: (Point3D, Point3D)? = nil
    
    for (a, b) in edges {
      let i = ufIndices[a]!
      let j = ufIndices[b]!
      
      if uf.find(i) != uf.find(j) {
        uf.union(i, j)
        lastTwoPoints = (a, b)
      }
    }
    
    return lastTwoPoints!.0.x * lastTwoPoints!.1.x
  }
}
