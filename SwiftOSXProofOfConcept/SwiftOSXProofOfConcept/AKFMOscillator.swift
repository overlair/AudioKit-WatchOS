//
//  AKFMOscillator.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 9/5/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

class AKFMOscillator : AKParameter {
    
    var fosc = UnsafeMutablePointer<sp_fosc>.alloc(1) // allocate 1
    var ftbl: UnsafeMutablePointer<sp_ftbl> = nil  //not just nil
    
    var frequency: Float = 440 {
        didSet {
            fosc.memory.freq = frequency
        }
    }
    
    var index: Float = 1 {
        didSet {
            fosc.memory.indx = index
        }
    }
    
    override init() {
        NSLog("Normal init")
        super.init()
        create()
    }
    
    convenience init(
        baseFrequency: AKParameter,
        carrierMultiplier: AKParameter,
        modulatingMultiplier: AKParameter,
        modulationIndex: AKParameter,
        amplitude: AKParameter)
    {
        NSLog("Full FM Oscillator initialization")
        self.init()
        baseFrequency.bind(&fosc.memory.freq)
        carrierMultiplier.bind(&fosc.memory.car)
        modulatingMultiplier.bind(&fosc.memory.mod)
        modulationIndex.bind(&fosc.memory.indx)
        amplitude.bind(&fosc.memory.amp)
//        fosc.memory.freq = baseFrequency.value
//        fosc.memory.car  = carrierMultiplier.value
//        fosc.memory.mod  = modulatingMultiplier.value
//        fosc.memory.indx = modulationIndex.value
//        fosc.memory.amp  = amplitude.value
        NSLog("Full FM Oscillator initialization done")
    }
    
    func create() {
        NSLog("Creating")
        sp_fosc_create(&fosc)
        sp_ftbl_create(AKManager.sharedManager.data, &ftbl, 4096)
        sp_gen_sine(AKManager.sharedManager.data, ftbl);
        sp_fosc_init(AKManager.sharedManager.data, fosc, ftbl)
        
        NSLog("Done Creating")
    }
    
    func compute() -> Float {
        sp_fosc_compute(AKManager.sharedManager.data, fosc, nil, &value);
        return value
    }
    
    func destroy() {
        sp_fosc_destroy(&fosc)
    }
    
    
}