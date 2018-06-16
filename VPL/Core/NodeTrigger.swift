//
//  NodeTrigger.swift
//  VPL
//
//  Created by Nathan Flurry on 3/28/18.
//  Copyright © 2018 Nathan Flurry. All rights reserved.
//

import Foundation

public final class InputTrigger {
    public typealias ID = UUID
    
    /// The node that owns this trigger.
    public internal(set) weak var owner: Node!
    
    /// An identifier for this value.
    public let id: ID = UUID()
    
    /// The connected trigger.
    public private(set) var target: OutputTrigger?
    
    /// Determines if two triggers can be connected.
    public func canConnect(to newTarget: OutputTrigger) -> Bool {
        return newTarget.canConnect(to: self)
    }
    
    /// Connects this trigger to another trigger.
    public func connect(to newTarget: OutputTrigger) {
        // Set the new target
        target = newTarget
        
        // Connect the other node
        if newTarget.target !== self {
            newTarget.connect(to: self)
        }
    }
    
    /// Disconnects any targets this is connected to.
    public func reset() {
        // Remove the target
        let tmpTarget = target
        target = nil
        
        // Remove other target if needed
        if tmpTarget?.target != nil {
            tmpTarget?.reset()
        }
    }
}

public final class OutputTrigger {
    public typealias ID = UUID
    
    /// The node that owns this trigger.
    public internal(set) weak var owner: Node!
    
    /// An identifier for this value.
    public let id: ID = UUID()
    
    /// Name for this trigger.
    public let name: String
    
    /// The connected trigger.
    public private(set) var target: InputTrigger?
    
    /// Variables availables to any other nodes further along the control flow.
    public let exposedVariables: [NodeVariable]
    
    /// If this trigger defines what node executes next and replaces the item on
    /// the stack.
    public internal(set) var nextTrigger: Bool = false
    
    public init(name: String, exposedVariables: [NodeVariable] = []) {
        self.name = name
        self.exposedVariables = exposedVariables
        
        // Set owner on variables
        exposedVariables.forEach { $0.owner = self }
    }
    
    public convenience init(exposedVariables: [NodeVariable] = []) {
        self.init(name: "Next", exposedVariables: exposedVariables)
    }
    
    /// Determines if two triggers can be connected.
    public func canConnect(to newTarget: InputTrigger) -> Bool {
        return owner !== newTarget.owner && target == nil && newTarget.target == nil
    }
    
    /// Connects this trigger to another trigger.
    public func connect(to newTarget: InputTrigger) {
        // Set the new target
        target = newTarget
        
        // Connect the other node
        if newTarget.target !== self {
            newTarget.connect(to: self)
        }
    }
    
    /// Disconnects any targets this is connected to.
    public func reset() {
        // Remove the target
        let tmpTarget = target
        target = nil
        
        // Remove other target if needed
        if tmpTarget?.target != nil {
            tmpTarget?.reset()
        }
    }
}