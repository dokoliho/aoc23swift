//
//  day14.swift
//  aoc23
//
//  Created by Oliver Hofmann on 14.12.23.
//

import Foundation

public struct Day14Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
    }
    
    func solvePart1(puzzle: [String]) -> String {
        var field = Map(puzzle)
        field.tilt()
        return String(field.load)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        var field = Map(puzzle)
        var history = [Int: (Int, Map)]()
        var i = 0
        let target = 1000000000
        while i < target {
            i += 1
            field.tiltCircle()
            let currentLoad = field.load
            if let (step, oldField) = history[currentLoad] {
                if oldField == field {
                    let cycleLen = i - step
                    let remaining = target - i
                    i = target - remaining % cycleLen
                    history.removeAll()

                }
            } else {
                history[currentLoad] = (i, field)
            }
        }
        return String(field.load)
    }
    
    
    // Repräsentation eines einzlnen Steins
    
    struct Rock {
        var row: Int
        var col: Int
        let movable: Bool
    }

    
    // Repräsentation der gesamten Karte
    
    struct Map: CustomStringConvertible, Equatable {
        
        static func == (lhs: Day14Solution.Map, rhs: Day14Solution.Map) -> Bool {
            if lhs.rocks.count != rhs.rocks.count {
                return  false
            }
            let r1 = lhs.rocks.sorted(by: {$0.row * 100 + $0.col < $1.row * 100 + $1.col} )
            let r2 = rhs.rocks.sorted(by: {$0.row * 100 + $0.col < $1.row * 100 + $1.col} )
            
            for i in 0..<r1.count {
                if r1[i].col != r2[i].col || r1[i].row != r2[i].row || r1[i].movable != r2[i].movable {
                    return false
                }
            }
            return true
        }
        
        var rocks = [(Rock)]()
        var height: Int = 0
        var width: Int = 0
        
        init(_ puzzle: [String]) {
            let lines = puzzle.filter { !$0.isEmpty }
            height = lines.count
            width = lines.first!.count
            for (row, line) in lines.enumerated() {
                for (col, char) in line.enumerated() {
                    if char == "O" {
                        rocks.append(Rock(row: row, col: col, movable: true))
                    }
                    if char == "#" {
                        rocks.append(Rock(row: row, col: col, movable: false))
                    }
                }
            }
        }

        
        // Das gesamte Feld als ausgabefähiger String
        var description: String {
            var result = ""
            for row in 0..<height {
                var chars = [Character]()
                for col in 0..<width {
                    var foundRock: Rock? = nil
                    for rock in rocks {
                        if rock.row == row && rock.col == col {
                            foundRock = rock
                            break;
                        }
                    }
                    chars.append(foundRock == nil ? "." : (foundRock!.movable ? "O" : "#"))
                }
                chars.append("\n")
                result.append(String(chars))
            }
            return result
        }

        
        func column(_ col: Int) -> [Rock] {
            rocks.filter { $0.col == col }.sorted(by: {$0.row < $1.row})
        }
        
        
        // Das gesamte Feld nach Norden tilten
        mutating func tilt()  {
            var newRocks = [Rock]()
            for col in 0..<width {
                let rocksInColumn = tiltedColumn(col)
                newRocks += rocksInColumn
            }
            rocks = newRocks
        }

        
        // Viermal nach Norden tilten und im Uhrzeigersinn drehen
        // = Tilt nach Norden, Westen, Süden, Osten
        mutating func tiltCircle() {
            for _ in 1...4 {
                var newRocks = [Rock]()
                for col in 0..<width {
                    let rocksInColumn = tiltedColumn(col)
                    let transposed = rocksInColumn.map{ Rock(row: $0.col , col: height - $0.row - 1, movable: $0.movable)}
                    newRocks += transposed
                }
                rocks = newRocks
                (height, width) = (width, height)
            }
        }
        
        
        // Alle beweglichen Steine einer Spalte nach Norden verschieben
        func tiltedColumn(_ col: Int) -> [Rock] {
            var rocksInColumn = column(col)
            var bottom = 0
            for index in 0..<rocksInColumn.count {
                if rocksInColumn[index].movable {
                    rocksInColumn[index].row = bottom
                }
                bottom = max(bottom, rocksInColumn[index].row+1)
            }
            return rocksInColumn
        }

                
        var load: Int {
            var sum = 0
            for col in 0..<width {
                sum += column(col).map{ loadOfRock($0)}.reduce(0, +)
            }
            return sum
        }
        
        func loadOfRock(_ r:Rock) -> Int {
            if r.movable {
                return height - r.row
            }
            return 0
        }
    }
      
}
