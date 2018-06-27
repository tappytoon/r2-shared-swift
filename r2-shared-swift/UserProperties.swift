//
//  UserProperties.swift
//  r2-shared-swift
//
//  Created by Geoffrey Bugniot on 27/06/2018.
//  Copyright © 2018 Readium. All rights reserved.
//

import Foundation

protocol UserPropertyStringifier {
    func toString() -> String
}

public class UserProperty {
    
    var reference: String
    var name: String
    
    init(_ reference: String, _ name: String) {
        self.reference = reference
        self.name = name
    }
    
}

public class Enumeratable: UserProperty, UserPropertyStringifier {

    var index: Int
    var values: [String]
    
    init(index: Int, values: [String], reference: String, name: String) {
        self.index = index
        self.values = values
        
        super.init(reference, name)
    }
    
    public func toString() -> String {
        return values[index]
    }
    
}

public class Incrementable: UserProperty, UserPropertyStringifier {
    
    var value, min, max, step: Float
    var suffix: String
    
    init(value: Float, min: Float, max: Float, step: Float, suffix: String, reference: String, name: String) {
        self.value = value
        self.min = min
        self.max = max
        self.step = step
        self.suffix = suffix
        
        super.init(reference, name)
    }
    
    public func increment() {
        value += ( (value + step) <= max ) ? step : 0.0
    }
    
    public func decrement() {
        value -= ( (value - step) >= min ) ? step : 0.0
    }
    
    public func toString() -> String {
        return "\(value)" + suffix
    }
    
}

public class Switchable: UserProperty, UserPropertyStringifier {
    
    var onValue: String
    var offValue: String
    var on: Bool
    var values: [Bool: String]
    
    init(onValue: String, offValue: String, on: Bool, reference: String, name: String) {
        self.onValue = onValue
        self.offValue = offValue
        self.on = on
        
        values = [true: onValue, false: offValue]
        
        super.init(reference, name)
    }
    
    public func switchValue() {
        on = !on
    }
    
    func toString() -> String {
        return values[on]!
    }
    
}

public class UserProperties {
    
    public var properties = [UserProperty]()
    
    public func addEnumeratable(index: Int, values: [String], reference: String, name: String) {
        properties.append(Enumeratable(index: index, values: values, reference: reference, name: name))
    }
    
    public func addIncrementable(nValue: Float, min: Float, max: Float, step: Float, suffix: String, reference: String, name: String) {
        properties.append(Incrementable(value: nValue, min: min, max: max, step: step, suffix: suffix, reference: reference, name: name))
    }
    
    public func addSwitchable(onValue: String, offValue: String, on: Bool, reference: String, name: String) {
        properties.append(Switchable(onValue: onValue, offValue: offValue, on: on, reference: reference, name: name))
    }
    
    public func getProperty(reference: String) -> UserProperty? {
        return properties.filter { $0.reference == reference }.first
    }
}
