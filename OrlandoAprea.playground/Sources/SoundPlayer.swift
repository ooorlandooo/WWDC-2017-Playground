//
//  SoundPlayer.swift
//  WWDC
//
//  Created by Orlando Aprea on 24/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

import Foundation
import AVFoundation


public protocol ReactOnClickDelegate: class {
    func didClick ()
}


class SoundPlayer: ReactOnClickDelegate {
    var engine:AVAudioEngine!
    let usedChannels:[UInt8]!
    
    private let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    private let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    var sampler:AVAudioUnitSampler!
    var player: AVAudioPlayerNode!
    /// general midi number for instrument
    var instrument:UInt8!
    weak var delegate: VisualSoundsEffectDelegate?
    var isNextSoundEnabled: Bool = true
    
    //enable the execution into the graphic simulation of the graphic effects associated to the sound played
    var newSoundExecuting: (ChordNames, Octave, NoteDuration)? {
        didSet {
            if isNextSoundEnabled {
                sampler.volume = engine.mainMixerNode.volume
                self.delegate?.visualSoundsEffect(isExecutingSound: self.newSoundExecuting!, in: self)
            } else {
                self.delegate?.nextSoundDisablingVisualEffect(isExecutingSound: self.newSoundExecuting!, in: self)
                sampler.volume = engine.mainMixerNode.volume / 10
            }
        }
        
    }
    
    //inizialize the engine
    init(useChannels: [UInt8], instrumentToUse: String) {
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        usedChannels = useChannels
        instrument = MIDIInstruments[instrumentToUse]
        
        do {
            try engine.start()
            print("engine started")
        } catch {
            print("engine error \(error)")
        }
        sampler.volume = engine.mainMixerNode.volume
    }
    
    
    //if an instrument font is there as a resource with the name instrumentFont.sf2 then the font is loaded
    func instrumentStart() {
        guard let soundBank = Bundle.main.url(forResource: "instrumentsFont", withExtension: "sf2") else {
            print("sound font error at: \(Bundle.main.url(forResource: "instrumentsFont", withExtension: "sf2"))")
            return
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundBank, program:instrument!,
                                                bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        for channel in usedChannels {
            self.sampler.sendProgramChange(instrument!, bankMSB: melodicBank, bankLSB: defaultBankLSB, onChannel: channel)
        }
    }
    
    //execute the chord and enable the effect that signal the next chord effects has to start, when the execution is about to finish
    //here there is an active wait because reactivity concerns
    func play(_ chord: (ChordNames, Octave, NoteDuration) )    {
        let notes = ChordComposition[chord.0]!
        let velocity = UInt32(64)
        var isFirstTime = true
        let startDate = Date().timeIntervalSince1970
        var elapsedTime = 0.0
        
        newSoundExecuting = chord
        isNextSoundEnabled = false
        
        for note in notes{
            self.sampler.startNote(note.applyOctave(octave: chord.1), withVelocity: UInt8(velocity), onChannel: usedChannels[notes.index(of: note)!] )
        }
        
        while ( TimeInterval(chord.2.rawValue) > elapsedTime ){
            
            elapsedTime = Date().timeIntervalSince1970 - startDate
            
            if !isNextSoundEnabled &&
                TimeInterval(chord.2.rawValue) - elapsedTime < NoteDuration.semiquaver.rawValue - 0.1 &&
                isFirstTime {
                isFirstTime = false
                
                self.delegate?.nextSoundEnablingVisualEffect(isExecutingSound: chord , in: self)
                
            }
        }
        
        for note in notes {
            self.sampler.stopNote(note.applyOctave(octave: chord.1), onChannel: usedChannels[notes.index(of: note)!])
        }
        
    }
    
    //ReactOnClickDelegate protocol function, is called every time a touch event occur on the enabled button
    func didClick() {
        isNextSoundEnabled = true
    }
    
}
