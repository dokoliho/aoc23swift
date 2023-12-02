//
//  day02.swift
//  aoc23
//
//  Created by Oliver Hofmann on 02.12.23.
//

import Foundation
import RegexBuilder

public struct Day02Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        let games = puzzle.map{Game($0)}.filter { game in game.id >= 0 }
        let boundary = RGB("12 red, 13 green, 14 blue")
        let possibleGames = games.filter { game in game.gamePossible(boundary)}
        let possibleIds = possibleGames.map { $0.id }
        return String(possibleIds.reduce(0, +))
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let games = puzzle.map{Game($0)}.filter { game in game.id >= 0 }
        let powers = games.map { $0.power() }
        return String(powers.reduce(0, +))
    }
    
}


private func getRGBValue(for color: String, in line: String) -> Int {
   let search = Regex {
            Anchor.wordBoundary
            Capture {
                OneOrMore(.digit)
            }
            One(.whitespace)
            color
            Anchor.wordBoundary
   }
    if let match = line.firstMatch(of: search) {
        return Int(match.1) ?? 0
    }
    return 0
}


public struct RGB {
    var red : Int
    var green : Int
    var blue : Int
    
    init(_ line: String) {
        red = getRGBValue(for: "red", in: line)
        green = getRGBValue(for: "green", in: line)
        blue = getRGBValue(for: "blue", in: line)
    }
}

public struct Game {

    let id : Int
    var reveals : [RGB]
    
    init(_ line: String) {
        reveals = []
        let search = /^Game (?<id>\d+): (?<rgbs>.*)$/
        if let result = try? search.wholeMatch(in: line) {
            id = Int(result.id) ?? -1
            for rgb in result.rgbs.components(separatedBy: ";") {
                reveals.append(RGB(rgb))
            }
        }
        else {
            id = -2
        }
    }
    
    func maxRGB() -> (red: Int, green: Int, blue: Int) {
        var red = 0
        var green = 0
        var blue = 0
        for rgb in reveals {
            red = max(red, rgb.red)
            green = max(green, rgb.green)
            blue = max(blue, rgb.blue)
        }
        return (red, green, blue)
    }
    
    func gamePossible(_ boundary: RGB) -> Bool {
        let maxValues = maxRGB()
        return boundary.red >= maxValues.red && boundary.green >= maxValues.green && boundary.blue >= maxValues.blue
    }
    
    func power() -> Int {
        let maxValues = maxRGB()
        return maxValues.red * maxValues.green * maxValues.blue
    }
    
}
