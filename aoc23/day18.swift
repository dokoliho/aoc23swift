//
//  day18.swift
//  aoc23
//
//  Created by Oliver Hofmann on 18.12.23.
//

import Foundation

public struct Day18Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let panel = createPanel(lines: puzzle)
        return String(panel.area)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        let puzzle2 = puzzle.map { convertLine(line: $0)}
        let panel = createPanel(lines: puzzle2)
        return String(panel.area)
    }
    
    
    func createPanel(lines: [String]) -> Panel {
        return Panel(lines: lines)
    }
    
    
    func convertLine(line: String) -> String {
        let dirs = ["R", "D", "L", "U"]
        if !line.isEmpty {
            let parts = line.components(separatedBy: " ")
            // (#70c710)
            let search = /^\(#(?<hex>.{5})(?<dir>.)\)$/
            if let result = try? search.wholeMatch(in: parts[2]) {
                let steps = Int(result.hex, radix: 16)!
                let dir = dirs[Int(result.dir)!]
                return "\(dir) \(steps) (#000000)"
            }
        }
        return ""
    }
    
    
    // Gauss'sche Berechnungsformel für den Flächeninhalt eines Polygons
    static func shoelace(_ positions: [Position]) -> Int {
        var succ = positions.dropFirst()
        succ.append(positions.first!)
        var sum = 0
        for (p1, p2) in zip(positions, succ) {
            sum += (p1.row+p2.row)*(p1.col-p2.col)
        }
        return sum / 2
    }
        
    struct Position: Hashable {
        let row: Int
        let col: Int
    }
  
    
    struct Panel {
        
        var nodes: [Position] = []
        var perimeter = 0

        init(lines: [String]) {
            var diggerPosition = Position(row:0, col:0)
            nodes = [diggerPosition]
            for line in lines.filter({ !$0.isEmpty }) {
                let (direction, steps) = parse(line)
                diggerPosition = move(from: diggerPosition, inDirection: direction, forSteps: steps)
                nodes.append(diggerPosition)
                perimeter += steps
            }
            assert(nodes.first == nodes.last, "Loop not closed")
        }

        fileprivate func move( from position: Position, inDirection direction: String, forSteps steps: Int) -> Position {
            switch direction {
            case "D":
                return Position(row: position.row+steps, col: position.col)
            case "U":
                return Position(row: position.row-steps, col: position.col)
            case "R":
                return Position(row: position.row, col: position.col+steps)
            case "L":
                return Position(row: position.row, col: position.col-steps)
            default:
                fatalError("Should never be executed")
            }
        }
        
        fileprivate func parse(_ line: String) -> (String, Int) {
            let parts = line.components(separatedBy: " ")
            let dir = parts[0]
            let steps = Int(parts[1])!
            return (dir, steps)
        }
        
        var area: Int {
            return Day18Solution.shoelace(nodes.dropLast()) + perimeter/2 + 1
        }
        
        
    }
    
}
