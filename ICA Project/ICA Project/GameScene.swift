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
    let mRedVirusTexture = SKTexture(imageNamed: "RedVirus")
    let mBombTexture = SKTexture(imageNamed: "Mine")
    let mCoreTexture = SKTexture(imageNamed: "Core")
    let mPillTexture = SKTexture(imageNamed: "Pill")
    let mBoomTexture = SKTexture(imageNamed: "BOOM")
    
    // Viruses
    let mNumOfViruses = 50
    var mActiveViruses = Set<Virus>()
    var mInactiveViruses = Set<Virus>()
    
    // Red Viruses
    let mNumOfRedViruses = 5
    var mActiveRedViruses = Set<RedVirus>()
    var mInactiveRedViruses =  Set<RedVirus>()
    
    // Bombs
    let mNumOfBombs = 10
    var mActiveBombs = Set<Bomb>()
    var mInactiveBombs = Set<Bomb>()
    
    // Pill
    var mPillObject : Pill!
    
    // Core
    let mCoreStartingHealth = 20
    var mCore : Core!
    
    // Game Settings
    var mCurrentWave = 1
    
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

    // Accelerometer variables
    var mAccelerometerVector = CGVector.zero
    
    // Particles
    let mExplosionParticles = SKEmitterNode(fileNamed: "Explosion.sks")
    let mVirusDeathParticles = SKEmitterNode(fileNamed: "VirusDestruction.sks")
    let mRedVirusDeathParticles = SKEmitterNode(fileNamed: "RedVirusDestruction.sks")

    // Gestures
    var mSwipeRightGR : UISwipeGestureRecognizer!
    var mSwipeLeftGR : UISwipeGestureRecognizer!
    let mSwipePointAccuracy : CGFloat = 100.0
    
    // Audio System
    var mAudioSystem : AudioSystem!
    
    var mHasCompleteSetup : Bool = false
    
    override func didMove(to view: SKView)
    {
        
        if mHasCompleteSetup { return }
        
        mSwipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        mSwipeRightGR.direction = .right
        mSwipeRightGR.cancelsTouchesInView = false
        self.view?.addGestureRecognizer(mSwipeRightGR)
        
        mSwipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(manageSwipe))
        mSwipeLeftGR.direction = .left
        mSwipeLeftGR.cancelsTouchesInView = false
        self.view?.addGestureRecognizer(mSwipeLeftGR)
        
        // Setup Core
        mCore = Core(texture: mCoreTexture, color: UIColor.clear, size: mCoreTexture.size(), health: mCoreStartingHealth)
        mCore.position = CGPoint(x: mScreenWidth / 2, y: mScreenHeight / 2)
        mCore.size = CGSize(width: mCoreTexture.size().width, height: mCoreTexture.size().height) * 0.4
        mCore.isUserInteractionEnabled = false
        addChild(mCore)
        
        // Setup Viruses
        SetupViruses()
        
        // Setup RedViruses
        SetupRedViruses()
        
        // Setup Bombs
        SetupBombs()
        
        // Setup Pill
        mPillObject = Pill(imageNamed: "Pill")
        mPillObject.size = CGSize(width: mPillTexture.size().width, height: mPillTexture.size().height) * 0.4
        mPillObject.physicsBody = SKPhysicsBody(circleOfRadius: mVirusTexture.size().width)
        mPillObject.physicsBody?.affectedByGravity = false
        mPillObject.physicsBody?.collisionBitMask = 0x0
        addChild(mPillObject)
        
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
        
        // Start motion manager (Accelerometer)
        mMotionManager.startAccelerometerUpdates()
    
        // Setup audio system
        mAudioSystem = AudioSystem()
        mAudioSystem.Setup()
        
        mHasCompleteSetup = true
        
    }
    
    
    @objc func manageSwipe(gesture: UISwipeGestureRecognizer)
    {
        // Get the start location of the swipe
        var location = gesture.location(in: self.view)
        location = CGPoint(x: location.x, y: mScreenHeight-location.y)
        
        // Check if the use swiped a red virus
        for redVirus in mActiveRedViruses
        {
            if CGVector.Dist(redVirus.position, location) < mSwipePointAccuracy
            {
                // Manage the direction of the swipe
                // Apply force to the swiped red virus
                redVirus.physicsBody?.velocity = CGVector.zero
                if gesture.direction == .right
                {
                    redVirus.physicsBody?.applyImpulse(CGVector(dx: 10000.0, dy: 0.0))
                }
                else if gesture.direction == .left
                {
                    redVirus.physicsBody?.applyImpulse(CGVector(dx: -10000.0, dy: 0.0))
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        // Check every touch
        for touch in touches
        {
            // Get the position of the current touch
            let pos = touch.location(in: self)
            
            // Find all nodes at the position of the current touch
            let nodeArr = nodes(at: pos)
            
            // Loop through all nodes
            for node in nodeArr
            {
                // If the node is the Pill object
                // set its position to the touch position
                if node is Pill
                {
                    let pillNode = node as! Pill

                    pillNode.position = pos
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesMoved(touches, with: event)
        
        // Check every touch
        for touch in touches
        {
            // Get the position of the current touch
            let pos = touch.location(in: self)
            
            // Find all nodes at the position of the current touch
            let nodeArr = nodes(at: pos)
            
            // Loop through all the nodes
            for node in nodeArr
            {
                // If the node is a pill
                // set it to the current touch position
                if node is Pill
                {
                    let pillNode = node as! Pill

                    pillNode.position = pos
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        super.touchesEnded(touches, with: event)
        
        // Check all touches
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
                    mAudioSystem.PlaySound(name: "pop1")
                    let currentVirus = node as! Virus
                    currentVirus.DecreaseHealth(by: 1)

                    // Check if virus died
                    if currentVirus.IsDead()
                    {
                        addParticle(pos: node.position, particle: mVirusDeathParticles!)
                        mScore += 1;
                        mActiveViruses.remove(currentVirus)
                        mInactiveViruses.insert(currentVirus)
                        currentVirus.SetActive(false)
                    }
                }
                
                // Bomb
                /*
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
                */
                
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    
    func addParticle(pos p: CGPoint, particle pS: SKEmitterNode)
    {
        
        // Copy passed particle system
        let particleToAdd = pS.copy() as! SKEmitterNode
        
        // Set particle system position
        // Stop user interaction with the new particle system
        particleToAdd.position = p
        particleToAdd.isUserInteractionEnabled = false
        
        // Get the particle system duration
        let particleDuration = particleToAdd.particleLifetime
        
        // Setup all actions for the particle sequence
        let addAction = SKAction.run({self.addChild(particleToAdd)})
        let waitAction = SKAction.wait(forDuration: TimeInterval(particleDuration))
        let removeAction = SKAction.run({particleToAdd.removeFromParent()})
        
        // Create the sequence of actions
        let sequence = SKAction.sequence([addAction, waitAction, removeAction])

        // Run the sequence
        self.run(sequence)
        
    }
    

    override func update(_ currentTime: TimeInterval)
    {
        
        // Accelerometer
        if let accelerometer = mMotionManager.accelerometerData
        {
            // Update the accelerometer vector
            mAccelerometerVector = CGVector(dx: -accelerometer.acceleration.y, dy: accelerometer.acceleration.x).Norm()
        }
        
        
        // Check if game should end
        if mCore.IsDead()
        {
            mGameOverScene.mScoreFromLastGame = mScore

            // Load game over scene
            loadGameOverScene()
        }

    
        // Update viruses
        for virus in mActiveViruses
        {
            // Update the virus
            virus.Update()
            
            // Check if virus is within range of the core
            if CGVector.Dist(virus.position, mCore.position) < (mCore.size.width/2 + virus.size.width/2 + 10)
            {
                mCore.mHealth -= virus.mDamage
                virus.mHealth = 0
                mActiveViruses.remove(virus)
                mInactiveViruses.insert(virus)
            }
            
            // Manage dead viruses
            if virus.IsDead()
            {
                addParticle(pos: virus.position, particle: mVirusDeathParticles!)
                mActiveViruses.remove(virus)
                mInactiveViruses.insert(virus)
                virus.SetActive(false)
            }
            
            // Animate Virus
            let origionalScale = mVirusTexture.size().width * 0.2
            let modification = CGFloat(abs(sin(virus.mTimeSpawned + currentTime)))
            let newScale = origionalScale + (origionalScale * modification)
            let resizeVirus = SKAction.resize(toWidth: newScale, height: newScale, duration: 0.5)
            virus.run(resizeVirus)
        }
        
        // Update Red Viruses
        for redVirus in mActiveRedViruses
        {
            redVirus.Update()
            
            // Check if red virus is within range of the core
            if CGVector.Dist(redVirus.position, mCore.position) < (mCore.size.width/2 + redVirus.size.width/2 + 10)
            {
                mCore.mHealth -= redVirus.mDamage
                redVirus.mHealth = 0
                mActiveRedViruses.remove(redVirus)
                mInactiveRedViruses.insert(redVirus)
            }
            
            // Manage dead red viruses
            if redVirus.IsDead()
            {
                addParticle(pos: redVirus.position, particle: mRedVirusDeathParticles!)
                mActiveRedViruses.remove(redVirus)
                mInactiveRedViruses.insert(redVirus)
                redVirus.SetActive(false)
            }
            
            // Animate Red Virus
            let origionalScale = mRedVirusTexture.size().width * 0.2
            let modification = CGFloat(abs(sin(redVirus.mTimeSpawned + currentTime)))
            let newScale = origionalScale + (origionalScale * modification)
            let resizeVirus = SKAction.resize(toWidth: newScale, height: newScale, duration: 0.5)
            redVirus.run(resizeVirus)
        }
        
        // Update Bombs
        for bomb in mActiveBombs
        {
            // Manage current active bombs
            bomb.mMovementDirection = mAccelerometerVector
            bomb.Update()
            
            // Variable used to check if a bomb has hit another object
            var hasCollided = false
            
            // Check if current bomb has hit a virus
            for virus in mActiveViruses
            {
                let dirToVirus = virus.position.ToVector() - bomb.position.ToVector()
                let distToVirus = dirToVirus.Mag()
                
                if distToVirus <= bomb.size.width/2 + virus.size.width/2
                {
                    hasCollided = true
                }
            }
            
            // Check if current bomb has hit a red virus
            for redVirus in mActiveRedViruses
            {
                let dirToVirus = redVirus.position.ToVector() - bomb.position.ToVector()
                let distToVirus = dirToVirus.Mag()
                
                if distToVirus <= bomb.size.width/2 + redVirus.size.width/2
                {
                    hasCollided = true
                }
            }
            
            // What should happen if the current bomb has hit something?
            if hasCollided
            {
                // Loop through all viruses
                for virus in mActiveViruses
                {
                    // Get the direction and the distance to the current virus from the bomb
                    let dirToVirus = virus.position.ToVector() - bomb.position.ToVector()
                    let distToVirus = dirToVirus.Mag()
                    
                    // Check if the virus is within explosion range
                    if distToVirus <= CGFloat(bomb.mExplosionRadius)
                    {
                        // Damage the virus
                        virus.DecreaseHealth(by: bomb.mExplosionDamage)
                        
                        // Manage dead virus
                        if virus.IsDead()
                        {
                            addParticle(pos: virus.position, particle: mVirusDeathParticles!)
                            mScore += 1;
                            mActiveViruses.remove(virus)
                            mInactiveViruses.insert(virus)
                            virus.SetActive(false)
                        }
                    }
                }
                
                // Loop through all red viruses
                for redVirus in mActiveRedViruses
                {
                    // Get the direction and the distance to the current red virus from the bomb
                    let dirToVirus = redVirus.position.ToVector() - bomb.position.ToVector()
                    let distToVirus = dirToVirus.Mag()
                    
                    // Check if the red virus is within explosion range
                    if distToVirus <= CGFloat(bomb.mExplosionRadius)
                    {
                        // Damange the red virus
                        redVirus.DecreaseHealth(by: bomb.mExplosionDamage)
                        
                        // Manage dead red virus
                        if redVirus.IsDead()
                        {
                            addParticle(pos: redVirus.position, particle: mRedVirusDeathParticles!)
                            mScore += 1;
                            mActiveRedViruses.remove(redVirus)
                            mInactiveRedViruses.insert(redVirus)
                            redVirus.SetActive(false)
                        }
                    }
                }
                
                // Shake the screen
                view?.Shake(horizontalShake: CGFloat.random(in: -50.0...50.0), verticalShake: CGFloat.random(in: -50.0...50.0))
                // Play explosion particle
                addParticle(pos: bomb.position, particle: mExplosionParticles!)
                // Play explosion sound
                mAudioSystem.PlaySound(name: "explode")
                
                // Manage dead bomb
                bomb.mIsAlive = false
                mActiveBombs.remove(bomb)
                mInactiveBombs.insert(bomb)
                bomb.SetActive(false)
            }
        }
        
        // Check if pill is within range of the core
        if CGVector.Dist(mPillObject.position, mCore.position) < 50.0
        {
            // Heal the core
            mCore.mHealth += mPillObject.mHealingAmount
            // Deactivate pill
            mPillObject.mIsAlive = false
            mPillObject.SetActive(false)
        }
        
        // Random spawning of viruses
        var randomSide = Int.random(in: 0...1)
        var randomPosY = Float.random(in: 1.0...Float(mScreenHeight))
        var posX = randomSide == 0 ? -mVirusTexture.size().width : mScreenWidth + mVirusTexture.size().width
 
        var pos = CGPoint(x: posX, y: CGFloat(randomPosY))
        
        if mActiveViruses.count <= 5
        {
            SpawnVirus(at: pos, health: 1, speed: 50.0, currentTime: currentTime)
        }
        
        randomSide = Int.random(in: 0...1)
        randomPosY = Float.random(in: 1.0...Float(mScreenHeight))
        posX = randomSide == 0 ? -mVirusTexture.size().width : mScreenWidth + mVirusTexture.size().width
        pos = CGPoint(x: posX, y: CGFloat(randomPosY))
        
        if mActiveRedViruses.count <= 0
        {
            SpawnRedVirus(at: pos, health: 1, speed: 10.0, currentTime: currentTime)
        }
        
        pos = CGPoint(x: CGFloat(Float.random(in: 1.0...Float(mScreenWidth))), y: CGFloat(Float.random(in: 1.0...Float(mScreenHeight))))
        
        // Limit scene to 1 bomb
        if mActiveBombs.count <= 0
        {
            SpawnBomb(at: pos, speed: 50.0, explosionRange: 200.0, explosionDamage: 5)
        }
        
        pos = CGPoint(x: CGFloat(Float.random(in: 1.0...Float(mScreenWidth))), y: CGFloat(Float.random(in: 1.0...Float(mScreenHeight))))
        
        // Spawn Pill
        if mPillObject.IsDead()
        {
            SpawnPill(position: pos)
        }
        
        // Update core health label
        mCoreHealthLabel.text = "\(mCore.mHealth)"
        
    }
    
    
    /*
     The following functions are for creation / spawning and setup of viruses
     */
    func CreateVirus(health h: Int,
                     movementSpeed mS: Float) -> (Virus)
    {
        let newVirus = Virus(imageNamed: "Virus")
        newVirus.Setup(health: h, speed: mS, timeSpawned: 0.0, damage: 1)
        
        return newVirus;
    }
    
    func SpawnVirus(at p: CGPoint, health h: Int, speed s: Float, currentTime t: Double)
    {
        // Check if there is a virus avaliable to spawn
        if mInactiveViruses.isEmpty
        {
            return
        }
        
        // Get first virus from the inactive viruses
        // and add it to the active viruses
        let inactiveVirus = mInactiveViruses.popFirst()
        mActiveViruses.insert(inactiveVirus!)
        
        // Set the virus position
        // Run the virus setup
        // Activate the virus
        inactiveVirus?.position = p
        inactiveVirus?.Setup(health: h, speed: s, timeSpawned: t, damage: 1)
        inactiveVirus?.SetActive(true)
        
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
            newVirus.SetActive(false)
            
            addChild(newVirus)
        }
        
    }
    
    
    /*
     The following functions are for creation / spawning and setup of viruses
     */
    func CreateRedVirus(health h: Int,
                     movementSpeed mS: Float) -> (RedVirus)
    {
        let newRedVirus = RedVirus(imageNamed: "RedVirus")
        newRedVirus.Setup(health: h, speed: mS, timeSpawned: 0.0, damage: 1)
        
        return newRedVirus;
    }
    
    func SpawnRedVirus(at p: CGPoint, health h: Int, speed s: Float, currentTime t: Double)
    {
        // Check if there is a red virus to spawn
        if mInactiveRedViruses.isEmpty
        {
            return
        }
        
        // Get the first inactive red virus
        // and add it to the active red viruses
        let inactiveRedVirus = mInactiveRedViruses.popFirst()
        mActiveRedViruses.insert(inactiveRedVirus!)
        
        // Set the red virus position
        // Run red virus setup
        // Activate the red virus
        inactiveRedVirus?.position = p
        inactiveRedVirus?.Setup(health: h, speed: s, timeSpawned: t, damage: 1)
        inactiveRedVirus?.SetActive(true)
        
    }
    
    func SetupRedViruses()
    {
        
        for _ in 1...mNumOfRedViruses
        {
            // Start red viruses with 0 health (Assign health later)
            let newRedVirus = CreateRedVirus(health: 0, movementSpeed: 20.0)
            
            mInactiveRedViruses.insert(newRedVirus)
            
            newRedVirus.position = CGPoint(x: mScreenWidth - 100.0, y: mScreenHeight / 2)
            newRedVirus.size = CGSize(width: mVirusTexture.size().width, height: mVirusTexture.size().height) * 0.5
            newRedVirus.physicsBody = SKPhysicsBody(circleOfRadius: mVirusTexture.size().width)
            newRedVirus.physicsBody?.affectedByGravity = false
            newRedVirus.physicsBody?.collisionBitMask = 0x0

            newRedVirus.SetTarget(target: mCore.position)
            newRedVirus.SetActive(false)
            
            addChild(newRedVirus)
        }
        
    }
    
    
    /*
     The following functions are for creation / spawning and setup of bombs
     */
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
        // Check if there is a bomb to spawn
        if mInactiveBombs.isEmpty
        {
            return
        }
        
        // Get the first inactive bomb
        // and add it to the active bombs
        let inactiveBomb = mInactiveBombs.popFirst()
        mActiveBombs.insert(inactiveBomb!)
        
        // Set the bombs position
        inactiveBomb?.position = p
        inactiveBomb?.mMovementDirection = CGVector.zero
        inactiveBomb?.mMovementSpeed = s
        inactiveBomb?.mExplosionRadius = eRange
        inactiveBomb?.mExplosionDamage = eDamage
        
        // Reset the bombs velocity
        inactiveBomb?.physicsBody?.velocity = CGVector.zero
        
        // Activate the bomb
        inactiveBomb?.mIsAlive = true
        inactiveBomb?.SetActive(true)
        
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
            newBomb.SetActive(false)
            
            addChild(newBomb)
        }
        
    }
    
    
    func SpawnPill(position p: CGPoint)
    {
        if mPillObject.IsDead()
        {
            mPillObject.position = p
            mPillObject.mIsAlive = true
            mPillObject.SetActive(true)
        }
    }
    
    
    /*
     Function to reset all scene variables
        - Viruses
        - Red Viruses
        - Bombs
        - Core
        - Score
        - Game Settings (Current Wave)
     */
    func ResetScene() -> (Bool)
    {
        
        // Viruses
        for virus in mActiveViruses
        {
            mActiveViruses.remove(virus)
            mInactiveViruses.insert(virus)
            virus.SetActive(false)
        }
        
        for redVirus in mActiveRedViruses
        {
            mActiveRedViruses.remove(redVirus)
            mInactiveRedViruses.insert(redVirus)
            redVirus.SetActive(false)
        }
        
        // Bombs
        for bomb in mActiveBombs
        {
            bomb.mIsAlive = false
            mActiveBombs.remove(bomb)
            mInactiveBombs.insert(bomb)
            bomb.SetActive(false)
        }
        
        // Pill
        if nil != mPillObject { mPillObject.SetActive(false) }
        
        // Core
        if nil != mCore { mCore.mHealth = mCoreStartingHealth }
        
        // Score
        mScore = 0
        mScoreLabel.text = "SCORE: 0"
        
        // Game Settings
        mCurrentWave = 1
        
        // Update audio system
        if nil != mAudioSystem { mAudioSystem.UpdateSettings() }
        
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
