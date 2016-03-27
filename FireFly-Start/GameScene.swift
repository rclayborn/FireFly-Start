//
//  GameScene.swift
//  FireFly-Start
//
//  Created by Randall Clayborn on 3/26/16.
//  Copyright (c) 2016 claybear39. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //declare Globally
    let playerSpeed: CGFloat = 150.0
    let beeSpeed: CGFloat = 75.0
    
    var goal: SKSpriteNode?
    var player: SKSpriteNode?
    var bees: [SKSpriteNode] = []
    
    var lastTouch: CGPoint? = nil
    
    override func didMoveToView(view: SKView) {
        
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        //set a physic body around the view so player can't go out of playing area.
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //setup layer
        //player = self.childNodeWithName("player") as? SKSpriteNode
        
        //setup Enemy
        /* for child in self.children {
         if child.name == "bees" {
         if let child = child as? SKSpriteNode {
         bees.append(child)
         }
         }
         }*/
        
        // goal = self.childNodeWithName("goal") as? SKSpriteNode
        // Setup initial camera position
        updateCamera()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(touches: Set<UITouch>) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            lastTouch = touchLocation
        }
    }
    
    override func didSimulatePhysics() {
        if let _ = player {
            updatePlayer()
            updateBee()
        }
    }
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
    }
    
    // Updates the player's position by moving towards the last touch made
    func updatePlayer() {
        if let touch = lastTouch {
            let currentPosition = player!.position
            if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
                
                let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
                let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
                
                player!.runAction(rotateAction)
                
                let velocotyX = playerSpeed * cos(angle)
                let velocityY = playerSpeed * sin(angle)
                
                let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
                player!.physicsBody!.velocity = newVelocity;
                updateCamera()
            } else {
                player!.physicsBody!.resting = true
            }
        }
    }
    
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
        }
    }
    
    // Updates the position of all zombies by moving towards the player
    func updateBee() {
        let targetPosition = player!.position
        
        for bee in bees {
            let currentPosition = bee.position
            
            let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            bee.runAction(rotateAction)
            
            let velocotyX = beeSpeed * cos(angle)
            let velocityY = beeSpeed * sin(angle)
            
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            bee.physicsBody!.velocity = newVelocity;
        }
    }
    
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react to the contact between the two nodes
        if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == bees[0].physicsBody?.categoryBitMask {
            // Player & bees
            gameOver(false)
        } else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            // Player & Goal
            gameOver(true)
        }
    }
    
    private func gameOver(didWin: Bool) {
        print("- - - Game Ended - - -")
        let menuScene = MenuScene(size: self.size)
        //menuScene.soundToPlay = didWin ? "win.mp3" : "lose.mp3"
        let transition = SKTransition.flipVerticalWithDuration(1.0)
        menuScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(menuScene, transition: transition)
    }
    
}


