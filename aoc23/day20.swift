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
        reset()
        for _ in 1...1000 {
            MachineModule.push(map: map)
        }
        print(lowPulses, highPulses)
        return String(lowPulses * highPulses)
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
    
    func reset() {
        MachineModule.reset()
    }
    
    var lowPulses: Int {
        return MachineModule.countLowPulses
    }
    
    var highPulses: Int {
        return MachineModule.countHighPulses
    }
    
}


enum ModuleState: Int {
    case low = 0
    case high
}

class MachineModule {

    static var countLowPulses: Int = 0
    static var countHighPulses: Int = 0
    static var pipeline: [Notification] = []
    static var countPushes: Int = 0

    static let sink = MachineModule(id: "SINK", connectString: "")
    
    static func reset() {
        countLowPulses = 0
        countHighPulses = 0
        countPushes = 0
        pipeline = []
    }
    
    
    static func push(map: [String: MachineModule]) {
        // print ("********** PUSH ************")
        MachineModule.countPushes += 1
        if let broadcaster = map["broadcaster"] {
            MachineModule.pipeline.append(Notification(sender: "BUTTON", receiver: broadcaster, state: ModuleState.low ))
            while !MachineModule.pipeline.isEmpty {
                let currentTrigger = MachineModule.pipeline.removeFirst()
                if currentTrigger.state == ModuleState.low {
                    MachineModule.countLowPulses += 1
                } else {
                    MachineModule.countHighPulses += 1
                }
                currentTrigger.receiver.gotTriggered(from: currentTrigger.sender, with: currentTrigger.state)
            }
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


    func gotTriggered(from sender: String, with state : ModuleState)  {
        // print(sender + " -" + (state==ModuleState.low ? "low" : "high") + "-> " + name)
    }
    
    
    func gotConnected(from sender: String) {}
    
    func setConnections(map: [String: MachineModule]) {
        for name in self.connections {
            if let module = map[name] {
                self.connectedTo.append(module)
                module.gotConnected(from: self.name)
            } else if name == "rx" {
                self.connectedTo.append(RX(id: "rx", connectString: ""))
            } else {
                self.connectedTo.append(MachineModule.sink)
            }
        }
    }
    
    func notifyAll(with state: ModuleState) {
        for module in connectedTo {
            MachineModule.pipeline.append(Notification(sender: name, receiver: module, state: state ))
        }
    }
}

struct Notification {
    let sender: String
    let receiver: MachineModule
    let state: ModuleState
}


class Broadcaster : MachineModule {

    override func gotTriggered(from sender: String, with state : ModuleState)  {
        super.gotTriggered(from: sender, with: state)
        notifyAll(with: state)
    }
        
}


class FlipFlop : MachineModule {

    var isOn: Bool = false
    
    override func gotTriggered(from sender: String, with state : ModuleState)  {
        super.gotTriggered(from: sender, with: state)
        if state == ModuleState.low {
            isOn = !isOn
            notifyAll(with: isOn ? ModuleState.high : ModuleState.low)
        }
    }
}


class Conjunction : MachineModule {

    var storedStates: [String: ModuleState] = [:]

    override func gotConnected(from sender: String) {
        storedStates[sender] = ModuleState.low
    }
    
    override func gotTriggered(from sender: String, with state : ModuleState)  {
        super.gotTriggered(from: sender, with: state)
        storedStates[sender] = state
        let allHigh = storedStates.values.map{ $0 == ModuleState.high}.reduce(true, { a, c in a && c })
        notifyAll(with: allHigh ? ModuleState.low : ModuleState.high)
    }
        
}

class RX : MachineModule {
    
    override func gotTriggered(from sender: String, with state : ModuleState)  {
        super.gotTriggered(from: sender, with: state)
        if state == ModuleState.low {
            print("Hallo")
        }
    }
    
}
