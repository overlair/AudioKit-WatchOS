//
//  AKAutoPanner.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

/// Table-lookup panning with linear interpolation
///
open class AKAutoPanner: AKNode, AKToggleable, AKComponent, AKInput {
    public typealias AKAudioUnitType = AKAutoPannerAudioUnit
    /// Four letter unique description of the node
    public static let ComponentDescription = AudioComponentDescription(effect: "apan")

    // MARK: - Properties

    public private(set) var internalAU: AKAudioUnitType?

    fileprivate var waveform: AKTable?

    /// Frequency (Hz)
    open var frequency: Double = 10.0 {
        willSet {
            guard frequency != newValue else { return }
            internalAU?.frequency.value = AUValue(newValue)
        }
    }

    /// Depth
    open var depth: Double = 1.0 {
        willSet {
            guard depth != newValue else { return }
            internalAU?.depth.value = AUValue(newValue)
        }
    }

    /// Tells whether the node is processing (ie. started, playing, or active)
    open var isStarted: Bool {
        return internalAU?.isStarted ?? false
    }

    // MARK: - Initialization

    /// Initialize this auto panner node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - frequency: Frequency (Hz)
    ///   - depth: Depth
    ///   - waveform:  Shape of the panner (default to sine)
    ///
    public init(
        _ input: AKNode? = nil,
        frequency: Double = 10,
        depth: Double = 1.0,
        waveform: AKTable = AKTable(.positiveSine)
    ) {
        super.init()

        _Self.register()
        AVAudioUnit._instantiate(with: _Self.ComponentDescription) { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit
            self.internalAU = avAudioUnit.auAudioUnit as? AKAudioUnitType
            input?.connect(to: self)

            self.waveform = waveform
            self.frequency = frequency
            self.depth = depth

            self.internalAU?.setWavetable(waveform.content)
        }
    }

    // MARK: - Control

    /// Function to start, play, or activate the node, all do the same thing
    open func start() {
        internalAU?.start()
    }

    /// Function to stop or bypass the node, both are equivalent
    open func stop() {
        internalAU?.stop()
    }
}
