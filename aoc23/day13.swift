//
//  day13.swift
//  aoc23
//
//  Created by Oliver Hofmann on 13.12.23.
//

import Foundation

public struct Day13Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let patterns = parsePuzzle(puzzle)
        let mirrorRows = patterns.compactMap { $0.mirrorLine() }
        let mirrorCols = patterns.map {$0.transpose()}.compactMap { $0.mirrorLine() }
        let sum = mirrorCols.reduce(0, +) + 100 * mirrorRows.reduce(0, +)
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        return ""
    }

    struct Pattern {
        let lines: [String]
        
        func mirrorLine() -> Int? {
            let sortedLines = lines.enumerated().sorted(by: {$0.element < $1.element})
            let sameLikePred = sortedLines.dropFirst().enumerated().filter { areTheyNeighbors(num1:$0.element.offset, num2: sortedLines[$0.offset].offset) && $0.element.element == sortedLines[$0.offset].element }
            let candidatesForMirrorLine = sameLikePred.map { sortedLines[$0.offset].offset }
            // print(candidatesForMirrorLine)
            for candidate in candidatesForMirrorLine {
                if checkLineCandidate(candidate) {
                    // print("Found \(candidate+1)")
                    return candidate + 1
                }
            }
            return nil
        }
    
        func areTheyNeighbors(num1: Int, num2: Int) -> Bool {
            return abs(num1 - num2) == 1
        }
        
        func checkLineCandidate(_ candidate: Int) -> Bool {
            var offset = 0
            repeat {
                if lines[candidate-offset] != lines[candidate+1+offset] {
                    return false
                }
                offset += 1
            }
            while candidate - offset >= 0 && candidate+1+offset < lines.count
            return true
        }
        
        func transpose() -> Pattern {
            var newLines = [String]()
            for i in 0..<lines[0].count {
                let chars = lines.map { $0[i] }
                newLines.append(String(chars))
            }
            return Pattern(lines: newLines)
        }
        
        
        func findNewMirrorLine() -> Int? {
            let oldMirrorLine = mirrorLine()
            for (i1, line1) in lines.enumerated() {
                for i2 in i1+1..<lines.count {
                    if let pos = differAtOnePos(s1: line1, s2: lines[i2]) {
                        var newLines = [String]()
                        for i3 in 0..<lines.count {
                            if i3 == i1 {
                                var chars = Array(lines[i3])
                                chars[pos] = chars[pos] == "#" ? "." : "#"
                                newLines.append(String(chars))
                            } else {
                                newLines.append(lines[i3])
                            }
                        }
                        let newPattern = Pattern(lines: newLines)
                        if let newMirrorLine = newPattern.mirrorLine() {
                            if oldMirrorLine != newMirrorLine {
                                return newMirrorLine
                            }
                        }
                    }
                }
            }
            return nil;
        }
        
        
        func differAtOnePos(s1: String, s2: String) -> Int? {
            if s1.count != s2.count {
                return nil
            }
            var result: Int? = nil
            for i in 0..<s1.count {
                if s1[i] != s2[i] {
                    if result != nil {
                        return nil // Second Difference!
                    }
                    result = i
                }
            }
            return result
        }

    }
    
    func parsePuzzle(_ puzzle: [String]) -> [Pattern] {
        var result = [Pattern]()
        var current = [String]()
        for line in puzzle {
            if line.isEmpty {
                if current.count > 0 {
                    result.append(Pattern(lines: current))
                    current.removeAll()
                }
            } else {
                current.append(line)
            }
        }
        if current.count > 0 {
            result.append(Pattern(lines: current))
        }
        return result
    }
    
    
    
}
