//
//  day20.swift
//  aoc23
//
//  Created by Oliver Hofmann on 20.12.23.
//

import Foundation

public struct Day20Solution : DailySolution {
    
    enum AoCError: Error {
        case runtimeError(String)
        case parsingError(String)
        case heapUnderrun
    }
    
    func solvePart1(puzzle: [String]) -> String {
        let map = parse(lines: puzzle)
        MachineModule.resetCounter()
        for p in 1...1000 {
            MachineModule.push(map: map)
        }
        print(MachineModule.countLowPulses, MachineModule.countHighPulses)
        return String(MachineModule.countLowPulses * MachineModule.countHighPulses)
    }
    
    
    func solvePart2(puzzle: [String]) -> String {
        return ""
    }
    
    
    func parse(lines: [String]) -> [String: MachineModule] {
        var result = [String: MachineModule]()
        for line in lines.filter({ !$0.isEmpty }) {
            //      "%a -> inv, con",
            let search = /^(?<type>[%, &]?)(?<name>[a-z]+) -> (?<connections>.*)$/
            if let match = try? search.wholeMatch(in: line) {
                let name = String(match.name)
                switch String(match.type) {
                case "":
                    result[name] = Broadcaster(id: name, connectString: String(match.connections))
                case "&":
                    result[name] = Conjunction(id: name, connectString: String(match.connections))
                case "%":
                    result[name] = FlipFlop(id: name, connectString: String(match.connections))
                default:
                    print("Illegal type" )
                }
            }
            else {
                print("Parsing Error: " + line)
            }
        }
        for module in result.values {
            module.setConnections(map: result)
        }
        return result
    }
    
    
}


enum ModuleState: Int {
    case low = 0
    case high
}

class MachineModule {

    static var countLowPulses: Int = 0
    static var countHighPulses: Int = 0

    
    static func resetCounter() {
        countLowPulses = 0
        countHighPulses = 0
    }
    
    
    static func push(map: [String: MachineModule]) {
        if let broadcaster = map["broadcaster"] {
            countLowPulses += 1
            broadcaster.trigger(from: "BUTTON", with: ModuleState.low)
        } else {
            print("No broadcaster")
        }
    }
    
    
    let name: String
    let connections: [String]
    var connectedTo: [MachineModule]

    
    init(id: String, connectString: String) {
        name = id
        connections = connectString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces)}
        connectedTo = []
    }


    func trigger(from sender: String, with state : ModuleState) {}
    func gotConnected(from sender: String) {}
    
    func setConnections(map: [String: MachineModule]) {
        for name in self.connections {
            if let module = map[name] {
                self.connectedTo.append(module)
                module.gotConnected(from: self.name)
            } else {
                fatalError("Unkown Module " + name)
            }
        }
    }
    
    func triggerAll(with state: ModuleState) {
        for module in connectedTo {
            module.trigger(from: name, with: state)
        }
        if state == ModuleState.low {
            MachineModule.countLowPulses += connectedTo.count
        } else {
            MachineModule.countHighPulses += connectedTo.count
        }
    }
}

class Broadcaster : MachineModule {

    override func trigger(from sender: String, with state : ModuleState) {
        triggerAll(with: state)
    }
        
}


class FlipFlop : MachineModule {

    var isOn: Bool = false
    
    override func trigger(from sender: String, with state : ModuleState) {
        if state == ModuleState.low {
            isOn = !isOn
            triggerAll(with: isOn ? ModuleState.high : ModuleState.low)
        }
    }
}


class Conjunction : MachineModule {

    var storedStates: [String: ModuleState] = [:]

    override func gotConnected(from sender: String) {
        storedStates[sender] = ModuleState.low
    }
    
    override func trigger(from sender: String, with state : ModuleState) {
        storedStates[sender] = state
        let allHigh = storedStates.values.map{ $0 == ModuleState.high}.reduce(true, { a, c in a && c })
        triggerAll(with: allHigh ? ModuleState.low : ModuleState.high)
    }
        
}
