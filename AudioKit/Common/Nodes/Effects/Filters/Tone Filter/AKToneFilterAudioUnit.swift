//
//  AKToneFilterAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2020 AudioKit. All rights reserved.
//

import AVFoundation

public class AKToneFilterAudioUnit: AKAudioUnitBase {

    private(set) var halfPowerPoint: AUParameter!

    public override func createDSP() -> AKDSPRef {
        return createToneFilterDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        halfPowerPoint = AUParameter(
            identifier: "halfPowerPoint",
            name: "Half-Power Point (Hz)",
            address: AKToneFilterParameter.halfPowerPoint.rawValue,
            range: AKToneFilter.halfPowerPointRange,
            unit: .hertz,
            flags: .default)

        parameterTree = AUParameterTree.createTree(withChildren: [halfPowerPoint])

        halfPowerPoint.value = AUValue(AKToneFilter.defaultHalfPowerPoint)
    }
}
