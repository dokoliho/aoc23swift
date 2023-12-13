//
//  day12.swift
//  aoc23
//
//  Created by Oliver Hofmann on 12.12.23.
//

import Foundation

public struct Day12Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
    }
    
    func solvePart1(puzzle: [String]) -> String {
        var sum = 0
        var count = 0
        for line in puzzle {
            if !line.isEmpty {
                let (pattern, group) = parseLine(line: line)
                sum += validSolutions(pattern: pattern, group: group).count
            }
            count += 1
            if count % 50 == 0 {
                print(count)
            }
        }
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        var sum = 0
        var count = 0
        for line in puzzle {
            if !line.isEmpty {
                let (pattern, group) = parseLine(line: line)
                let pattern2 = pattern + "?" + pattern + "?" + pattern + "?" + pattern + "?" + pattern
                let group2 = group + group + group + group + group
                sum += validSolutions(pattern: pattern2, group: group2).count
            }
            count += 1
            if count % 5 == 0 {
                print(count)
            }
        }
        return String(sum)
    }
    
    func grouping(_ line: String) -> [Int] {
        var result = [Int]()
        var currentCount = 0
        for c in line {
            if c == "#" {
                currentCount += 1
            } else {
                if currentCount > 0 {
                    result.append(currentCount)
                    currentCount = 0
                }
            }
        }
        if currentCount > 0 {
            result.append(currentCount)
        }
        return result
    }
    
    
    func validSolutions(pattern: String, group: [Int]) -> [String] {
        let part = pattern.components(separatedBy: "?")[0]
        var partGroup = grouping(part)
        if part.last == "#" {
            partGroup.removeLast()
        }
        if partGroup.count > group.count {
            return []
        }
        for (i, n) in partGroup.enumerated() {
            if n != group[i] { return [] }
        }
        if let range = pattern.range(of: "\\?", options: .regularExpression) {
            let s1  = pattern.replacingCharacters(in: range, with: "#")
            let s2  = pattern.replacingCharacters(in: range, with: ".")
            return validSolutions(pattern: s1, group: group) + validSolutions(pattern: s2, group: group)
        } else {
            return grouping(pattern) == group ? [pattern] : []
        }
    }
    
    
    func parseLine(line: String) -> (pattern: String, group: [Int]) {
        let pattern = line.components(separatedBy: " ")[0]
        let numbers = line.components(separatedBy: " ")[1]
        return (pattern: pattern, group: numbers.components(separatedBy: ",").compactMap({Int($0)}))
    }
    
    
    
}
