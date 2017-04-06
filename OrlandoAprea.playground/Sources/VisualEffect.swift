//
//  VisualEffect.swift
//  WWDC
//
//  Created by Orlando Aprea on 28/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

import Foundation
import SpriteKit


//handles the creation of the animated effects using, the templates sks uploaded into the resource folder
//also handles the transformation of the animations, given a specific sound input
class VisualEffect: SKEmitterNode {
    var myKind: KindOfEffect!
    static var pathToFollow: [KindOfEffect:Group] = [:]
    
    convenience init?(effect: KindOfEffect , named: String) {
        self.init()
        self.init(fileNamed: effect.rawValue)
        self.myKind = effect
        self.particleTexture = SKTexture(imageNamed: "spark.png")
        self.name = named
        self.zPosition = 0
        self.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.physicsBody?.isDynamic  = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    
    var currentAction:SKAction!
    var customizableColorRamp: SKKeyframeSequence!
    
    func draw( intoScene: VisualScene){
        self.targetNode = intoScene
        self.run(currentAction)
    }
    
    func convertIntoAction( sound: (ChordNames, Octave, NoteDuration), onScene: VisualScene) {
        let R = Float(ChordComposition[sound.0]![0].rawValue) / 11.0
        let G = Float(ChordComposition[sound.0]![1].rawValue) / 11.0
        let B = Float(ChordComposition[sound.0]![2].rawValue) / 11.0
        let A = Double(sound.1.rawValue) / 10.0
        let newColor = SKColor(red: CGFloat(R), green: CGFloat(G), blue: CGFloat(B), alpha: CGFloat(A))
        
        let colorAction = SKAction.customAction(withDuration: sound.2.rawValue - 0.1){_,_ in
            self.particleColorSequence = SKKeyframeSequence(keyframeValues: [newColor], times: [0.0])
        }
        
        if VisualEffect.pathToFollow[myKind] == nil {
            let randGroup = Int(arc4random_uniform(UInt32(onScene.groups.count)))
            VisualEffect.pathToFollow[myKind] = onScene.groups[randGroup]
            for target in (VisualEffect.pathToFollow[myKind]?.targets)! {
                target.isUsed[myKind] = false
            }
        }
        
        let pos =  VisualEffect.pathToFollow[myKind]?.chooseTarget( forEffect: myKind)?.position
        if let nextPos = pos {
            let movement = SKAction.move(to: nextPos , duration: sound.2.rawValue - 0.1 )
            currentAction = SKAction.group([colorAction, movement])
        }else {
            currentAction = SKAction.group([colorAction])
        }
    }
    
}
//handles the creation of the button and the switch from active to inactive
class ClickableEffect: SKSpriteNode {
    let inactiveTexture: SKTexture = SKTexture(imageNamed: "ButtonInactive")
    let activeTexture: SKTexture = SKTexture(imageNamed: "ButtonActive")
    var clickableFrame: CGRect {
        let origin = CGPoint(x: self.position.x - 50 ,y: self.position.y - 50)
        let size = CGSize(width: 100, height: 100)
        return CGRect(origin: origin, size: size)
    }
    var colorRamp: SKKeyframeSequence! = nil
    var isClickable: Bool = false {
        didSet {
            if isClickable {
                self.texture = activeTexture
            } else {
                self.texture = inactiveTexture
            }
        }
        
    }
    
    convenience init(effect: KindOfEffect , named: String) {
        let texture = SKTexture(imageNamed: "ButtonInactive")
        self.init(texture: texture, color: .clear, size: CGSize(width:100, height:100))
        //self.init(imageNamed: "ButtonInactive")
        self.name = named
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.physicsBody?.isDynamic  = false
    }
    
    
}

