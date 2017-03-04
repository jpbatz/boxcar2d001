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
    
    
    
    let CarBodyCategory  : UInt32 = 0x1 << 1
    
    let WheelCategory: UInt32 = 0x1 << 2
    
    var returnCar = SKSpriteNode()
    
    var backWheel = SKSpriteNode()
    
    var frontWheel = SKSpriteNode()
    
    func initRandomCar() -> SKSpriteNode {
    
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
