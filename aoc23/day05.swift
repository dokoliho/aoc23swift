//
//  day05.swift
//  aoc23
//
//  Created by Oliver Hofmann on 05.12.23.
//

import Foundation

public struct Day05Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        let parser = SeedMapParser(puzzle: puzzle)
        let locations = parser.seeds.compactMap {parser.transform($0)}
        let closestLocation = locations.min() ?? 0
        return String(closestLocation)
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let parser = SeedMapParser(puzzle: puzzle)
        var ranges: [ClosedRange<Int>] = []
        for i in stride(from: 0, to: parser.seeds.count, by: 2) {
            ranges.append(parser.seeds[i]...parser.seeds[i]+parser.seeds[i+1]-1)
        }
        return String(lowestValue(in: parser.transformRanges(ranges)))
    }
}


public func lowestValue(in ranges:  [ClosedRange<Int>]) -> Int {
    let lowerbounds = ranges.map {$0.lowerBound}
    return lowerbounds.min() ?? Int.max
}



struct SeedMapParser {

    let seeds: [Int]
    var transformers: [SeedMapTransformer] = []
    
    init(puzzle: [String]) {
        seeds = puzzle[0].components(separatedBy: ":")[1].components(separatedBy: " ").compactMap {Int($0)}
        var currentIndex = 3
        var currentTransformer = SeedMapTransformer()
        while currentIndex < puzzle.count {
            while !puzzle[currentIndex].isEmpty {
                currentTransformer.addEntry(line: puzzle[currentIndex])
                currentIndex += 1
            }
            transformers.append(currentTransformer)
            currentIndex += 2
            currentTransformer = SeedMapTransformer()
        }
    }
    
    func transform(_ value: Int) -> Int {
        var result = value
        for transformer in transformers {
            result = transformer.transform(result)
        }
        return result
    }
    
    
    func transformRanges(_ value: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var result = value
        for transformer in transformers {
            result = transformer.transformRanges(result)
            print("****")
            for range in result {
//                print("  \(range.lowerBound)...\(range.upperBound)")
                print("  \(range.lowerBound) \(range.count)")

            }
        }
        return result
    }
    
}


struct SeedMapTransformer {
        
    var mapentry: [(range: ClosedRange<Int>, shift: Int)] = []
    
    mutating func addEntry(line: String) {
        let values = (line.components(separatedBy: " ").compactMap {Int($0)})
        let sourceRange = values[1]...values[1]+values[2]-1
        let offset = values[0] - values[1]
        mapentry.append((range: sourceRange, shift: offset))
    }
    
    func transform( _ value: Int) -> Int {
        for entry in mapentry {
            if entry.range.contains(value) {
                return value + entry.shift
            }
        }
        return value
    }
    
    
    func transformRanges(_ value: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var untransformedRanges = mergeRanges(value)
        var transformedRanges: [ClosedRange<Int>] = []
        for entry in mapentry {
            let (untransformed, transformed) = processMapEntry(entry, untransformedRanges)
            untransformedRanges = mergeRanges(untransformed)
            transformedRanges += transformed
        }
        return mergeRanges(untransformedRanges + transformedRanges)
    }


    private func processMapEntry(_ entry: (range: ClosedRange<Int>, shift: Int),
                                 _ ranges: [ClosedRange<Int>]) -> ([ClosedRange<Int>], [ClosedRange<Int>]) {
        var transformedRanges: [ClosedRange<Int>] = []
        var untransformedRanges = ranges
        var remainingRanges: [ClosedRange<Int>] = []

        while !untransformedRanges.isEmpty {
            let range = untransformedRanges.removeFirst()
            if range.upperBound < entry.range.lowerBound || range.lowerBound > entry.range.upperBound {
                remainingRanges.append(range)
            } else if range.lowerBound >= entry.range.lowerBound && range.upperBound <= entry.range.upperBound {
                transformedRanges.append(range.lowerBound + entry.shift ... range.upperBound + entry.shift)
            } else if range.lowerBound >= entry.range.lowerBound {
                transformedRanges.append(range.lowerBound + entry.shift ... entry.range.upperBound + entry.shift)
                if entry.range.upperBound < range.upperBound {
                    remainingRanges.append(entry.range.upperBound + 1 ... range.upperBound)
                }
            } else {
                transformedRanges.append(entry.range.lowerBound + entry.shift ... range.upperBound + entry.shift)
                if range.lowerBound < entry.range.lowerBound {
                    remainingRanges.append(range.lowerBound ... entry.range.lowerBound - 1)
                }
            }
        }
        return (remainingRanges, transformedRanges)
    }


    
    func mergeRanges(_ value: [ClosedRange<Int>]) -> [ClosedRange<Int>] {

        var result: [ClosedRange<Int>] = []
        var ranges = value
        ranges.sort {$0.lowerBound < $1.lowerBound}
        
        var accumulator: ClosedRange<Int>? = nil
        
        for  range in ranges {
            
            if accumulator == nil {
                accumulator = range
            }
            
            if accumulator!.upperBound >= range.upperBound {
                // interval is already inside accumulator
            }
            
            else if accumulator!.upperBound > range.lowerBound {
                // interval hangs off the back end of accumulator
                accumulator = accumulator!.lowerBound...range.upperBound
            }
            
            else if accumulator!.upperBound <= range.lowerBound {
                // interval does not overlap
                result.append(accumulator!)
                accumulator = range
            }
        }
        
        if accumulator != nil {
            result.append(accumulator!)
        }
        
        return result
    }
    
    private func countValues(in ranges: [ClosedRange<Int>]) -> Int {
        let sizes = ranges.map { $0.count}
        return sizes.reduce(0, +)
    }
    
    
}
