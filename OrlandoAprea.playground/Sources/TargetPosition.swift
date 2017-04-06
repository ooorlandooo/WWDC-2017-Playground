//
//  TargetPosition.swift
//  WWDC
//
//  Created by Orlando Aprea on 30/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

import Foundation
import SpriteKit


//this to classes handle the crations of paths to be used by the animations, in a manner that animations, move in a simmetric way
class Group{
    let name: String
    var scene: VisualScene
    var targets: [TargetPosition] = [TargetPosition]()
    
    private let positions: [(Int, Int)] = [(1,1), (-1,-1), (1,-1), (-1,1), ]
    
    
    // create some circles with hidden nodes at the center of the simulation, to be used as paths
    init(name: String, scene: VisualScene, angleBias: Double, radiusCut: Double){
        var angle = angleBias
        self.scene = scene
        self.name = name
        for i in positions.enumerated(){
            let target = TargetPosition(name: "target", position: CGPoint(x:scene.sceneCenter.x +
                CGFloat(Double(i.element.0) * sin(angle * M_PI / 180.0)) * (scene.sceneCenter.x / CGFloat(radiusCut)),
                                                                          y:scene.sceneCenter.y +
                                                                            CGFloat(Double(i.element.1) * cos(angle * M_PI / 180.0)) * (scene.sceneCenter.y / CGFloat(radiusCut))))
            self.targets.append(target)
            scene.addChild(target)
            if angleBias == 0 && i.offset%2 == 0 {
                angle += 90
            }
        }
    }
    
    
    //choose the next path to execute for a specific kind of animation
    func chooseTarget( forEffect: KindOfEffect)-> TargetPosition?{
        for target in targets {
            if target.isUsed[forEffect] == false {
                target.isUsed[forEffect] = true
                return target
            }
        }
        return TargetPosition( position: scene.sceneCenter)
    }
}


class TargetPosition: SKNode {
    var isUsed: [KindOfEffect:Bool] = [:]
    
    init(name: String, position: CGPoint) {
        super.init()
        self.name = name
        self.position = position
    }
    
    
    init(position: CGPoint) {
        super.init()
        self.position = position
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
