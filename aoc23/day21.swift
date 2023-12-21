//
//  day21.swift
//  aoc23
//
//  Created by Oliver Hofmann on 21.12.23.
//

import Foundation

public struct Day21Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    
    func solvePart1(puzzle: [String]) -> String {
        let steps = 64
        var panel = Panel()
        let start = panel.parse(lines: puzzle)
        var _ = panel.steps(toGo: steps, activePositions: [start])
        let indices: [Int] = Array(0...steps).filter{ $0 % 2 == steps % 2}
        let sum = indices.map { panel.reached[$0]!.count }.reduce(0, +)
        return String(sum)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        return ""
    }
    
    
    
    
    struct Position : Hashable {
        let row: Int
        let col: Int
    }
    
    
    struct Panel {
        var positions = [ Position : Int ]()
        var height = 0
        var width = 0
        var reached : [ Int : [Position]]  = [:]
        var flagPart2 = false
        
        mutating func parse(lines: [String]) -> Position
        {
            var start = Position(row: -1, col: -1)
            let content = lines.filter{ !$0.isEmpty }
            height = content.count
            width = content[0].count
            for (row, line) in content.enumerated() {
                for (col, char) in line.enumerated() {
                    if char == "S" {
                        start = Position(row: row, col: col)
                        positions[start] = 0
                        reached[0] = [start]
                    }
                    if char == "#" {
                        positions[Position(row: row, col: col)] = -1
                    }
                }
            }
            return start
        }
        
        
        mutating func steps(toGo count: Int, activePositions: [Position], currentStep: Int = 1) -> [Position] {
            if count == 0 {
                return activePositions
            }
            var newPositions = [Position]()
            for pos in activePositions {
                for vec in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
                    let newPos = Position(row: pos.row + vec.0, col: pos.col + vec.1)
                    if isValid(position: newPos) {
                        newPositions.append(newPos)
                        positions[newPos] = currentStep
                    }
                }
            }
            reached[currentStep] = newPositions
            return steps(toGo: (count-1), activePositions: newPositions, currentStep: (currentStep+1) )
        }

        
        func isValid(position: Position) -> Bool {
            if !flagPart2 {
                if position.row < 0 && position.row >= height {
                    return false
                }
                if position.col < 0 && position.col >= width {
                    return false
                }
                return !positions.keys.contains(position)
            } else {
                let col = position.col >= 0 ? position.col % width : position.col % width + width
                let row = position.row >= 0 ? position.row % height : position.row % height + height
                if let value = positions[Position(row: row, col: col)] {
                    if value == -1 {
                        return false
                    }
                }
                return !positions.keys.contains(position)
            }
        }
        
    }
    
    
    
}
