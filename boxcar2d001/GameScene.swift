//
//  GameScene.swift
//  boxcar2d001
//
//  Created by David Neely on 2/25/17.
//  Copyright © 2017 David Neely. All rights reserved.
//

import SpriteKit

import GameplayKit

class GameScene: SKScene {
    
    let RedBallCategory  : UInt32 = 0x1 << 1
    
    let GreenBallCategory: UInt32 = 0x1 << 2
    
    var hack_scene_loading_issue_loaded = 0 // sceneDidLoad gets called twice sometimes, guards against
    
    var backWheel = SKSpriteNode()
    
    var frontWheel = SKSpriteNode()
    
    var carBody = SKSpriteNode()
    
    var entities = [GKEntity]()
    
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    var isCreated: Bool = false
    
    var world: SKNode?
    
    var overlay: SKNode?
    
    var myCamera: SKNode?
    
    override func didMove(to view: SKView) {
        
        if !isCreated {
            
            isCreated = true
            
            // World setup
            // ~ REMEBER: Add all physics bodies to self.world ~
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.world = SKNode()
            self.world?.name = "world"
            addChild(self.world!)
            
            // Sets up Camera
            self.myCamera = SKNode()
            self.myCamera?.name = "camera"
            self.world?.addChild(self.myCamera!)
            
            // Sets up Overlay HUD // NOT IMPLEMENTED
            self.overlay = SKNode()
            self.overlay?.zPosition = 10
            self.overlay?.name = "overlay"
            addChild(self.overlay!)
            
            if hack_scene_loading_issue_loaded == 0 {
                
                hack_scene_loading_issue_loaded = 1 // guards and gets called only once.
                
                initEdge()
                
                initCarBody()
                
                initBackWheel()
                
                initFrontWheel()
                
//                initGround()
                
                self.lastUpdateTime = 0
            }
        }
    }
    
    func centerOnNode(node: SKNode) {
        
        let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: node.parent!)
        
        node.parent?.position = CGPoint(x:(node.parent?.position.x)! - cameraPositionInScene.x,
                                        y:(node.parent?.position.y)! - cameraPositionInScene.y)
    }
    
    // Sets boundaries of physics simulator as edge of screen.
    
    func initEdge() {
        
        self.backgroundColor = .black
        
        self.scaleMode = .aspectFit
        
        world?.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect.init(x: -200,
                                                                     y: -200,
                                                                     width: 2000,
                                                                     height: (self.frame.size.height) ))
    }
    
    // Creates body of the car.
    
    func initCarBody() {
        
        carBody = SKSpriteNode(imageNamed: "car")
        
        carBody.position = CGPoint(x: 0, y: 0)
        
        carBody.physicsBody = SKPhysicsBody(texture: carBody.texture!, size: carBody.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        carBody.physicsBody?.categoryBitMask = RedBallCategory
        carBody.physicsBody?.contactTestBitMask = RedBallCategory
        carBody.physicsBody?.collisionBitMask = RedBallCategory
        
        carBody.physicsBody?.usesPreciseCollisionDetection = true
        
        carBody.physicsBody?.affectedByGravity = true
        
        carBody.physicsBody?.allowsRotation = true
        
        carBody.physicsBody?.friction = 0.5
        
        carBody.zRotation = CGFloat.pi / 2.7
        
        world!.addChild(carBody)
    }
    
    // Adds back wheel to car body.
    
    func initBackWheel() {
        
        backWheel = SKSpriteNode(imageNamed: "tire")
        
        backWheel.position = CGPoint(x: -120, y: -50)
        
        backWheel.physicsBody = SKPhysicsBody(texture: backWheel.texture!, size: backWheel.texture!.size())
        
        // assign phyics category to keep physics bodies separated
        // so the wheel can spin independently of the car body.
        backWheel.physicsBody?.categoryBitMask = GreenBallCategory
        backWheel.physicsBody?.contactTestBitMask = GreenBallCategory
        backWheel.physicsBody?.collisionBitMask = GreenBallCategory
        
        backWheel.physicsBody?.usesPreciseCollisionDetection = true
        
        backWheel.physicsBody?.affectedByGravity = true
        
        backWheel.physicsBody?.allowsRotation = true
        
        backWheel.physicsBody?.friction = 1.0
        
        backWheel.physicsBody?.pinned = true
        
        backWheel.zRotation = CGFloat.pi / 2
        
        backWheel.zPosition = 1
        
        carBody.addChild(backWheel)
    }
    
    // Adds front wheel to car body.
    
    func initFrontWheel() {
        
        frontWheel = SKSpriteNode(imageNamed: "tire")
        
        frontWheel.position = CGPoint(x: 150, y: -50)
        
        frontWheel.physicsBody = SKPhysicsBody(texture: frontWheel.texture!, size: frontWheel.texture!.size())
        
        frontWheel.physicsBody?.usesPreciseCollisionDetection = true
        
        frontWheel.physicsBody?.affectedByGravity = true
        
        frontWheel.physicsBody?.allowsRotation = true
        
        frontWheel.physicsBody?.friction = 1.0
        
        frontWheel.zRotation = CGFloat.pi / 2
        
        frontWheel.physicsBody?.pinned = true
        
        frontWheel.zPosition = 1
        
        carBody.addChild(frontWheel)
    }
    
    // Creates course for car to race on.
    
    func initGround() { //TODO: Update ground to set terrain
        
        var splinePoints = [CGPoint(x: -350, y: 200),
                            CGPoint(x: -100, y: -250),
                            CGPoint(x: 100, y: 100),
                            CGPoint(x: 240, y: 200)]
        
        let ground = SKShapeNode(splinePoints: &splinePoints, count: splinePoints.count)
        
        ground.lineWidth = 50
        
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        
        ground.physicsBody?.restitution = 0.75
        
        ground.physicsBody?.isDynamic = false
        
        world!.addChild(ground)
    }
    
    // Loops the game. Put your acceleration code here.
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        backWheel.physicsBody?.applyTorque(-1.0) // Acceleration code
        
        centerOnNode(node: carBody) // makes camera follow the position of the car.

    }
}
