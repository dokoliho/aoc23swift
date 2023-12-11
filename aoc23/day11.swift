//
//  day11.swift
//  aoc23
//
//  Created by Oliver Hofmann on 11.12.23.
//

import Foundation

public struct Day11Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let galaxies = parseGalaxies(lines: puzzle)
        let sum = sumDistances(galaxies: galaxies)
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        let galaxies = parseGalaxies(lines: puzzle, factor: 1000000)
        let sum = sumDistances(galaxies: galaxies)
        return String(sum)
    }
    
    func parseGalaxies(lines: [String], factor: Int = 2) -> [(Int,Int)] {
        let scanLines = lines.filter {!$0.isEmpty}
        var galaxies = [(Int, Int)]()
        var rowOffset = 0
        var colOffsets = [Int]()
        for (row, line) in scanLines.enumerated() {
            if !line.contains("#") {
                rowOffset += 1
                continue
            }
            for (col, c) in line.enumerated() {
                if row == 0 {
                    let colLine = scanLines.compactMap { $0[col] }
                    if !colLine.contains("#") {
                        colOffsets.append(col)
                    }
                }
                if colOffsets.contains(col) {
                    continue
                }
                if c == "#" {
                    let colOffset = colOffsets.filter({ $0 < col}).count
                    let correctedRow = row + rowOffset*factor - rowOffset
                    let correctedCol = col + colOffset*factor - colOffset
                    galaxies.append((correctedRow, correctedCol))
                }
            }
        }
        return galaxies
    }
    
    func sumDistances(galaxies: [(Int, Int)]) -> Int {
        if galaxies.count < 2 {
            return 0
        }
        let first = galaxies.first!
        let remaining = Array(galaxies.dropFirst())
        let sum = remaining.reduce(0, {a, c in a + abs(first.0 - c.0) + abs(first.1 - c.1)})
        return sum + sumDistances(galaxies: remaining)
    }
    
}
