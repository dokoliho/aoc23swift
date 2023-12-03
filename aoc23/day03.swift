//
//  day03.swift
//  aoc23
//
//  Created by Oliver Hofmann on 03.12.23.
//

import Foundation

public struct Day03Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        var parser = NumberParser(puzzle)
        var sum = 0
        var number : Int?
        repeat {
            let symbolAttached : Bool
            (number, symbolAttached) = parser.nextNumber()
            if symbolAttached {
                sum += number ?? 0
            }
        } while (number != nil)
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String{
        var parser = NumberParser(puzzle)
        var number : Int?
        repeat {
            (number, _) = parser.nextNumber()
        } while (number != nil)
        return String(parser.sumOfGearRatios())
    }
    
}


extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}

struct Position: Hashable {
    let row: Int
    let col: Int
}


struct NumberParser {
    
    var position = Position(row:0, col:0)
    var processing = ""
    var star_positions: Set<(Position)> = []
    var numbersAttachedToStar: [Position:[Int]] = [:]
    var attachedSymbolFound = false
    let engine : [String]
    
    init(_ schematic: [String]) {
        engine = schematic
    }
    
    mutating func nextNumber() -> (Int?, Bool) {
        if position.row >= engine.count {
            return (nil, false)
        }
        if position.col >= engine[position.row].count || !engine[position.row][position.col].isNumber {
            step()
            if !processing.isEmpty {
                let value = Int(processing)
                let valid = attachedSymbolFound
                processing = ""
                attachedSymbolFound = false
                if valid {
                    for star_position in star_positions {
                        if var numbers = numbersAttachedToStar[star_position] {
                            numbers.append(value ?? 0)
                            numbersAttachedToStar[star_position] = numbers
                        } else {
                            numbersAttachedToStar[star_position] = [value ?? 0]
                        }
                    }
                }
                star_positions = []
                return (value, valid)
            }
            return nextNumber()
        }
        processing.append(engine[position.row][position.col])
        attachedSymbolFound = attachedSymbolFound || isSymbolArround()
        step()
        return nextNumber()
    }
    
    mutating func step() {
        if position.row >= engine.count {
            return
        }
        if position.col >= engine[position.row].count {
            position = Position(row: position.row+1, col: 0)
            return
        }
        position = Position(row: position.row, col: position.col+1)
    }
    
    mutating func isSymbolArround() -> Bool {
        for r in position.row-1...position.row+1 {
            for c in position.col-1...position.col+1 {
                if isSymbol(at: Position(row: r, col: c)) {
                    return true
                }
            }
        }
        return false
    }
    
    mutating func isSymbol(at position: Position) -> Bool {
        if position.row<0 || position.row >= engine.count {
            return false
        }
        if position.col<0 || position.col >= engine[position.row].count {
            return false
        }
        if engine[position.row][position.col].isNumber {
            return false
        }
        if engine[position.row][position.col] == "." {
            return false
        }
        if engine[position.row][position.col] == "*"  {
            star_positions.insert(position)
        }
        return true
    }
    
    func sumOfGearRatios() -> Int {
        var sum = 0
        for (_, attachedNumbers) in numbersAttachedToStar {
            if attachedNumbers.count == 2 {
                sum += attachedNumbers[0]*attachedNumbers[1]
            }
        }
        return sum
    }
    
}
