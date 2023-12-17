//
//  day17.swift
//  aoc23
//
//  Created by Oliver Hofmann on 17.12.23.
//

import Foundation

public struct Day17Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let panel = createPanel(lines: puzzle)
        let start = Position(row: 0, col: 0)
        let destination = Position(row: panel.height-1, col: panel.width-1)
        let distance = bfs(panel: panel, start: start, destination: destination) ?? Int.max
        return String(distance)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        return ""
    }
    
    func createPanel(lines: [String]) -> Panel {
        return Panel(lines)
    }
    
    
    func bfs(panel: Panel, start: Position, destination: Position) -> Int? {
        var distances = [Movement: Int]()
        var predecessor = [Movement: Movement]()
        var frontier = Set<(Movement)>()
        let startMovement1 = Movement(pos:start, horizontal: true)
        let startMovement2 = Movement(pos:start, horizontal: false)
        distances[startMovement1] = 0
        distances[startMovement2] = 0
        frontier.insert(startMovement1)
        frontier.insert(startMovement2)
        while !frontier.isEmpty {
            let movement = frontier.sorted(by: {distances[$0]! < distances[$1]!}).first!
            frontier.remove(movement)
            if movement.pos == destination {
                var current: Movement? = movement
                var path = [Movement]()
                while let v = current {
                    path.append(v)
                    current = predecessor[v]
                }
                path = path.reversed()
                for mov in path {
                    print("\(mov): \(distances[mov]!)")
                }
                return distances[movement]!
            }
            for newMovement in panel.connected(to: movement ) {
                let lengthNewPath = distances[movement]! + panel.heatLoss(from: movement.pos, to: newMovement.pos)
                if distances[newMovement] ?? Int.max > lengthNewPath {
                    distances[newMovement] = lengthNewPath
                    predecessor[newMovement] = movement
                    frontier.insert(newMovement)
                }
            }
        }
        return nil;
    }
    
    
    struct Position: Hashable, CustomStringConvertible {
        let row: Int
        let col: Int
        
        var description: String {
            return "(\(row), \(col))"
        }
        
    }
    
    struct Movement: Hashable, CustomStringConvertible {
        let pos: Position
        let horizontal: Bool
        
        var description: String {
            let char = horizontal ? "-" : "|"
            return "\(pos) \(char)"
        }

    }
    

    struct Panel {
        
        let cells: [Position : Int]
        let height: Int
        let width: Int
        
        init(_ lines: [String]) {
            var result = [Position : Int]()
            var maxColCount = 0
            for (row, line) in lines.enumerated() {
                maxColCount = max(maxColCount, line.count)
                for (col, char) in line.enumerated() {
                    result[Position(row: row, col: col)] = Int(char.wholeNumberValue!)
                }
            }
            cells = result
            height = lines.filter { !$0.isEmpty } .count
            width = maxColCount
        }
        
        func connected(to movement: Movement) -> [Movement] {
            let vectors = movement.horizontal ? [(1, 0), (-1, 0)] : [(0, 1), (0, -1)]
            var result = [Movement]()
            for factor in 1...3 {
                for vec in vectors {
                    let newPos = Position(row: movement.pos.row + factor * vec.0, col: movement.pos.col + factor * vec.1)
                    if cells.keys.contains(newPos) {
                        result.append(Movement(pos:newPos, horizontal: !movement.horizontal))
                    }
                }
            }
            return result
        }
        
        func heatLoss(from: Position, to: Position) -> Int {
            
            if from.row < to.row {
                return (from.row+1...to.row).map { self[$0, from.col]! }.reduce(0, +)
            }
            
            if from.row > to.row {
                return (to.row..<from.row).map { self[$0, from.col]! }.reduce(0, +)
            }

            if from.col < to.col {
                return (from.col+1...to.col).map { self[from.row, $0]! }.reduce(0, +)
            }

            if from.col > to.col {
                return (to.col..<from.col).map { self[from.row, $0]! }.reduce(0, +)
            }
                        
            return 0
        }
        
        subscript(row: Int, col: Int) -> Int? {
            assert(row >= 0 && row < height, "row out of bound")
            assert(col >= 0 && col < width, "col out of bound")
            return cells[Position(row: row, col: col)]
        }
        
    }
    
    
    struct MinHeap {
        
        var movements = [Movement]()
        var distances : [Movement: Int]
        
        init(_ dis: [Movement: Int]) {
            distances = dis
        }
        
        var minElement: Movement? {
            return movements.first
        }
        
        mutating func removeFirst() throws -> Movement {
            if movements.isEmpty {
                throw AoCError.heapUnderrun
            }
            let result = movements.first!
            movements[0] = movements.last!
            movements.removeLast()
            minHeapify(index: 1)
            return result
        }
        
        mutating func minHeapify(index:Int) {
            let left = index * 2
            let right = index * 2 + 1
            
            var minIndex = index
            if left < movements.count && distanceOrMax(movements[left]) < distanceOrMax(movements[minIndex]) {
                minIndex = left
            }
            if right < movements.count && distanceOrMax(movements[right]) < distanceOrMax(movements[minIndex]) {
                minIndex = right
            }
            if minIndex != index {
                movements.swapAt(index, minIndex)
                minHeapify(index: minIndex)
            }
        }
        
        mutating func decreaseDistance(index: Int, newDistance: Int) throws {
            if distanceOrMax(movements[index]) < newDistance {
                throw AoCError.runtimeError("New distance larger than old distance")
            }
            distances[movements[index]] = newDistance
            var i = index
            repeat {
                if i <= 0 {
                    break
                }
                let parent = i / 2
                if distances[movements[i]]! >=  distances[movements[parent]]! {
                    break
                }
                movements.swapAt(i, parent)
                i = parent
            } while true
        }
        
        
        mutating func insert(movement: Movement, dist: Int) throws {
            movements.append(movement)
            try? decreaseDistance(index: movements.count-1, newDistance: dist)
        }

        
        func distanceOrMax( _ movement: Movement) -> Int {
            return distances[movement] ?? Int.max
        }
        
    }
}
    
