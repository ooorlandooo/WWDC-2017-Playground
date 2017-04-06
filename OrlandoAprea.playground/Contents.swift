//#-hidden-code
import UIKit
import PlaygroundSupport


let myScene = VisualView(frame: CGRect.init(x: 0, y: 0, width: 600, height: 400))
//#-end-hidden-code

/*:
 
 ### Orlando Aprea Playground

 This playground let's you create your own music and then play/animate it.
 Click on the button on the bottom center of the scene when becames red and it will give you amazing animations.
 Be quick, be ready otherwise the sound will lose power and you will not se your own animations!

 Let's create our music.
 




 ### RemoveAllChords
 some example chords have already been inserted, if you want to remove them and execute your own music then activate the method sounds.removeAllChords()
 */
myScene.giveInstructions { sounds in
    //sounds.removeAllChords()

    sounds.add( newChord: (ChordNames.Em, Octave.six, NoteDuration.quaver))

    sounds.add(newChords: [(ChordNames.C, Octave.six, NoteDuration.semiquaver),
                           (ChordNames.G, Octave.seven, NoteDuration.quaver),
                           (ChordNames.Am, Octave.six, NoteDuration.crotchet),
                           (ChordNames.F, Octave.six, NoteDuration.halfNote)])
    
    
    /*sounds.add(newChords: [(ChordNames.D, Octave.six, NoteDuration.semiquaver),
                           (ChordNames.G, Octave.seven, NoteDuration.quaver),
                           (ChordNames.Am, Octave.six, NoteDuration.crotchet),
                           (ChordNames.C, Octave.six, NoteDuration.halfNote)])*/

    sounds.execute()
}
/*:
 ### adding a single Chord
 sounds.add( newChord: (ChordNames.Em, Octave.six, NoteDuration.quaver))
 will append the specified chord to the composition, feel free to change the chord and add it
 
 
 
 ### insert your song
 sounds.add(newChords: [(ChordNames.C, Octave.six, NoteDuration.semiquaver),
 (ChordNames.G, Octave.seven, NoteDuration.quaver),
 (ChordNames.Am, Octave.six, NoteDuration.crotchet),
 (ChordNames.F, Octave.six, NoteDuration.halfNote)])
 will append the specified part of song to the composition
 free to change the chords and add them
 


 ### Attachment
 of course if you remove the execute instruction or decide to remove all chords without inserting some, the playground will not give you music
 */
    
//#-hidden-code

PlaygroundPage.current.liveView = myScene

//#-end-hidden-code
