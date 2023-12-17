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
        let panel = createPanel(lines: puzzle)
        let start = Position(row: 0, col: 0)
        let destination = Position(row: panel.height-1, col: panel.width-1)
        let distance = bfs(panel: panel, start: start, destination: destination, range: (4...10)) ?? Int.max
        return String(distance)
    }
    
    func createPanel(lines: [String]) -> Panel {
        return Panel(lines)
    }
    
    
    func bfs(panel: Panel, start: Position, destination: Position, range: ClosedRange<Int> = (1...3)) -> Int? {
        var predecessor = [Movement: Movement]()
        
        var heap = MinHeap()
        
        let startMovement1 = Movement(pos:start, horizontal: true)
        let startMovement2 = Movement(pos:start, horizontal: false)

        heap.insertOrUpdate(movement: startMovement1, dist: 0)
        heap.insertOrUpdate(movement: startMovement2, dist: 0)

        while !heap.isEmpty {
            let movement = heap.removeFirst()!
            if movement.pos == destination {
                return heap.distances[movement]!
            }
            for newMovement in panel.connected(to: movement, range: range ) {
                let lengthNewPath = heap.distances[movement]! + panel.heatLoss(from: movement.pos, to: newMovement.pos)
                if heap.distanceOrMax(newMovement) > lengthNewPath {
                    heap.insertOrUpdate(movement: newMovement, dist: lengthNewPath)
                    predecessor[newMovement] = movement
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
        
        func connected(to movement: Movement, range: ClosedRange<Int> = (1...3)) -> [Movement] {
            let vectors = movement.horizontal ? [(1, 0), (-1, 0)] : [(0, 1), (0, -1)]
            var result = [Movement]()
            for factor in range {
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
        var distances = [Movement: Int]()
        var indices = [Movement: Int]()
        
        var minElement: Movement? {
            return movements.first
        }
        
        var isEmpty: Bool {
            return movements.isEmpty
        }
        
        mutating func removeFirst() -> Movement? {
            if movements.isEmpty {
                return nil
            }
            let result = movements.first!
            indices.removeValue(forKey: result)
            movements[0] = movements.last!
            movements.removeLast()
            indices[movements[0]] = 1
            minHeapify(index: 1)
            return result
        }
        
        mutating func minHeapify(index:Int) {
            let left = index * 2
            let right = index * 2 + 1
            
            var minIndex = index
            if left < movements.count && distanceOrMax(movements[left-1]) < distanceOrMax(movements[minIndex-1]) {
                minIndex = left
            }
            if right < movements.count && distanceOrMax(movements[right-1]) < distanceOrMax(movements[minIndex-1]) {
                minIndex = right
            }
            if minIndex != index {
                indices[movements[index-1]] = minIndex
                indices[movements[minIndex-1]] = index
                movements.swapAt(index-1, minIndex-1)
                minHeapify(index: minIndex)
            }
        }
        
        mutating func decreaseDistance(index: Int, newDistance: Int) throws {
            if distanceOrMax(movements[index-1]) < newDistance {
                throw AoCError.runtimeError("New distance larger than old distance")
            }
            distances[movements[index-1]] = newDistance
            var i = index
            repeat {
                if i <= 1 {
                    break
                }
                let parent = i / 2
                if distances[movements[i-1]]! >=  distances[movements[parent-1]]! {
                    break
                }
                indices[movements[i-1]] = parent
                indices[movements[parent-1]] = i
                movements.swapAt(i-1, parent-1)
                i = parent
            } while true
        }
        
        
        mutating func insertOrUpdate(movement: Movement, dist: Int)  {
            if let index = indices[movement] {
                try? decreaseDistance(index: index, newDistance: dist)
            } else {
                movements.append(movement)
                indices[movement] = movements.count
                try? decreaseDistance(index: movements.count, newDistance: dist)
            }
        }

        
        func distanceOrMax( _ movement: Movement) -> Int {
            return distances[movement] ?? Int.max
        }
        
    }
}
    
