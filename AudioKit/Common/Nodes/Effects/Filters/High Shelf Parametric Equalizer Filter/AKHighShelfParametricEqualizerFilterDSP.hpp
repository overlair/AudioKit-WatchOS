//
//  AKHighShelfParametricEqualizerFilterDSP.hpp
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2020 AudioKit. All rights reserved.
//

#pragma once

#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(AUParameterAddress, AKHighShelfParametricEqualizerFilterParameter) {
    AKHighShelfParametricEqualizerFilterParameterCenterFrequency,
    AKHighShelfParametricEqualizerFilterParameterGain,
    AKHighShelfParametricEqualizerFilterParameterQ,
};

#ifndef __cplusplus

AKDSPRef createHighShelfParametricEqualizerFilterDSP(void);

#else

#import "AKSoundpipeDSPBase.hpp"

class AKHighShelfParametricEqualizerFilterDSP : public AKSoundpipeDSPBase {
private:
    struct InternalData;
    std::unique_ptr<InternalData> data;
 
public:
    AKHighShelfParametricEqualizerFilterDSP();

    void init(int channelCount, double sampleRate) override;

    void deinit() override;

    void reset() override;

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif
