//
//  day19.swift
//  aoc23//
//  Created by Oliver Hofmann on 19.12.23.
//

import Foundation

public struct Day19Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let (automata, parts) = parse(lines: puzzle)
        let sum =  parts.filter { automata.isAcceptable(part: $0)}.map { $0.sumValues}.reduce(0, +)
        return String(sum)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        let (automata, parts) = parse(lines: puzzle)
        let result = automata.reduce(arriving: Day19Solution.MultiRange.startPartRange)
        return String(MultiRange.combinations(result))
    }

    
    func parse(lines: [String]) -> (Automata, [Part]) {
        var automata = Automata()
        var parts = [Part]()
        var modeAutomata = true
        for line in lines {
            if line.isEmpty {
                modeAutomata = false
                continue
            }
            if modeAutomata {
                try? automata.addRule(line)
            } else {
                try? parts.append(Part(line))
            }
        }
        
        return (automata, parts)
    }
    
    struct MultiRange: CustomStringConvertible {
        
        var description: String {
            return ranges.sorted(by: { $0.lowerBound < $1.lowerBound }).map { "(" + String($0.lowerBound) + "..." + String($0.upperBound) + ")" }.joined(separator: ",")
        }
        
        static let emptyMultirange = MultiRange(ranges: [])
        static let emptyPartRange = [emptyMultirange, emptyMultirange, emptyMultirange, emptyMultirange]
        static let startMultirange = MultiRange(ranges: [(1...4000)])
        static let startPartRange = [startMultirange, startMultirange, startMultirange, startMultirange]
        
        var ranges = [ClosedRange<Int>]()
        
        var count: Int {
            return ranges.map { $0.upperBound - $0.lowerBound + 1  }.reduce(0, +)
        }
        
        
        static func combinations(_ multiranges: [MultiRange]) -> Int {
            return multiranges.map {$0.count }.reduce(1, *)
        }
        
        
        static func +=(lhs: inout MultiRange, rhs: MultiRange) {
            lhs = lhs + rhs
        }

        static func +(lhs: MultiRange, rhs: MultiRange) -> MultiRange {
            var result = lhs
            for addRange in rhs.ranges {
                if addRange.isEmpty {
                    continue
                }
                if !result.ranges.contains(addRange) {
                    result.ranges.append(addRange)
                }
            }
            result.ranges = mergeOverlappingRanges(result.ranges.sorted(by: { $0.lowerBound < $1.lowerBound}))
            return result
        }

        static func mergeOverlappingRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
            
            if ranges.count < 2 {
                return ranges
            }
            
            var result = [ClosedRange<Int>]()
            var currentRange = ranges[0]
            
            for i in 1..<ranges.count {
                let nextRange = ranges[i]
                
                if currentRange.upperBound + 1 < nextRange.lowerBound {
                    result.append(currentRange)
                    currentRange = nextRange
                } else {
                    currentRange = (currentRange.lowerBound...max(currentRange.upperBound, nextRange.upperBound))
                }
            }
            result.append(currentRange)
            return result
        }
        
        
    }
    
    struct Condition {
        let operand : Int           // x=0, m=1, a=2, s=3
        let operation : Character   // "<", ">", "*"
        let value : Int
        
        func eval(_ part: Part) -> Bool {
            switch operation {
            case "<":
                return part.values[operand] < value
            case ">":
                return part.values[operand] > value
            default:
                return true
            }
        }
        
        func transition(arriving: [MultiRange]) -> ([MultiRange], [MultiRange]) {
            var accepted = arriving
            var rejected = arriving
            var accept: MultiRange = MultiRange.emptyMultirange
            var reject: MultiRange = MultiRange.emptyMultirange
            for range in arriving[operand].ranges {
                switch operation {
                case "<":
                    if range.upperBound < value {
                        accept.ranges.append(range)
                    } else if range.lowerBound >= value {
                        reject.ranges.append(range)
                    } else {
                        accept.ranges.append(range.lowerBound...value-1)
                        reject.ranges.append(value...range.upperBound)
                    }
                case ">":
                    if range.lowerBound > value {
                        accept.ranges.append(range)
                    } else if range.upperBound <= value {
                        reject.ranges.append(range)
                    } else {
                        accept.ranges.append(value+1...range.upperBound)
                        reject.ranges.append(range.lowerBound...value)
                    }
                default:
                    accept.ranges.append(range)
                }
            }
            accepted[operand].ranges = MultiRange.mergeOverlappingRanges(accept.ranges)
            rejected[operand].ranges = MultiRange.mergeOverlappingRanges(reject.ranges)
            return (accepted, rejected)
        }
    }
    
    struct Rule {
        let condition: Condition
        let destination: String
        
        init(_ line: String) {
            //a<2006:qkq
            let search = /^(?<operand>.)(?<operation>[<,>])(?<value>\d+):(?<dest>.+)$/
            if let result = try? search.wholeMatch(in: line) {
                switch result.operand {
                case "x":
                    condition = Condition(operand: 0, operation: String(result.operation).first!, value: Int(result.value)!)
                case "m":
                    condition = Condition(operand: 1, operation: String(result.operation).first!, value: Int(result.value)!)
                case "a":
                    condition = Condition(operand: 2, operation: String(result.operation).first!, value: Int(result.value)!)
                case "s":
                    condition = Condition(operand: 3, operation: String(result.operation).first!, value: Int(result.value)!)
                default:
                    fatalError("Illegal Operand")
                }
                destination = String(result.dest)
            }
            else {
                condition = Condition(operand: 0, operation: "*", value: 0)
                destination = line
            }
        }
    }
    
    struct Automata {
        var rules = [String : [Rule] ]()
        
        mutating func addRule(_ line: String) throws {
            // px{a<2006:qkq,m>2090:A,rfg}
            let search = /^(?<name>.+)\{(?<ruleset>.+)\}$/
            if let result = try? search.wholeMatch(in: line) {
                rules[String(result.name)] = result.ruleset.components(separatedBy: ",").compactMap { Rule(String($0)) }
            }
            else {
                throw AoCError.parsingError("Not a valid Rule: \(line)")
            }
        }
        
        func isAcceptable(part: Part) -> Bool {
            var node = "in"
            let endNodes = Set<String>(["A", "R"])
            while !endNodes.contains(node) {
                for rule in rules[node]! {
                    if rule.condition.eval(part) {
                        node = rule.destination
                        break
                    }
                }
            }
            print(node, part.sumValues)
            return node == "A"
        }

        func reduce(arriving: [MultiRange], node: String = "in", path: [String] = []) -> [MultiRange] {
            if path.contains(node) || node == "R" { // circle or rejected
                return MultiRange.emptyPartRange
            }
            if node == "A" {
                return arriving
            }
            var current = arriving
            var result = MultiRange.emptyPartRange
            for rule in rules[node]! {
                let (accepted, rejected) = rule.condition.transition(arriving: current)
                let finalAccepted = reduce(arriving: accepted, node: rule.destination, path: path + [node])
                result = zip(result, finalAccepted).map {$0 + $1 }
                
                current = rejected
            }
            return result
        }
    }
    
    struct Part {

        let values : [Int]  // x=0, m=1, a=2, s=3
        
        init(_ line: String) throws {
            // {x=787,m=2655,a=1222,s=2876}
            let search = /^\{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)\}$/
            if let result = try? search.wholeMatch(in: line) {
                values = [Int(result.x)!, Int(result.m)!, Int(result.a)!, Int(result.s)!]
            }
            else {
                throw AoCError.parsingError("Not a valid part: \(line)")
            }
        }
        
        var sumValues : Int {
            return values.reduce(0, +)
        }
    }
    
    
}
