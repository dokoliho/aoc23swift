//
//  day06.swift
//  aoc23
//
//  Created by Oliver Hofmann on 06.12.23.
//

import Foundation

public struct Day06Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        let races = RaceParser.races(puzzle: puzzle)
        let wins = races.map {$0.countWinning}
        return String(wins.reduce(1, *))
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let race = RaceParser.oneRace(puzzle: puzzle)
        return String(race.countWinning)
    }
}


public struct RaceParser {
    
    static func races(puzzle: [String]) -> [Race] {
        let times = numbers(line: puzzle[0].components(separatedBy: ":")[1])
        let distances = numbers(line: puzzle[1].components(separatedBy: ":")[1])
        assert(times.count == distances.count, "Parser Error: different counts of times and distances")
        return zip(times, distances).map { Race($0) }
    }
    
    static func numbers(line: String) -> [UInt64] {
        return line.components(separatedBy: " ").compactMap { UInt64($0) }
    }
    
    static func oneRace(puzzle: [String]) -> Race {
        let time = number(line: puzzle[0].components(separatedBy: ":")[1])
        let distance = number(line: puzzle[1].components(separatedBy: ":")[1])
        return Race((time,distance))
    }
    
    static func number(line: String) -> UInt64 {
        return UInt64(line.replacingOccurrences(of: " ", with: "")) ?? 0
    }
}


public struct Race {
        
    let time: UInt64
    let distance: UInt64

    init(_ values: (UInt64, UInt64)) {
        time = values.0
        distance = values.1
    }
    
    func isWinning(pressing: UInt64) -> Bool {
        let runDistance = distance(whenPressing: pressing, after: time)
        return runDistance > distance
    }
    
    func distance(whenPressing pressing: UInt64,  after totaltime: UInt64) -> UInt64 {
        if pressing > totaltime {
            return 0
        }
        return (totaltime-pressing) * pressing
    }
    
    
    var countWinning: Int  {
        let range = winWithShortestPressing()...winWithLongestPressing()
        return range.count
    }

    
    var r: UInt64 {
        time * (time - distance/time*4)
    }


    func winWithShortestPressing() -> UInt64 {
        let s = sqrtUInt64(r)
        var guess = (time - s) / 2 - 1
        while !isWinning(pressing: guess) {
            guess += 1
        }
        return guess
    }

    func winWithLongestPressing() -> UInt64 {
        let s = sqrtUInt64(r)
        var guess = (time + s) / 2 + 1
        while !isWinning(pressing: guess) {
            guess -= 1
        }
        return guess
    }

    
}

func sqrtUInt64(_ value: UInt64) -> UInt64 {
    var guess = value/2
    var tooSmall: Bool = true
    var tooBig: Bool = true
    repeat {
        guess = (guess + value/guess) / 2
        tooSmall = value / (guess+1) >= guess+1
        tooBig = value / (guess-1) <= guess-1
    } while (tooSmall || tooBig )
    return guess
}
