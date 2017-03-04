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
    
    let randomCar = RandomCar()
    
    // Sets categories to keep physics separated.
    
    let CarBodyCategory  : UInt32 = 0x1 << 1
    
    let WheelCategory: UInt32 = 0x1 << 2
    
    var sceneHasLoaded = 0 // sceneDidLoad gets called twice sometimes, guards against
    
    var backWheel = SKSpriteNode()
    
    var frontWheel = SKSpriteNode()
    
    var carBody = SKSpriteNode()
    
    var ground = SKShapeNode()
    
    var backgroundImage = SKSpriteNode()
    
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
            
            if sceneHasLoaded == 0 {
                
                sceneHasLoaded = 1
                
                createRandomCar()
                
                initGround()
                
                initHUD()
                
//                initEdge()
                
                initBackground()
                
                hideAllSprites()
                
                
                
                self.lastUpdateTime = 0
            }
        }
    }
    
    func createRandomCar() {
        
        carBody = randomCar.initRandomCar()
        
        world!.addChild(carBody)
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
    
    
    func hideAllSprites() {
        
        carBody.alpha = 0.0
        
        frontWheel.alpha = 0.0
        
        backWheel.alpha = 0.0
        
        ground.alpha = 0.0
        
        backgroundImage.alpha = 0.0
    }

    
    // Creates course for car to race on.
    
    func initGround() { //TODO: Update ground to set terrain
        
        var splinePoints = [CGPoint(x: -300, y: 300),
                            CGPoint(x: 300, y: 0),
                            CGPoint(x: 600, y: 20),
                            CGPoint(x: 900, y: 0),
                            CGPoint(x: 1200, y: 30),
                            CGPoint(x: 1800, y: 0),
                            CGPoint(x: 2000, y: -20)]
        
        ground = SKShapeNode(splinePoints: &splinePoints, count: splinePoints.count)
        
        ground.lineWidth = 15
        
        ground.strokeColor = .green
        
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        
        ground.physicsBody?.restitution = 0.00
        
        ground.physicsBody?.isDynamic = false
        
        world!.addChild(ground)
    }
    
    // Creates Heads Up Display
    
    func initHUD() {
        
        let gasButton = SKSpriteNode(imageNamed: "gasButton")
        
        gasButton.position = CGPoint(x: 200, y: -300)
        
        overlay?.addChild(gasButton)
    }
    
    // Create the atmosphere of the game :)
    
    func initBackground() {
        
        backgroundImage = SKSpriteNode(imageNamed: "art")
        
        backgroundImage.position = CGPoint(x: 0, y: 0)
        
        world?.addChild(backgroundImage)
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
        
        //backWheel.physicsBody?.applyTorque(-1.1) // Acceleration code
        
        centerOnNode(node: carBody) // makes camera follow the position of the car.
        
        // reset game if car is at rest

        if(carBody.physicsBody?.isResting == true) {
            
            //TODO: Reset physics forces on carBody
            
            carBody.position = CGPoint(x: 0, y: 400)
            
            carBody.zRotation = CGFloat.pi / 2.7
            
            print("The game has been reset as the car was at rest.")
        }
        
        // reset game on car falling off of ground
        
        if(carBody.position.y <= -1000) {
            
            //TODO: Reset physics forces on carBody
            
            carBody.position = CGPoint(x: 0, y: 400)
            
            carBody.zRotation = CGFloat.pi / 2.7
            
            print("The game has been reset as the car has fallen off track.")
        }
    }
}
