//
//  day16.swift
//  aoc23
//
//  Created by Oliver Hofmann on 16.12.23.
//

import Foundation

public struct Day16Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let panel = Panel(puzzle)
        let start = (Position(row:0, col:-1), Direction.right)
        return String(panel.countEnergizedTiles(startBeam: start))        
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        let panel = Panel(puzzle)
        var maxEnergized = 0
        for row in 0..<panel.height {
            let fromLeft = (Position(row: row, col:-1), Direction.right)
            maxEnergized = max(maxEnergized, panel.countEnergizedTiles(startBeam: fromLeft))
            let fromRight = (Position(row: row, col:panel.height), Direction.left)
            maxEnergized = max(maxEnergized, panel.countEnergizedTiles(startBeam: fromRight))
            print("Row \(row): max = \(maxEnergized)")
        }
        for col in 0..<panel.width {
            let fromTop = (Position(row: -1, col:col), Direction.down)
            maxEnergized = max(maxEnergized, panel.countEnergizedTiles(startBeam: fromTop))
            let fromBottom = (Position(row: panel.height, col:col), Direction.up)
            maxEnergized = max(maxEnergized, panel.countEnergizedTiles(startBeam: fromBottom))
            print("col \(col): max = \(maxEnergized)")
        }

        return String(maxEnergized)
    }
    
    
    
    
    func createPanel(lines: [String]) -> Panel {
        return Panel(lines)
    }
    
    struct Position: Hashable {
        let row: Int
        let col: Int
    }
    
    enum Direction: Int, CaseIterable {
        case up = 0
        case left = 1
        case down = 2
        case right = 3
    }
    
    class Cell {
        let kind: Character
        var activeBeamDirections:Set<Direction> = []
        var energizedCount = 0
        
        init(kind char: Character) {
            kind = char
        }
        
        
        func resultingBeamDirections(hittingBeamDirection: Direction) -> [Direction] {
            var result: Set<Direction> = []
            let dirCount = Direction.allCases.count
            switch kind {
            case "|":
                if hittingBeamDirection.rawValue % 2 == 0  {
                    result.insert(hittingBeamDirection)
                } else {
                    result.insert(Direction.up)
                    result.insert(Direction.down)
                }
            case "-":
                if hittingBeamDirection.rawValue % 2 == 1  {
                    result.insert(hittingBeamDirection)
                } else {
                    result.insert(Direction.left)
                    result.insert(Direction.right)
                }
            case "/":
                let destination = dirCount - hittingBeamDirection.rawValue - 1
                result.insert(Direction(rawValue: destination)!)
            case "\\":
                let destination = 
                    hittingBeamDirection == Direction.up ? Direction.left :
                    hittingBeamDirection == Direction.right ? Direction.down :
                    hittingBeamDirection == Direction.down ? Direction.right : Direction.up
                result.insert(destination)
            default:
                result = []
            }
            result.subtract(activeBeamDirections)
            activeBeamDirections = activeBeamDirections.union(result)
            energizedCount += 1
            return Array(result)
        }
        
        func off() {
            energizedCount = 0
            activeBeamDirections = []
        }
    }
    
    struct Panel {
        
        let cells: [Position : Cell]
        let height: Int
        let width: Int

        init(_ lines: [String]) {
            var result = [Position : Cell]()
            var maxColCount = 0
            for (row, line) in lines.enumerated() {
                maxColCount = max(maxColCount, line.count)
                for (col, char) in line.enumerated() {
                    if char != "." {
                        result[Position(row: row, col: col)] = Cell(kind: char)
                    }
                }
            }
            cells = result
            height = lines.filter { !$0.isEmpty } .count
            width = maxColCount
        }
        
        func positions(from: Position, to: Position) -> [Position] {
            var result = Set<Position>()
            let rowStart = max(0, min(from.row, to.row))
            let rowEnd = min(height - 1, max(from.row, to.row))
            let colStart = max(0, min(from.col, to.col))
            let colEnd = min(width - 1, max(from.col, to.col))
            
            for row in rowStart...rowEnd {
                result.insert(Position(row: row, col: colStart))
            }
            for col in colStart...colEnd {
                result.insert(Position(row: rowStart, col: col))
            }
            return Array(result)
        }
            
                                                
        
        func beamEndsAt(starting: Position, heading: Direction) -> Position {
            var positions = Array(cells.keys)
            switch (heading) {
            case Direction.up:
                positions = positions.filter { $0.col == starting.col && $0.row < starting.row }
                    .sorted(by: { $0.row > $1.row })
                if let position = positions.first {
                    return position
                }
                return Position(row: -1, col: starting.col)
            case Direction.left:
                positions = positions.filter { $0.row == starting.row && $0.col < starting.col }
                    .sorted(by: { $0.col > $1.col })
                if let position = positions.first {
                    return position
                }
                return Position(row: starting.row, col: -1)
            case Direction.down:
                positions = positions.filter { $0.col == starting.col && $0.row > starting.row }
                    .sorted(by: { $0.row < $1.row })
                if let position = positions.first {
                    return position
                }
                return Position(row: height, col: starting.col)
            case Direction.right:
                positions = positions.filter { $0.row == starting.row && $0.col > starting.col }
                    .sorted(by: { $0.col < $1.col })
                if let position = positions.first {
                    return position
                }
                return Position(row: starting.row, col: width)
            }
        }
        
        
        func countEnergizedTiles(startBeam: (Position, Direction)) -> Int {
            var beams = [startBeam]
            resetCells()
            var energizedTiles = Set<Position>()
            while !beams.isEmpty {
                let (beamStart, beamDirection) = beams.removeFirst()
                let beamEnd = beamEndsAt(starting: beamStart, heading: beamDirection)
                if let startingCell = cells[beamEnd] {
                    let dirs = startingCell.resultingBeamDirections(hittingBeamDirection: beamDirection)
                    let resultingBeams = dirs.map { (beamEnd, $0) }
                    beams.append(contentsOf: resultingBeams)
                }
                energizedTiles = energizedTiles.union(positions(from: beamStart, to: beamEnd))
            }
            return energizedTiles.count
        }
        
        func resetCells() {
            for (_, cell) in cells {
                cell.off()
            }
        }
    }
    
}
