//
//  day05.swift
//  aoc23
//
//  Created by Oliver Hofmann on 05.12.23.
//

import Foundation

public struct Day05Solution : DailySolution {

    func solvePart1(puzzle: [String]) -> String {
        var seeds = puzzle[0].split(separator: ":")[1].split(separator: " ").compactMap { Int($0) }
        let transformers = parseTransformers(puzzle: puzzle)

           for transformer in transformers {
               var newSeeds: [Int] = []
               while !seeds.isEmpty {
                   let seed = seeds.removeLast()
                   var processed = false;
                   for currentRange in transformer.ranges {
                       let size = currentRange.2
                       let sourceStart = currentRange.1
                       let destinationStart = currentRange.0
                       let shift = destinationStart - sourceStart
                       if sourceStart <= seed && seed < sourceStart + size {
                           newSeeds.append(seed + shift)
                           processed = true
                           break
                       }
                   }
                   if !processed {
                       newSeeds.append(seed)
                   }
               }
               seeds = newSeeds
           }

        let closestLocation = seeds.min() ?? 0
        return String(closestLocation)
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let numbers = puzzle[0].split(separator: ":")[1].split(separator: " ").compactMap { Int($0) }
        let transformers = parseTransformers(puzzle: puzzle)
        var seedIntervals: [(Int, Int)] = []
        for i in stride(from: 0, to: numbers.count, by: 2) {
            seedIntervals.append((numbers[i], numbers[i] + numbers[i + 1]))
        }

        for transformer in transformers {
            var newSeedIntervals: [(Int, Int)] = []
            while !seedIntervals.isEmpty {
                let seedInterval = seedIntervals.removeLast()
                var processed = false;
                for currentRange in transformer.ranges {
                    let size = currentRange.2
                    let sourceStart = currentRange.1
                    let destinationStart = currentRange.0
                    let intervalStart = seedInterval.0
                    let intervalEnd = seedInterval.1
                    let shift = destinationStart - sourceStart
                    let overlapStart = max(intervalStart, sourceStart)
                    let overlapEnd = min(intervalEnd, sourceStart + size)
                    if overlapStart < overlapEnd {
                        newSeedIntervals.append((overlapStart + shift, overlapEnd + shift))
                        if overlapStart > intervalStart {
                            seedIntervals.append((intervalStart, overlapStart))
                        }
                        if overlapEnd < intervalEnd {
                            seedIntervals.append((overlapEnd, intervalEnd))
                        }
                        processed = true
                        break
                    }
                }
                if !processed {
                    newSeedIntervals.append(seedInterval)
                }
            }
            seedIntervals = newSeedIntervals
        }

        let closestLocation = seedIntervals.min { $0.0 < $1.0 }?.0 ?? 0
        return String(closestLocation)
    }
}


func parseTransformers(puzzle: [String]) -> [Transformer] {
    var i = 3
    var transformers: [Transformer] = []
    while i < puzzle.count {
        let transformer = Transformer()
        i = transformer.create(puzzle: puzzle, index: i)
        transformers.append(transformer)
    }
    return transformers
}

class Transformer {
    var ranges: [(Int, Int, Int)] = []

    func create(puzzle: [String], index: Int) -> Int {
        var currentIndex = index
        while currentIndex < puzzle.count && puzzle[currentIndex] != "" {
            let numbers = puzzle[currentIndex].split(separator: " ").compactMap { Int($0) }
            ranges.append((numbers[0], numbers[1], numbers[2]))
            currentIndex += 1
        }
        return currentIndex + 2
    }
}
