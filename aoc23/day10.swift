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
        let distances = bfs(puzzle: puzzle)
        let maxDistance = distances.values.max() ?? 0
        return String(maxDistance)
    }
    
    func solvePart2(puzzle: [String]) -> String {
        let distances = bfs(puzzle: puzzle)
        let pipePositions = Array(distances.keys)
        let puzzleWithJunkMarked = markJunk(inPuzzle: puzzle, with: ".", whenNotIn: pipePositions)
        let includedTiles = puzzleWithJunkMarked.map({ countInnerTiles(line: $0)}).reduce(0, +)
        return String(includedTiles)
    }
    
    
    func bfs(puzzle: [String]) -> [Position:Int] {
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
                    break
                }
                for newNode in newFound {
                    distances[newNode] = distances[node]!+1
                }
                frontier += newFound
            }
        }
        return distances
    }

    
    func markJunk(inPuzzle puzzle: [String], with junk: Character, whenNotIn pipePositions: [Position]) -> [String] {
        var result = [String]()
        for (row, line) in puzzle.enumerated() {
            var newLine = ""
            for (col, c) in line.enumerated() {
                if c != "." && !pipePositions.contains(Position(row: row, col: col)) {
                    newLine.append(junk)
                } else {
                    newLine.append(c)
                }
            }
            result.append(newLine)
            print(newLine)
        }
        return result
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
    
    
    func countInnerTiles(line: String) -> Int {
        var inside = false
        var pipeBehind=""
        var count = 0
        for c in line {
            inside = crossedPipe(pipeBehind) ? !inside : inside
            pipeBehind = haveToClearPipe(pipeBehind) ? "" : pipeBehind
            if c == "." {
                count += inside ? 1 : 0
            } else {
                pipeBehind.append(c)
            }
        }
        return count
    }
    
    
    func crossedPipe(_ behind: String) -> Bool {
        if behind.isEmpty {
            return false
        }
        let pipeStart = behind.first!
        let pipeEnd = behind.last!
        if pipeEnd.right {
            return false
        }
        if pipeEnd == "J" && pipeStart == "L" {
            return false
        }
        if pipeEnd == "7" && pipeStart == "F" {
            return false
        }
        return true
    }
    
    func haveToClearPipe(_ behind: String) -> Bool {
        if behind.isEmpty {
            return false
        }
        let pipeEnd = behind.last!
        return !pipeEnd.right
    }
    
}
