//
//  Chord.swift
//  WWDC
//
//  Created by Orlando Aprea on 27/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//
import Foundation

//handles the creation of the chords and the execution of a chord inside a song
class Chord {
    var player: SoundPlayer!
    var duration: NoteDuration!
    var octave: Octave
    var chord: ChordNames!
    var chordExecution: BlockOperation!
    var song: Song!
    
    init(soundGenerator: SoundPlayer, song: Song, chord: ChordNames, octave: Octave, duration: NoteDuration){
        self.octave = octave
        self.duration = duration
        self.chord = chord
        self.song = song
        self.player = soundGenerator
        self.chordExecution = getSequenceExecution()
        
    }
    
    private func getSequenceExecution() -> BlockOperation {
        let execution: BlockOperation!
        
        execution = BlockOperation {
            self.song.player.play((self.chord, self.octave, self.duration))
            
        }
        
        
        if let startAfter = song?.executionSong.last {
            execution.addDependency(startAfter)
        }
        return execution
    }
}



