//
//  day08.swift
//  aoc23
//
//  Created by Oliver Hofmann on 08.12.23.
//

import Foundation


enum Day08Error: Error {
    case runtimeError(String)
}



public struct Day08Solution : DailySolution {

    func solvePart1(puzzle: [String]) -> String {
        let word = puzzle[0]
        let automata = parseAutomata(puzzlepart: puzzle[2...])
        var currentState = "AAA"
        var step = 0
        while currentState != "ZZZ" {
            let idx = step % word.count
            currentState = word[idx] == "L" ? automata[currentState]!.left : automata[currentState]!.right
            step += 1
        }
        return String(step)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        let word = puzzle[0]
        let automata = parseAutomata(puzzlepart: puzzle[2...])
        let stepSizes = startNodes(automata: automata).map { detectCycle(automata: automata, word: word, startNode: $0) }
        let result = stepSizes.reduce(1, { a, c in Day08Solution.kgV(v1: a, v2: c) } )
        return String(result)
    }
    
    func parseAutomata(puzzlepart:ArraySlice<String>) -> [String:(left: String, right: String)] {
        var result = [String:(String, String)]()
        // AAA = (BBB, BBB)
        let search = /^(?<state>[A-Z0-9]+) = \((?<left>[A-Z0-9]+), (?<right>[A-Z0-9]+)\)$/
        for line in puzzlepart {
            if let match = try? search.wholeMatch(in: line) {
                result[String(match.state)] = (left: String(match.left), right: String(match.right))
            }
        }
        return result
    }
    
    func startNodes(automata: [String:(left: String, right: String)]) -> [String] {
        return automata.keys.filter { state in state.last! == "A" }
    }
    
    func allEndNodes(nodes: [String]) -> Bool {
        return nodes.filter { state in state.last! != "Z" }.count == 0
    }

    
    func detectCycle(automata: [String:(left: String, right: String)], word: String, startNode: String) -> Int {
        var currentState = startNode
        var step = 0
        var hits = [Int]()
        while hits.count < 2 {
            let idx = step % word.count
            currentState = word[idx] == "L" ? automata[currentState]!.left : automata[currentState]!.right
            step += 1
            if currentState.last! == "Z" {
                hits.append(step)
            }
        }
        
        let stepSize = hits.dropFirst().enumerated().map { index, hit in
            return hit - hits[index]
        }
        return stepSize[0]
    }
    
    
    static func ggT(v1: Int, v2: Int) -> Int {
        let bigger = max(v1, v2)
        let smaller = min(v1, v2)
        return  bigger % smaller == 0 ? smaller : ggT(v1: smaller, v2: bigger % smaller)
    }
    
    
    static func kgV(v1: Int, v2: Int) -> Int {
        return  v1 * v2 / ggT(v1: v1, v2: v2)
    }

    
}


