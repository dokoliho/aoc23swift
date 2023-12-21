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
        let (automata, _) = parse(lines: puzzle)
        let result = automata.reduce(arriving: Day19Solution.PartRange.startPartRange)
        return String(PartRange.combinations(ranges: result))
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
        
        func transition(arriving: PartRange) -> (PartRange?, PartRange?) {
            let range = arriving.rangeFor(index: operand)!
            switch operation {
            case "<":
                if range.upperBound < value {
                    return (arriving, nil)
                } else if range.lowerBound >= value {
                    return (nil, arriving)
                } else {
                    return (arriving.replace(index: operand, with: range.lowerBound...value-1),
                            arriving.replace(index: operand, with: value...range.upperBound))
                }
            case ">":
                if range.lowerBound > value {
                    return (arriving, nil)
                } else if range.upperBound <= value {
                    return (nil, arriving)
                } else {
                    return (arriving.replace(index: operand, with: value+1...range.upperBound),
                            arriving.replace(index: operand, with: range.lowerBound...value))
                }
            default:
                return (arriving, nil)
            }
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
            return node == "A"
        }

            
        func reduce(arriving: PartRange, node: String = "in", path: [String] = []) -> [PartRange] {
            if path.contains(node) || node == "R" { // circle or rejected
                return []
            }
            if node == "A" {
                return [arriving]
            }
            var current = arriving
            var result = [PartRange]()
            for rule in rules[node]! {
                let (accepted, rejected) = rule.condition.transition(arriving: current)
                if accepted != nil {
                    let finalAccepted = reduce(arriving: accepted!, node: rule.destination, path: path + [node])
                    result = result + finalAccepted
                }
                if rejected == nil {
                    break
                }
                current = rejected!
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
    
    
    struct PartRange {
                
        static let startPartRange = PartRange(x: (1...4000), m: (1...4000), a: (1...4000), s: (1...4000))
        
        let x : ClosedRange<Int>
        let m : ClosedRange<Int>
        let a : ClosedRange<Int>
        let s : ClosedRange<Int>
        
        
        var combinations: Int {
            return x.count * m.count * a.count * s.count
        }
        
        func rangeFor(index: Int) -> ClosedRange<Int>? {
            switch index {
            case 0:
                return x
            case 1:
                return m
            case 2:
                return a
            case 3:
                return s
            default:
                return nil
            }
        }
        
        func replace(index: Int, with range: ClosedRange<Int>) -> PartRange {
            let ranges = (0...3).map { $0 == index ? range : rangeFor(index: $0) }
            return PartRange(x:ranges[0]!, m:ranges[1]!, a:ranges[2]!, s:ranges[3]!)
        }
        
        
        static func combinations(ranges: [PartRange]) -> Int {
            return ranges.reduce(0, {a, c in a + c.combinations})
        }
    }

}
