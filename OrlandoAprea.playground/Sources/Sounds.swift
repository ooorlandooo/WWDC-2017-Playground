//
//  Sounds.swift
//  WWDC
//
//  Created by Orlando Aprea on 27/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

import Foundation

//handles the instructions that the playground user, is permitted to give to the simulation
public class Sounds {
    private var scene: VisualScene
    
    init(scene: VisualScene) {
        self.scene = scene
    }
    
    public func add( newChord: (ChordNames, Octave, NoteDuration)) {
        self.scene.addChord(chord: newChord)
    }
    public func removeAllChords() {
        self.scene.removeChords()
    }
    public func add( newChords: [(ChordNames, Octave, NoteDuration)]) {
        self.scene.addChords(newChords: newChords)
    }
    public func execute() {
        self.scene.execute()
    }
}

