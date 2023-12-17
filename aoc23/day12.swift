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
        Day12Solution.cache.removeAll()
        for line in puzzle {
            if !line.isEmpty {
                let (pattern, groups) = parseLine(line: line)
                sum += countArrangements(pattern: pattern, groups: groups)
            }
        }
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        var sum = 0
        Day12Solution.cache.removeAll()
        for line in puzzle {
            if !line.isEmpty {
                let (pattern, groups) = parseLine(line: line)
                let newPattern =  Array(repeating: String(pattern), count: 5).joined(separator: "?")
                let newGroups = Array(repeating: groups, count: 5).flatMap { $0 }
                sum += countArrangements(pattern: newPattern, groups: newGroups)
            }
        }
        return String(sum)
    }

    
    static var cache = [String: Int]()
    
    func countArrangements(pattern: String, groups: [Int]) -> Int {
        
        let key = pattern + ":" + groups.map {  String($0) }.joined(separator: ":")
        if  let result = Day12Solution.cache[key] {
            return result
        }
        
        if pattern.isEmpty {                                // Keine Mustervorgabe mehr...
            return groups.count == 0 ? 1 : 0                // geht nur, wenn keine Gruppen mehr kommen
        }
        
        if groups.count == 0 {                              // Keine Gruppen mehr...
            return pattern.contains("#") ? 0 : 1            // geht nur, wenn im Restpattern kein # vorkommt
        }
        
        var result = 0
        
        if ".?".contains(pattern.first!) {                  // Falls das nächste Zeichen im Pattern potenziel ein Trenner
            result += countArrangements(pattern: String(pattern.dropFirst()), groups: groups)
        }
        
        if let firstChar = pattern.first, "#?".contains(firstChar) {                // Falls potenziel ein Block beginnt
            if groups.first! <= pattern.count,                                      // genug Zeichen übrig?
               !pattern.prefix(groups.first!).contains("."),                        // Kein Trenner in Sicht
               (groups.first! == pattern.count || pattern[groups.first!] != "#") {  // Danach kommt aber ein Trenner
                let remainingGroups = Array(groups.dropFirst())                     // Zeichen und Gruppe entfernen
                result += countArrangements(pattern: String(pattern.dropFirst(groups.first! + 1)), groups: remainingGroups)
            }
        }

        Day12Solution.cache[key] = result
        
        return result
    }
    
    
    func parseLine(line: String) -> (pattern: String, group: [Int]) {
        let pattern = line.components(separatedBy: " ")[0]
        let numbers = line.components(separatedBy: " ")[1]
        return (pattern: pattern, group: numbers.components(separatedBy: ",").compactMap({Int($0)}))
    }
    
    
    
}
