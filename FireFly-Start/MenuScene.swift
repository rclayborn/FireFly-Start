//
//  MenuScene.swift
//  FireFly
//
//  Created by Randall Clayborn on 3/25/16.
//  Copyright © 2016 claybear39. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    var soundToPlay: String?
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)
        
        // Setup label
        let label = SKLabelNode(text: "Press anywhere to play again!")
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 55
        label.fontColor = UIColor.whiteColor()
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        // Play sound
        if let soundToPlay = soundToPlay {
            self.runAction(SKAction.playSoundFileNamed(soundToPlay, waitForCompletion: false))
        }
        
        self.addChild(label)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        let skView = self.view as SKView!
        gameScene?.scaleMode = .AspectFill
        skView.presentScene(gameScene!, transition: transition)
    }
}
