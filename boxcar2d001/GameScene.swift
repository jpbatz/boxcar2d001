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
    
    var hack_scene_loading_issue_loaded = 0 // sceneDidLoad gets called twice sometimes, guards against that.
    
    
    var backWheel = SKSpriteNode()
    
    var frontWheel = SKSpriteNode()
    
    var carBody = SKSpriteNode()
    
    var entities = [GKEntity]()
    
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    
    // Flag indicating whether we've setup the camera system yet.
    var isCreated: Bool = false
    // The root node of your game world. Attach game entities
    // (player, enemies, &c.) to here.
    var world: SKNode?
    // The root node of our UI. Attach control buttons & state
    // indicators here.
    var overlay: SKNode?
    // The camera. Move this node to change what parts of the world are visible.
    var myCamera: SKNode?
    
    override func didMove(to view: SKView) {
        if !isCreated {
            isCreated = true
            
            // Camera setup
            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.world = SKNode()
            self.world?.name = "world"
            addChild(self.world!)
            self.myCamera = SKNode()
            self.myCamera?.name = "camera"
            self.world?.addChild(self.myCamera!)
            
            // UI setup
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
                
                initGround()
                
                
                
                self.lastUpdateTime = 0
            }

        }
    }
    
  
    func centerOnNode(node: SKNode) {
        let cameraPositionInScene: CGPoint = node.scene!.convert(node.position, from: node.parent!)
        
        node.parent?.position = CGPoint(x:(node.parent?.position.x)! - cameraPositionInScene.x, y:(node.parent?.position.y)! - cameraPositionInScene.y)
    }
    override func sceneDidLoad() {
        
          }
    
    
    // Sets boundaries of physics simulator as edge of screen.
    
    func initEdge() {
        
        self.backgroundColor = .black
        
        self.scaleMode = .aspectFit
        
        world?.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect.init(x: -200, y: -200, width: 2000, height: (self.frame.size.height) ))
    }
    
    // Creates body of the car.
    
    func initCarBody() {
        
        carBody = SKSpriteNode(imageNamed: "car")
        
        carBody.position = CGPoint(x: 0, y: 0)
        
        carBody.physicsBody = SKPhysicsBody(texture: carBody.texture!, size: carBody.texture!.size())
        
        
        // assign phyics category
        carBody.physicsBody?.categoryBitMask = RedBallCategory
        
        //Category is GreenBall
        carBody.physicsBody?.contactTestBitMask = RedBallCategory
        //Contact will be detected when GreenBall make a contact with RedBar or a Wall (assuming that redBar's masks are already properly set)
        carBody.physicsBody?.collisionBitMask = RedBallCategory
        //Collision will occur when GreenBall hits GreenBall, RedBall or hits a Wall
        
      
        
        
        carBody.physicsBody?.usesPreciseCollisionDetection = true
        
        carBody.physicsBody?.affectedByGravity = true
        
        carBody.physicsBody?.allowsRotation = true
        
        carBody.physicsBody?.friction = 0.5
        
        carBody.zRotation = CGFloat.pi / 2.7
        
        world!.addChild(carBody)
    }
    
//    func center(onNode node: SKNode) {
//    var cameraPosition = node.scene?.convert(node.position, from: node.parent!)
//        
//        myCamera.position.x = (cameraPosition?.x)!;
//
////        node.parent?.position = CGPoint.init(x: (node.parent?.position.x)!, y: (node.parent?.position.y)!)
//    }
    
    // Adds back wheel to car body.
    
    func initBackWheel() {
        
        backWheel = SKSpriteNode(imageNamed: "tire")
        
        backWheel.position = CGPoint(x: -120, y: -50)
        
        backWheel.physicsBody = SKPhysicsBody(texture: backWheel.texture!, size: backWheel.texture!.size())
        
        backWheel.physicsBody?.categoryBitMask = GreenBallCategory //Category is RedBall
        backWheel.physicsBody?.contactTestBitMask = GreenBallCategory  //Contact will be detected when RedBall make a contact with GreenBar , GreenBall or a Wall
        backWheel.physicsBody?.collisionBitMask = GreenBallCategory  //Collision will occur when RedBall meets RedBall, GreenBall or hits a Wall
        
        
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
    
    func initGround() {
        
        var splinePoints = [CGPoint(x: -350, y: 200),
//                            CGPoint(x: -100, y: -250),
//                            CGPoint(x: 100, y: 100),
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
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
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
        centerOnNode(node: carBody)

    }
    override func didSimulatePhysics() {
    }
}



