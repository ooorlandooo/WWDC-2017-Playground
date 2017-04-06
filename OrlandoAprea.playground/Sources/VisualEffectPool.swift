//  VisualEffectPool.swift
//  WWDC
//
//  Created by Orlando Aprea on 24/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.

import Foundation
import UIKit
import SpriteKit



//this is a pool of animations preallocated so that the simulation is not loaded with the animations creation operations, during the execution. When an animation is needed then is taken from here
class VisualEffectsPool {
    static let shared = VisualEffectsPool()
    var effects: [KindOfEffect:[VisualEffect]] = [KindOfEffect:[VisualEffect]]()
    var click: ClickableEffect!
    
    
    private init(){
        for effect in EffectsDictionary {
            if effect != KindOfEffect.click {
                effects[effect] = [VisualEffect]()
                for _ in 0...3 {
                    let count = effects[effect]!.count
                    effects[effect]?.append(VisualEffect(effect: effect, named:  "\(effect.rawValue)\(count)")!)
                }
            }
        }
        click = ClickableEffect(effect: KindOfEffect.click, named: KindOfEffect.click.rawValue)
    }
    
    func getClickableEffect() -> ClickableEffect{
        return click
    }
    
    func get( effect: KindOfEffect ) -> VisualEffect {
        return effects[effect]!.removeLast()
    }
    
    func add ( effect: KindOfEffect ) {
        effects[effect]?.append(VisualEffect(effect: effect, named: "\(effect.rawValue)\(effects[effect]!.count)")!)
    }
    
    
}


