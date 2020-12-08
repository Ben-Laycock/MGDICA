//
//  GameScene.swift
//  ICA Project
//
//  Created by LAYCOCK, BEN (Student) on 05/11/2020.
//  Copyright © 2020 LAYCOCK, BEN (Student). All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import CoreMotion


class GameScene: SKScene
{
    
    // Scenes
    var mGameOverScene : GameOverScene!
    var mMainMenuScene : MainMenuScene!
    
    // Screen
    let mScreenWidth = UIScreen.main.bounds.width
    let mScreenHeight = UIScreen.main.bounds.height
    
    // Textures
    let mVirusTexture = SKTexture(imageNamed: "Virus")
    let mBombTexture = SKTexture(imageNamed: "Mine")
    let mCoreTexture = SKTexture(imageNamed: "Core")
    let mBoomTexture = SKTexture(imageNamed: "BOOM")
    
    // Viruses
    let mNumOfViruses = 50
    var mActiveViruses = Set<Virus>()
    var mInactiveViruses = Set<Virus>()
    
    // Bombs
    let mNumOfBombs = 10
    var mActiveBombs = Set<Bomb>()
    var mInactiveBombs = Set<Bomb>()
    
    // Core
    let mCoreStartingHealth = 20
    var mCore : Core!
    
    // Game Settings
    var mCurrentWave = 1
    
    // Audio
    var mAudioPlayer1 = AVAudioPlayer()
    
    // Score
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var mScore = 0
    {
        didSet
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formatteScore = formatter.string(from: mScore as NSNumber) ?? "0"
            mScoreLabel.text = "SCORE: \(formatteScore)"
        }
    }
    
    // Core Health Display
    let mCoreHealthLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    // Device Motion
    let mMotionManager = CMMotionManager()
    // Accelerometer
    var mAccelerationThreshold = 2.0
    // Gyroscope variables
    var mAccelerometerVector = CGVector.zero
    
    // Particles
    let explosionParticles = SKEmitterNode(fileNamed: "Explosion.sks")
    let virusDeathParticles = SKEmitterNode(fileNamed: "VirusDestruction.sks")
    
    // Sounds
    let beepSound = SKAction.playSoundFileNamed("Sounds/Beep.mp3", waitForCompletion: true)
    
    var swipeRightGR : UISwipeGestureRecognizer!
    var swipeLeftGR : UISwipeGestureRecognizer!
    
    var mHasCompleteSetup = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup
        {
           return
        }
        
        swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        swipeRightGR.direction = .right
        self.view?.addGestureRecognizer(swipeRightGR)
        
        swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        swipeLeftGR.direction = .left
        self.view?.addGestureRecognizer(swipeLeftGR)
        
        // Setup Core
        mCore = Core(texture: mCoreTexture, color: UIColor.clear, size: mCoreTexture.size(), health: mCoreStartingHealth)
        mCore.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mCore.size = CGSize(width: mCoreTexture.size().width, height: mCoreTexture.size().height) * 0.4
        mCore.isUserInteractionEnabled = false
        addChild(mCore)
        
        // Setup Viruses
        SetupViruses()
        
        // Setup Bombs
        SetupBombs()
        
        // Score label
        mScoreLabel.fontSize = 72
        mScoreLabel.position = CGPoint(x: mScreenWidth/2, y: mScoreLabel.fontSize/2)
        mScoreLabel.text = "SCORE: 0"
        mScoreLabel.zPosition = 100
        mScoreLabel.horizontalAlignmentMode = .center
        addChild(mScoreLabel)
        
        // Core health label
        mCoreHealthLabel.fontSize = 48
        mCoreHealthLabel.position = CGPoint(x: mScreenWidth/2, y: mScreenHeight/2)
        mCoreHealthLabel.text = "\(mCore.mHealth)"
        mCoreHealthLabel.zPosition = 100
        mCoreHealthLabel.horizontalAlignmentMode = .center
        addChild(mCoreHealthLabel)
        
        // Sounds
        let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        do
        {
            mAudioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch
        {
            print(error)
        }
        
        // Start motion manager (Accelerometer)
        mMotionManager.startAccelerometerUpdates()
    
        mHasCompleteSetup = true
        
    }
    
    
    @objc func manageSwipe(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case .right:
            print("Right")
        case .left:
            print("Left")
        default:
            return
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        //let sound = Bundle.main.path(forResource: "Sounds/Beep.mp3", ofType: nil)
        //self.run(playSound)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        for touch in touches
        {
            let pos = touch.location(in: self) // Position of the touch
            //let node = atPoint(pos) // Node at the touch position
            
            let nodeArr = nodes(at: pos)
            
            // What happens per touched object type?
            for node in nodeArr
            {

                // Virus
                if node is Virus
                {
                    let currentVirus = node as! Virus
                    currentVirus.DecreaseHealth(by: 1)
                    
                    // Check if virus died
                    if currentVirus.IsDead()
                    {
                        addParticle(pos: node.position, particle: virusDeathParticles!)
                        mScore += 1;
                        mActiveViruses.remove(currentVirus)
                        mInactiveViruses.insert(currentVirus)
                    }
                }
                
                // Bomb
                if node is Bomb
                {
                    view?.Shake(horizontalShake: CGFloat.random(in: -50.0...50.0), verticalShake: CGFloat.random(in: -50.0...50.0))
                 
                    addParticle(pos: node.position, particle: explosionParticles!)
                    
                    let currentBomb = node as! Bomb
                    
                    // Look for all viruses near the bomb
                    for virus in mActiveViruses
                    {
                        let dirToVirus = virus.position.ToVector() - currentBomb.position.ToVector()
                        let distToVirus = dirToVirus.Mag()
                        
                        if Float(distToVirus) <= currentBomb.mExplosionRadius
                        {
                            virus.DecreaseHealth(by: currentBomb.mExplosionDamage)
                            if virus.IsDead()
                            {
                                addParticle(pos: virus.position, particle: virusDeathParticles!)
                                mScore += 1;
                                mActiveViruses.remove(virus)
                                mInactiveViruses.insert(virus)
                            }
                        }
                    }
                    
                    // Remove bomb
                    currentBomb.mIsAlive = false
                    mActiveBombs.remove(currentBomb)
                    mInactiveBombs.insert(currentBomb)
                }
                
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    func addParticle(pos p: CGPoint, particle pS: SKEmitterNode)
    {
        
        let particleToAdd = pS.copy() as! SKEmitterNode
        
        particleToAdd.position = p
        particleToAdd.isUserInteractionEnabled = false
        
        let addParticle = SKAction.run({self.addChild(particleToAdd)})

        let particleDuration = particleToAdd.particleLifetime

        let wait = SKAction.wait(forDuration: TimeInterval(particleDuration))

        let removeParticle = SKAction.run({particleToAdd.removeFromParent()})

        let sequence = SKAction.sequence([addParticle, wait, removeParticle])

        self.run(sequence)
        
    }
    

    override func update(_ currentTime: TimeInterval)
    {
        
        // Accelerometer
        if let accelerometer = mMotionManager.accelerometerData
        {
            if abs(accelerometer.acceleration.z) > mAccelerationThreshold
            {
                print("Shake \(Float.random(in: 1.0...100.0))")
                // What should happen when the device is shaken?
                // Push viruses to edge of the screen
            }
            
            let newAccelerometerVector = CGVector(dx: -accelerometer.acceleration.y, dy: accelerometer.acceleration.x)
            
            mAccelerometerVector = newAccelerometerVector.Norm()
        }
        
        
        // Check if game should end
        if mCore.IsDead()
        {
            mGameOverScene.mScoreFromLastGame = mScore

            // Load game over scene
            loadGameOverScene()
        }

    
        // Update viruses
        for virus in mInactiveViruses
        {
            virus.Update()
        }
        
        for virus in mActiveViruses
        {
            // Update the virus
            virus.Update()

            if CGVector.Dist(virus.position, mCore.position) < mCore.size.width/2
            {
                mCore.mHealth -= virus.mDamage
                virus.mHealth = 0
                mActiveViruses.remove(virus)
                mInactiveViruses.insert(virus)
            }
            
            if virus.IsDead()
            {
                //addParticle(pos: virus.position, particle: virusDeathParticles!)
                mActiveViruses.remove(virus)
                mInactiveViruses.insert(virus)
            }
            
            // Animate Virus
            let origionalScale = mVirusTexture.size().width * 0.2
            let modification = CGFloat(abs(sin(virus.mTimeSpawned + currentTime)))
            let newScale = origionalScale + (origionalScale * modification)
            let resizeVirus = SKAction.resize(toWidth: newScale, height: newScale, duration: 0.5)
            virus.run(resizeVirus)
        }
        
        // Bombs
        for bomb in mInactiveBombs
        {
            bomb.mMovementDirection = mAccelerometerVector
            bomb.mIsAlive = false // Inactive bombs shouldn't be alive
            bomb.Update()
        }
        
        for bomb in mActiveBombs
        {
            // Manage current active bombs
            bomb.mMovementDirection = mAccelerometerVector
            bomb.Update()
        }
        
        // Random spawning of viruses
        let randomSide = Int.random(in: 0...1)
        let randomPosY = Float.random(in: 1.0...Float(mScreenHeight))
        let posX = randomSide == 0 ? -mVirusTexture.size().width : mScreenWidth + mVirusTexture.size().width
 
        var pos = CGPoint(x: posX, y: CGFloat(randomPosY))
        
        if mActiveViruses.count <= 5
        {
            SpawnVirus(at: pos, health: 1, speed: 50.0, currentTime: currentTime)
        }
        
        pos = CGPoint(x: CGFloat(Float.random(in: 1.0...Float(mScreenWidth))), y: CGFloat(Float.random(in: 1.0...Float(mScreenHeight))))
        
        // Limit scene to 1 bomb
        if mActiveBombs.count <= 0
        {
            SpawnBomb(at: pos, speed: 50.0, explosionRange: 200.0, explosionDamage: 5)
        }
        
        // Update core health label
        mCoreHealthLabel.text = "\(mCore.mHealth)"
        
    }
    
    
    func CreateVirus(health h: Int,
                     movementSpeed mS: Float) -> (Virus)
    {
        let newVirus = Virus(imageNamed: "Virus")
        newVirus.Setup(health: h, speed: mS, timeSpawned: 0.0, damage: 1)
        
        return newVirus;
    }
    
    func SpawnVirus(at p: CGPoint, health h: Int, speed s: Float, currentTime t: Double)
    {
        
        if mInactiveViruses.isEmpty
        {
            return
        }
        
        let inactiveVirus = mInactiveViruses.popFirst()
        mActiveViruses.insert(inactiveVirus!)
        
        inactiveVirus?.position = p
        inactiveVirus?.Setup(health: h, speed: s, timeSpawned: t, damage: 1)
        
    }
    
    func SetupViruses()
    {
        
        for _ in 1...mNumOfViruses
        {
            // Start viruses with 0 health (Assign health later)
            let newVirus = CreateVirus(health: 0, movementSpeed: 20.0)
            
            mInactiveViruses.insert(newVirus)
            
            newVirus.position = CGPoint(x: mScreenWidth - 100.0, y: mScreenHeight / 2)
            newVirus.size = CGSize(width: mVirusTexture.size().width, height: mVirusTexture.size().height) * 0.2
            newVirus.physicsBody = SKPhysicsBody(circleOfRadius: mVirusTexture.size().width)
            newVirus.physicsBody?.affectedByGravity = false
            newVirus.physicsBody?.collisionBitMask = 0x0

            newVirus.SetTarget(target: mCore.position)
            
            addChild(newVirus)
        }
        
    }
    
    
    func CreateBomb(texture tex: SKTexture,
                    movementSpeed mS: Float,
                    explosionRange eRange: Float,
                    explosionDamage eDamage: Int) -> (Bomb)
    {
        let newBomb = Bomb(texture: tex, color: UIColor.clear, size: tex.size(), movementSpeed: mS, explosionRange: eRange, explosionDamage: eDamage)
        
        return newBomb;
    }
    
    func SpawnBomb(at p: CGPoint,
                   speed s: Float,
                   explosionRange eRange: Float,
                   explosionDamage eDamage: Int)
    {
        
        if mInactiveBombs.isEmpty
        {
            return
        }
        
        let inactiveBomb = mInactiveBombs.popFirst()
        mActiveBombs.insert(inactiveBomb!)
        
        inactiveBomb?.position = p
        inactiveBomb?.mMovementDirection = CGVector.zero
        inactiveBomb?.mMovementSpeed = s
        inactiveBomb?.mExplosionRadius = eRange
        inactiveBomb?.mExplosionDamage = eDamage
        
        inactiveBomb?.physicsBody?.velocity = CGVector.zero
        
        inactiveBomb?.mIsAlive = true
        
    }
    
    
    func SetupBombs()
    {
        
        for _ in 1...mNumOfBombs
        {
            let newBomb = CreateBomb(texture: mBombTexture, movementSpeed: 20.0, explosionRange: 200.0, explosionDamage: 5)
            
            mInactiveBombs.insert(newBomb)
            
            newBomb.position = CGPoint(x: mScreenWidth - 100.0, y: mScreenHeight / 2)
            newBomb.size = CGSize(width: mBombTexture.size().width, height: mBombTexture.size().height) * 0.4
            newBomb.physicsBody = SKPhysicsBody(circleOfRadius: mBombTexture.size().width)
            newBomb.physicsBody?.affectedByGravity = false
            newBomb.physicsBody?.collisionBitMask = 0x00000000

            newBomb.mScreenWidth = mScreenWidth
            newBomb.mScreenHeight = mScreenHeight
            newBomb.mIsAlive = false
            
            addChild(newBomb)
        }
        
    }
    
    func ResetScene() -> (Bool)
    {
        
        // Viruses
        for virus in mActiveViruses
        {
            mActiveViruses.remove(virus)
            mInactiveViruses.insert(virus)
            virus.Update()
        }
        
        // Bombs
        for bomb in mActiveBombs
        {
            bomb.mIsAlive = false
            mActiveBombs.remove(bomb)
            mInactiveBombs.insert(bomb)
            bomb.Update()
        }
        
        // Core
        mCore.mHealth = mCoreStartingHealth
        
        // Score
        mScore = 0
        mScoreLabel.text = "SCORE: 0"
        
        // Game Settings
        mCurrentWave = 1
        
        return true
        
    }
    
    func loadGameOverScene()
    {
        view?.presentScene(mGameOverScene, transition: .reveal(with: SKTransitionDirection.up, duration: 1.0))
    }
    
    func loadMainMenuScene()
    {
        view?.presentScene(mMainMenuScene, transition: .reveal(with: SKTransitionDirection.right, duration: 1.0))
    }

}
