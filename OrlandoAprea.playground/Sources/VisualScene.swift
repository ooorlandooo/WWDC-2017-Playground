//
//  GameScene.swift
//  WWDC
//
//  Created by Orlando Aprea on 27/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

import SpriteKit


//protocol needed to execute the animations based on the sound input
protocol VisualSoundsEffectDelegate: class {
    func visualSoundsEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer)
    func nextSoundEnablingVisualEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer)
    func nextSoundDisablingVisualEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer)
    
}
//the core of the graphic simulation
class VisualScene: SKScene, VisualSoundsEffectDelegate  {
    enum SceneSteps {case initializing, starting, playingMusic, waiting, theEnd, other}
    var currentSceneStep: SceneSteps = SceneSteps.initializing
    weak var reactDelegate: ReactOnClickDelegate?
    let instrument: String = "Violin"//"SawWave"//"DeepBass"//"Violin"
    var mySong: Song!
    var isSongFinished: Bool = false
    var chords: [(ChordNames, Octave, NoteDuration)] = [(ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.C, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.eight, NoteDuration.semiquaver),
                                                        (ChordNames.F, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.C, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.Fdiesis, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.Gm, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Dm, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Ddiesis, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.G, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.A, Octave.one, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.C, Octave.ten, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.C, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Em, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.Bm, Octave.six, NoteDuration.semiquaver),
                                                        (ChordNames.C, Octave.five, NoteDuration.semiquaver),
                                                        (ChordNames.D, Octave.five, NoteDuration.semiquaver)]
    
    var sceneCenter: CGPoint!
    var startingText: SKLabelNode!
    var actionsOnStartingText: SKAction!
    let myVisualEffects = VisualEffectsPool.shared
    var animatedEffects: [VisualEffect] = [VisualEffect]()
    var clickableButton: ClickableEffect!
    var numberOfAnimationsPerKind: [KindOfEffect:Int] = [:]
    let maxAmountPermitted = VisualEffectsPool.shared.effects[KindOfEffect.bubble]!.count
    var groups:[Group] = [Group]()
    
    override func didMove(to view: SKView) {
        sceneCenter = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        var angleBias: Double = 0
        var radiusCut: Double = 2
        for numberOfGroup in 0...5 {
            groups.append( Group(name: "\(numberOfGroup)", scene: self, angleBias: angleBias, radiusCut: radiusCut) )
            angleBias += 30
            if numberOfGroup == 2 {
                angleBias = 0
                radiusCut += 1
            }
            
        }
        
        for animation in EffectsDictionary {
            numberOfAnimationsPerKind[animation] = 0
        }
        
        //mySong = Song(instrument: instrument, chords: chords, forScene: self)
        //reactDelegate = mySong.player
        //mySong.player.delegate = self
        clickableButton = self.myVisualEffects.getClickableEffect()
        startScene()

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Called before each frame is rendered
        switch currentSceneStep {
        case .initializing:
            startingText.run(actionsOnStartingText)
            currentSceneStep = SceneSteps.waiting
        case .starting:
            if mySong != nil {
                mySong.playSong()
                reactDelegate?.didClick()
                currentSceneStep = SceneSteps.playingMusic
            }else {
                self.isPaused = true
            }
        case .playingMusic:
            for effect in EffectsDictionary {
                VisualEffect.pathToFollow[effect] = nil
            }
            if isSongFinished == true {
                currentSceneStep = SceneSteps.theEnd
            }
        case .theEnd:
            self.run(actionsOnStartingText)
            isPaused = true
        case .waiting:
            break
        default:
            break
        }
    }
    func endScene(){
        var actionOnEnd: [SKAction] = [SKAction]()
        actionOnEnd.append(SKAction.fadeAlpha(to: 0, duration: 1))
        actionOnEnd.append(SKAction.run {
            self.removeAllChildren()
            self.startingText.text = "The End, thank you for playing me"
            self.startingText.adjustLabelFontSizeToFitRect(rect: self.frame)
            self.addChild(self.startingText)
        })
        
        actionOnEnd.append(SKAction.fadeAlpha(to: 1, duration: 1))
        actionsOnStartingText =  SKAction.sequence(actionOnEnd)
        
        
    }
    func startScene() {
        
        startingText = SKLabelNode(fontNamed: "Chalkduster")
        startingText.name = "text"
        startingText.text = "Let's play some music, rise your device volume"
        startingText.fontColor = SKColor.white
        startingText.adjustLabelFontSizeToFitRect(rect: self.frame)
        startingText.alpha = 0
        var actionsOnText: [SKAction] = [SKAction]()
        actionsOnText.append( SKAction.fadeAlpha(to: 1, duration: 2) )
        actionsOnText.append( SKAction.fadeAlpha(to: 0, duration: 2) )
        actionsOnText.append( SKAction.run{
            self.startingText.text = "Play effects, clicking the button when becames red \u{25BE}"
            self.startingText.adjustLabelFontSizeToFitRect(rect: self.frame)
        })
        actionsOnText.append( SKAction.fadeAlpha(to: 1, duration: 2) )
        actionsOnText.append(SKAction.run{
            self.clickableButton.isClickable = false
            self.clickableButton.position = self.sceneCenter
            if self.clickableButton.parent == nil {
                self.addChild(self.clickableButton)
            }
        })
        actionsOnText.append(SKAction.customAction(withDuration: 2, actionBlock: { _,_ in }))
        actionsOnText.append(SKAction.run{
            self.clickableButton.isClickable = true
        })
        actionsOnText.append( SKAction.fadeAlpha(to: 1, duration: 2) )
        actionsOnStartingText = SKAction.sequence(actionsOnText)
        addChild(startingText)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentSceneStep == SceneSteps.waiting &&
            clickableButton.isClickable &&
            clickableButton.clickableFrame.contains(touches.first!.location(in: self)){
            startingText.removeFromParent()
            clickableButton.isClickable = false
            clickableButton.run(SKAction.moveTo(y: 80, duration: 1))
            currentSceneStep = SceneSteps.starting
        } else if currentSceneStep == SceneSteps.playingMusic &&
            clickableButton.isClickable &&
            clickableButton.clickableFrame.contains(touches.first!.location(in: self)) {
            
            reactDelegate?.didClick()
            clickableButton.isClickable = false
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func visualSoundsEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer) {
        for animation in EffectsDictionary {
            if numberOfAnimationsPerKind[animation]! < maxAmountPermitted && animation != KindOfEffect.click {
                numberOfAnimationsPerKind[animation]! += 1
                animatedEffects.append( myVisualEffects.get(effect: animation) )
                animatedEffects.last?.position = sceneCenter
                addChild(animatedEffects.last!)
                break
            }
        }
        
        for effect in animatedEffects {
            effect.convertIntoAction(sound: sound, onScene: self)
            effect.draw(intoScene: self)
        }
        
    }
    
    
    
    func nextSoundEnablingVisualEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer) {
        clickableButton.isClickable = true
    }
    
    func nextSoundDisablingVisualEffect (isExecutingSound sound: (ChordNames, Octave, NoteDuration), in player: SoundPlayer) {
        clickableButton.isClickable = false
    }
    
    func removeChords(){
        chords.removeAll()
    }
    
    func addChord(chord: (ChordNames, Octave, NoteDuration)){
        chords.append(chord)
    }
    
    func addChords(newChords: [(ChordNames, Octave, NoteDuration)]) {
        for chord in newChords {
            chords.append(chord)
        }
    }
    
    func execute(){
        mySong = Song(instrument: instrument, chords: chords, forScene: self)
        reactDelegate = mySong.player
        mySong.player.delegate = self
    }
    
}

//inizialize and present the VisualScene above
public class VisualView: SKView {
    var onSceneCreation: ((Sounds) -> Void)?
    let width = 600
    let height = 400
    override public func willMove(toWindow newWindow: UIWindow?) {
        
        let scene = VisualScene(size: CGSize(width: width, height: height))
        scene.scaleMode = .aspectFill
        
        self.presentScene(scene)
        self.ignoresSiblingOrder = true
        self.onSceneCreation?(Sounds (scene: scene))
    }
    
    public func giveInstructions (completion: @escaping (Sounds) -> Void) { self.onSceneCreation = completion
    }
}

//handles the automatic scaling of the text based on the size of the window
extension SKLabelNode {
    func adjustLabelFontSizeToFitRect( rect:CGRect) {
        let scalingFactor = min( (rect.width * 2/3) / self.frame.width, (rect.height * 2/3) / self.frame.height)
        self.fontSize *= scalingFactor
        self.position = CGPoint(x: rect.midX, y: rect.midY * 4/3)
    }
}
