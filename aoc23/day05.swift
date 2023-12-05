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
            ranges.append(parser.seeds[i]...parser.seeds[i]+parser.seeds[i+1])
        }
        let lowerbounds = parser.transformRanges(ranges).map {$0.lowerBound}
        let closestLocation = lowerbounds.min() ?? 0
        return String(closestLocation)
    }
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
        }
        return result
    }
    
}


struct SeedMapTransformer {
        
    var mapentry: [(destination: Int, source: Int, length: Int)] = []
    
    mutating func addEntry(line: String) {
        let values = (line.components(separatedBy: " ").compactMap {Int($0)})
        mapentry.append((destination: values[0], source: values[1], length: values[2]))
    }
    
    func transform( _ value: Int) -> Int {
        for entry in mapentry {
            if value >= entry.source && value < entry.source + entry.length {
                return entry.destination + value - entry.source
            }
        }
        return value
    }
    
    func transformRanges( _ value: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var notAffectedRanges: [ClosedRange<Int>] = value
        var transformedRanges: [ClosedRange<Int>] = []
        for entry in mapentry {
            let rangesToProcess = notAffectedRanges
            let shift = entry.destination - entry.source
            for range in rangesToProcess {
                if let index = notAffectedRanges.firstIndex(of: range) {
                    notAffectedRanges.remove(at: index)
                }
                if range.upperBound < entry.source || range.lowerBound > entry.source + entry.length {
                    // no overlap
                    notAffectedRanges.append(range)
                } else if range.lowerBound >= entry.source && range.upperBound <= entry.source + entry.length {
                    // requested range included in mapentry
                    transformedRanges.append(range.lowerBound+shift...range.upperBound+shift)
                } else if range.lowerBound >= entry.source {
                    // requested range exceeds mapentry to right
                    transformedRanges.append(range.lowerBound+shift...entry.destination+entry.length)
                    if entry.source+entry.length+1 <= range.upperBound {
                        notAffectedRanges.append(entry.source+entry.length+1...range.upperBound)
                    }
                } else {
                    // requested range exceeds mapentry to left
                    transformedRanges.append(entry.destination...range.upperBound+shift)
                    if (range.lowerBound <= entry.source-1) {
                        notAffectedRanges.append(range.lowerBound...entry.source-1)
                    }

                }
            }
        }
        return mergeRanges(notAffectedRanges + transformedRanges)
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
}
