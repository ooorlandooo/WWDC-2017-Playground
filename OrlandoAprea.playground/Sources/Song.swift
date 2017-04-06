//  Song.swift
//  WWDC
//
//  Created by Orlando Aprea on 24/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//


import Foundation

//handles the creation of the song
class Song {
    public var player: SoundPlayer!
    var song: [Chord] = []
    var executionSong: [BlockOperation] = [BlockOperation]()
    var myDispatchQueue: DispatchQueue!
    var scene: VisualScene!
    
    init(instrument: String, chords: [(ChordNames, Octave, NoteDuration)], forScene: VisualScene ){
        scene = forScene
        player = SoundPlayer(useChannels: [1,2,3], instrumentToUse: instrument)
        player.instrumentStart()
        addChords(chords: chords)
        myDispatchQueue =  DispatchQueue(label: "executingSong", qos: .userInteractive, attributes: DispatchQueue.Attributes.concurrent)
        
    }
    
    private func addChord(chord: (ChordNames, Octave, NoteDuration) ) {
        song.append(Chord(soundGenerator: player, song: self, chord: chord.0, octave: chord.1, duration: chord.2))
        executionSong.append((song.last?.chordExecution)!)
    }
    
    func addChords(chords: [(ChordNames, Octave, NoteDuration)]) {
        for chord in chords {
            addChord(chord: chord)
        }
        
        let execution = BlockOperation {
            self.scene.isSongFinished = true
            
        }
        if let last = executionSong.last {
            execution.addDependency(last)
        }
        
    }
    
    func playSong () {
        self.myDispatchQueue.async {
            OperationQueue().addOperations(self.executionSong, waitUntilFinished: false)
        }
    }
    
}
