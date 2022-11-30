//
//  IceShard.swift
//  Cat.io
//
//  Created by Jacob Wise on 11/30/22.
//

import Foundation
import SpriteKit
class IceShard: SKSpriteNode
{
    let shardParticle = SKEmitterNode(fileNamed: "IceShard")!
    let shardFadeTime: Double = 0.1
    let shardRange: CGFloat = 600.0
    let shardSpeed: CGFloat = 600.0
    var shardDuration: CGFloat = 0.0
    
    var shardEndPoint = CGPoint()
    
    init(startPos: CGPoint, endPos: CGPoint) {
        super.init(texture: SKTexture(), color: .white, size: CGSize(width: 0, height: 0))
        position = startPos
        shardEndPoint = endPos
        
        shardDuration = shardRange / shardSpeed
        
        addShardParticle()
        addShardActions()
        
    }
    
    func addShardParticle()
    {
        shardParticle.targetNode = self
        shardParticle.emissionAngle = CGFloat(-atan2(shardEndPoint.x - position.x, shardEndPoint.y - position.y) - .pi/2)
        
        addChild(shardParticle)
    }
    
    func addShardActions()
    {
        let shardMove = SKAction.move(to: shardEndPoint, duration: Double(shardDuration))
        let shardFade = SKAction.fadeOut(withDuration: shardFadeTime)
        
        run(SKAction.sequence([shardMove, shardFade, .removeFromParent()]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
