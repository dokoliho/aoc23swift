//
//  day15.swift
//  aoc23
//
//  Created by Oliver Hofmann on 15.12.23.
//

import Foundation

public struct Day15Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
    }
    
    
    func solvePart1(puzzle: [String]) -> String {
        return String(sumHashSequence(puzzle[0]))
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        let instructions = puzzle[0].components(separatedBy: ",").compactMap { try? Instruction(instruction: $0) }
        var boxes = [Box](repeating: Box(), count: 256)
        for instruction in instructions {
            let box = hash(instruction.label)
            if instruction.op == "=" {
                let lens = Lens(focalLength: instruction.focal, label: instruction.label)
                boxes[box].add(lens: lens)
            }
            if instruction.op == "-" {
                boxes[box].remove(label: instruction.label)
            }
        }
        let sum = boxes.enumerated().map { $0.element.power * ($0.offset+1) }.reduce(0, +)
        return String(sum)
    }
    
    
    func hash(_ s: String) -> Int {
        var currentValue = 0
        for char in s {
            if let ascii = char.asciiValue {
                currentValue += Int(ascii)
                currentValue += currentValue << 4
                currentValue %= 256
            }
        }
        return currentValue
    }
    
    func sumHashSequence(_ s: String) -> Int {
        return s.components(separatedBy: ",").map { hash($0) }.reduce(0, +)
    }
    
    class Lens {
        let focalLength: Int
        let label: String
        var next: Lens?
        weak var previous: Lens?
        
        init(focalLength: Int, label: String, next: Lens? = nil, previous: Lens? = nil) {
            self.focalLength = focalLength
            self.label = label
            self.next = next
            self.previous = previous
        }
        
    }
    
    struct Box {
        var firstLens: Lens? = nil
        var lastLens: Lens? = nil
        var labels = [String : Lens]()
        
        mutating func remove(label: String) {
            if let lens = labels[label] {
                if let prevLens = lens.previous {
                    prevLens.next = lens.next
                } else {
                    firstLens = lens.next
                }
                labels.removeValue(forKey: lens.label)
                if let nextLens = lens.next {
                    nextLens.previous = lens.previous
                } else {
                    lastLens = lens.previous
                }
                
            }
        }
        
        mutating func add(lens: Lens) {
            if let oldLens = labels[lens.label] {
                lens.previous = oldLens.previous
                if let prevLens = oldLens.previous {
                    prevLens.next = lens
                } else {
                    firstLens = lens
                }
                lens.next = oldLens.next
                if let nextLens = oldLens.next {
                    nextLens.previous = lens
                } else {
                    lastLens = lens
                }
            } else {
                if lastLens == nil {
                    firstLens = lens
                    lastLens = lens
                } else {
                    lastLens!.next = lens
                    lens.previous = lastLens!
                    lastLens = lens
                }
            }
            labels[lens.label] = lens
        }
        
        
        var power: Int {
            var result = 0
            var current = firstLens
            var index = 1
            while current != nil {
                result += index * current!.focalLength
                index += 1
                current = current!.next
            }
            return result
        }
        
        
    }
    
    
    struct Instruction {
        let label: String
        let op: Character
        let focal: Int
        
        
        // "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7",
        init(instruction: String) throws {
            let search = /^(?<label>[a-z]+)(?<op>[-=])(?<focal>\d*)$/
            if let result = try? search.wholeMatch(in: instruction) {
                label = String(result.label)
                op = String(result.op).first!
                focal = Int(result.focal) ?? 0
            }
            else {
                throw AoCError.parsingError(instruction)
            }
        }
    }
        
    
}
