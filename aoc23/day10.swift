//
//  day10.swift
//  aoc23
//
//  Created by Oliver Hofmann on 10.12.23.
//

import Foundation


extension Character {
    
    var up: Bool {
        return "S|JL".contains(self)
    }

    var down: Bool {
        return "S|F7".contains(self)
    }

    var left: Bool {
        return "S-J7".contains(self)
    }

    var right: Bool {
        return "S-FL".contains(self)
    }

}


public struct Day10Solution : DailySolution {

    enum AoCError: Error {
        case runtimeError(String)
    }

    func solvePart1(puzzle: [String]) -> String {
        let nodes = parse(puzzle)
        let edges = findEdges(nodes)
        var known = [Position]()
        var frontier = [Position]()
        var distances = [Position:Int]()
        if let start = startPosition(nodes) {
            distances[start] = 0
            frontier.append(start)
            while !frontier.isEmpty {
                let node = frontier.removeFirst()
                known.append(node)
                let newFound = expand(node, edges, known)
                if newFound.isEmpty {
                    return String(distances[node]!)
                }
                for newNode in newFound {
                    distances[newNode] = distances[node]!+1
                }
                frontier += newFound
            }
        }
        return ""
    }
    
    func solvePart2(puzzle: [String]) -> String {
        var counter = 0
        for line in puzzle {
            var outside = true
            var onpath = false
            let pipePath = ""
            for c in line {
                if !pipePath.isEmpty {
                    if ".|".contains(c) {
                        
                    }
                }
                if c == "." {
                    if onpath {
                        // We crossed a pipe and are now in open field
                        onpath = false
                        outside = !outside
                    }
                    counter = outside ? counter : counter + 1
                } else {
                    onpath = true
                }
            }
        }
        return String(counter)
    }
    
    
    struct Position : Hashable {
        let row: Int
        let col: Int
    }
    
    
    func parse(_ lines: [String]) -> [Position:Character] {
        var result = [Position:Character]()
        for (row, line) in lines.enumerated() {
            for (col, c) in line.enumerated() {
                if c != "." {
                    result[Position(row: row, col: col)] = c
                }
            }
        }
        return result
    }
    
    
    func findEdges(_ nodes: [Position:Character]) -> [Position:Set<Position>] {
        var result = [Position:Set<Position>]()
        for node in nodes {
            let start = node.key
            let tile = node.value
            
            if tile.up {
                let destination = Position(row: start.row - 1, col: start.col)
                if let destTile = nodes[destination], destTile.down {
                    updateEdgeResult(&result, start, destination)
                }
            }

            if tile.down {
                let destination = Position(row: start.row + 1, col: start.col)
                if let destTile = nodes[destination], destTile.up {
                    updateEdgeResult(&result, start, destination)
                }
            }

            if tile.left {
                let destination = Position(row: start.row, col: start.col-1)
                if let destTile = nodes[destination], destTile.right {
                    updateEdgeResult(&result, start, destination)
                }
            }

            if tile.right {
                let destination = Position(row: start.row, col: start.col+1)
                if let destTile = nodes[destination], destTile.left {
                    updateEdgeResult(&result, start, destination)
                }
            }

        }
        return result
    }
    
    fileprivate func updateEdgeResult(_ result: inout [Day10Solution.Position : Set<Day10Solution.Position>], _ start: Day10Solution.Position, _ destination: Day10Solution.Position) {
        if result.keys.contains(start) {
            result[start]!.insert(destination)
        } else {
            result[start] = Set<Position>([destination])
        }
    }

    func startPosition(_ nodes: [Position:Character]) -> Position? {
        for (pos, tile) in nodes {
            if tile == "S" {
                return pos
            }
        }
        return nil
    }

    func expand(_ node: Position, _ edges: [Position:Set<Position>], _ known: [Position]) -> [Position]  {
        var result = [Position]()
        for destination in edges[node]! {
            if !known.contains(destination) {
                result.append(destination)
            }
        }
        return result
    }
    
        
}
