//
//  RandomCar.swift
//  boxcar2d001
//
//  Created by David Neely on 3/4/17.
//  Copyright © 2017 David Neely. All rights reserved.
//

import Foundation

import SpriteKit

class RandomCar: SKSpriteNode {
    
    
    
    // Sets constants for randomly generated cars
    
    let NUMBER_OF_SPOKES = 7
    
    let NUMBER_OF_WHEELS = 3
    
    let MAX_WHEELS = 3
    
    let MAX_WHEEL_SIZE = 100
    
    let MAX_SPOKE_POSITION_X = 100
    
    let MAX_SPOKE_POSITION_Y = 100
    
    let MAX_TORQUE = 1.0
    
    
    
    // Physics
    
    let CarBodyCategory  : UInt32 = 0x1 << 1
    
    let WheelCategory: UInt32 = 0x1 << 2
    
    var returnCar = SKSpriteNode()
    
    var backWheel = SKSpriteNode()
    
    var frontWheel = SKSpriteNode()
    
    func createRandomCarBody() -> SKSpriteNode {
        
        // create random rotations for spokes
        
        var widths = [Int]()
        
        for _ in 0...NUMBER_OF_SPOKES {
            
            var randomInt = Int(arc4random_uniform(UInt32(self.MAX_SPOKE_POSITION_X)))
            
            if(randomInt % 2 == 0) {
                
                randomInt = randomInt * -1
            }
            
            widths.append(Int(randomInt))
        }
        
        // create random spoke lengths
        
        var heights = [Int]()
        
        for _ in 0...NUMBER_OF_SPOKES {
            
            var randomInt = Int(arc4random_uniform(UInt32(self.MAX_SPOKE_POSITION_Y)))
            
            if(randomInt % 2 == 0) {
                
                randomInt = randomInt * -1
            }
            
            heights.append(Int(randomInt))
        }
        
        // create car body with a body from a sprite
        
        returnCar = SKSpriteNode(imageNamed: "carBodyRandomPoint")
        
        returnCar.position = CGPoint(x: 0, y: 400)
        
        returnCar.physicsBody = SKPhysicsBody(texture: returnCar.texture!, size: returnCar.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        returnCar.physicsBody?.categoryBitMask = CarBodyCategory
        returnCar.physicsBody?.contactTestBitMask = CarBodyCategory
        returnCar.physicsBody?.collisionBitMask = CarBodyCategory
        
        returnCar.physicsBody?.usesPreciseCollisionDetection = true
        
        returnCar.physicsBody?.affectedByGravity = true
        
        returnCar.physicsBody?.allowsRotation = true
        
        returnCar.physicsBody?.friction = 0.5
        
        returnCar.zRotation = CGFloat.pi / 2.7
        
        for index in 1...NUMBER_OF_SPOKES {
            
            // Create spoke point
            
            let spokePoint = SKSpriteNode.init(imageNamed: "carSpokePoint")
            
            spokePoint.physicsBody = SKPhysicsBody(texture: returnCar.texture!, size: returnCar.texture!.size())
            
            // assign phyics category to keep physics bodies separated
            // so the wheel can spin independently of the car body.
            spokePoint.physicsBody?.categoryBitMask = CarBodyCategory
            spokePoint.physicsBody?.contactTestBitMask = CarBodyCategory
            spokePoint.physicsBody?.collisionBitMask = CarBodyCategory
            
            spokePoint.physicsBody?.usesPreciseCollisionDetection = false
            
            spokePoint.physicsBody?.affectedByGravity = false
            
            spokePoint.physicsBody?.allowsRotation = true
            
            spokePoint.physicsBody?.friction = 0.5
            
            spokePoint.zPosition = 1
            
            spokePoint.physicsBody?.pinned = true
            
            spokePoint.position = CGPoint(x: widths[index], y: heights[index])
            
            returnCar.addChild(spokePoint)
        }
        
        return returnCar
    }
    
    
    
    
    
    
    
    

    func initRegularCar() -> SKSpriteNode {
    
        returnCar = SKSpriteNode()
        
        // Creates body of the car.
        
        returnCar = SKSpriteNode(imageNamed: "car")
        
        returnCar.position = CGPoint(x: 0, y: 400)
        
        returnCar.physicsBody = SKPhysicsBody(texture: returnCar.texture!, size: returnCar.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        returnCar.physicsBody?.categoryBitMask = CarBodyCategory
        returnCar.physicsBody?.contactTestBitMask = CarBodyCategory
        returnCar.physicsBody?.collisionBitMask = CarBodyCategory
        
        returnCar.physicsBody?.usesPreciseCollisionDetection = true
        
        returnCar.physicsBody?.affectedByGravity = true
        
        returnCar.physicsBody?.allowsRotation = true
        
        returnCar.physicsBody?.friction = 0.5
        
        returnCar.zRotation = CGFloat.pi / 2.7
        
        //world!.addChild(returnCar) //TODO: Add code to gameScene
    
        addBackWheelTo(inputCarBody: returnCar)
        
        addFrontWheelTo(inputCarBody: returnCar)
    
        return returnCar
    }
    
    // Adds back wheel to car body.
    
    func addBackWheelTo(inputCarBody: SKSpriteNode) {
        
        backWheel = SKSpriteNode(imageNamed: "tire")
        
        backWheel.position = CGPoint(x: -120, y: -50)
        
        backWheel.physicsBody = SKPhysicsBody(texture: backWheel.texture!, size: backWheel.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        backWheel.physicsBody?.categoryBitMask = WheelCategory
        backWheel.physicsBody?.contactTestBitMask = WheelCategory
        backWheel.physicsBody?.collisionBitMask = WheelCategory
        
        backWheel.physicsBody?.usesPreciseCollisionDetection = true
        
        backWheel.physicsBody?.affectedByGravity = true
        
        backWheel.physicsBody?.allowsRotation = true
        
        backWheel.physicsBody?.friction = 1.0
        
        backWheel.physicsBody?.pinned = true
        
        backWheel.zRotation = CGFloat.pi / 2
        
        backWheel.zPosition = 1
        
        inputCarBody.addChild(backWheel)
    }
    
    func addFrontWheelTo(inputCarBody: SKSpriteNode) {
        
        frontWheel = SKSpriteNode(imageNamed: "tire")
        
        frontWheel.position = CGPoint(x: 150, y: -50)
        
        frontWheel.physicsBody = SKPhysicsBody(texture: frontWheel.texture!, size: frontWheel.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        frontWheel.physicsBody?.categoryBitMask = WheelCategory
        frontWheel.physicsBody?.contactTestBitMask = WheelCategory
        frontWheel.physicsBody?.collisionBitMask = WheelCategory
        
        frontWheel.physicsBody?.usesPreciseCollisionDetection = true
        
        frontWheel.physicsBody?.affectedByGravity = true
        
        frontWheel.physicsBody?.allowsRotation = true
        
        frontWheel.physicsBody?.friction = 1.0
        
        frontWheel.zRotation = CGFloat.pi / 2
        
        frontWheel.physicsBody?.pinned = true
        
        frontWheel.zPosition = 1
        
        inputCarBody.addChild(frontWheel)
    }
}



//TODO: Set a random toruqe on wheel
//TODO: Add negative ranges to height and width positions of spokes
