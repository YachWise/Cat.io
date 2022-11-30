import SpriteKit

class GameScene: SKScene
{
    var touchBall: Bool = false
    var innerKnob: SKShapeNode!
    var outerKnob: SKShapeNode!
    var cameraNode = SKCameraNode()
    var player: SKSpriteNode!
    var ground = SKSpriteNode()
    
    let ice: SKEmitterNode = SKEmitterNode()
    override func didMove(to view: SKView) {
        //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.createJoyStick()
        self.createPlayer()
    }
    
    private func createGround()
    {
        
    }
    
    func createPlayer()
    {
        self.player = SKSpriteNode(texture: SKTexture(imageNamed: "cat1_idle_00"))
        self.player.size = CGSize(width: 150, height: 150)
        self.addChild(player)
        self.addChild(cameraNode)
        self.createPlayerIdle()
        camera = self.cameraNode
    }
    
    func createPlayerRun()
    {
        var runTexture: [SKTexture] = []
        let atlas = SKTextureAtlas(named: "cat1_run")
        let atlasCount = atlas.textureNames.count - 1
        
        for i in 0...atlasCount
        {
            let leadingZero = (String(format: "%02d", i))
            let texture = SKTexture(imageNamed: "cat1_run_\(leadingZero)")
            
            runTexture.append(texture)
        }
        let run = SKAction.animate(with: runTexture, timePerFrame: 0.09)
        let repeated = SKAction.repeatForever(run)
        self.player.run(repeated)
    }
    
    func createPlayerIdle()
    {
        var idleTexture: [SKTexture] = []
        let atlas = SKTextureAtlas(named: "cat1_idle")
        let atlasCount = atlas.textureNames.count - 1
        
        for i in 0...atlasCount
        {
            let leadingZero = (String(format: "%02d", i))
            let texture = SKTexture(imageNamed: "cat1_idle_\(leadingZero)")
            
            idleTexture.append(texture)
        }
        let idle = SKAction.animate(with: idleTexture, timePerFrame: 0.09)
        let repeated = SKAction.repeatForever(idle)
        self.player.run(repeated)
    }
    
    func createJoyStick()
    {
        //inner knob setup
        self.innerKnob = SKShapeNode(circleOfRadius: 50)
        self.innerKnob.name = "ball"
        self.innerKnob.zPosition = 2
        self.innerKnob.position = CGPoint(x: self.frame.midX, y: -self.size.height*0.3)
        self.innerKnob.fillColor = .white
        self.innerKnob.strokeColor = .white
        
        //outer knob setup
        self.outerKnob = SKShapeNode(circleOfRadius: 100)
        self.outerKnob.fillColor = .clear
        self.outerKnob.strokeColor = .white
        self.outerKnob.position = self.innerKnob.position
    
        //add both knobs to camera
        self.cameraNode.addChild(self.innerKnob)
        self.cameraNode.addChild(self.outerKnob)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (self.touchBall){
            let dx = self.innerKnob.position.x - self.outerKnob.position.x
            let dy = self.innerKnob.position.y - self.outerKnob.position.y
            let angle = atan2(dy, dx)
            self.player.position = CGPoint(x:cos(angle)*5+self.player.position.x, y: sin(angle)*5+self.player.position.y)
            let xFlip = cos(angle) * -5+self.player.position.x
            let yFlip = sin(angle) * -5 + self.player.position.y
            let flipped = CGPoint(x: xFlip, y: yFlip)
            
           // let pos =
            let iceShard = IceShard(startPos: self.player.position, endPos: flipped)
            
            addChild(iceShard)
            self.cameraNode.position = self.player.position
            let x = player.position.x
            let y = player.position.y
            let playerPos = CGPoint(x: x, y: y)
            //print(playerPos)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        if atPoint(location).name == "ball"
        {
            self.player.removeAllActions()
            self.createPlayerRun()
            print("ball touched")
            self.touchBall = true
        }
    }
    

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        let convertLocation = self.convert(location, to: self.cameraNode)
        
        if (self.touchBall)
        {
            let dx = convertLocation.x - outerKnob.position.x
            let dy = convertLocation.y - outerKnob.position.y
            let angle = atan2(dy,dx)
            
            self.innerKnob.position = convertLocation
            let square = sqrt(dx*dx + dy*dy)
            
           
            //face the player right side
            if (self.innerKnob.position.x > outerKnob.position.x)
            {
                self.player.xScale = 1
            }
            //turn player left side
            else if (self.innerKnob.position.x < self.outerKnob.position.x)
            {
                self.player.xScale = -1
            }
            if (square >= 100)
            {
                self.innerKnob.position = CGPoint(x: cos(angle)*100 + self.outerKnob.position.x, y: sin(angle)*100 + self.outerKnob.position.y)
            }
            else
            {
                self.innerKnob.position = convertLocation
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.innerKnob.position = self.outerKnob.position
        
        self.touchBall = false
        self.player.removeAllActions()
        self.createPlayerIdle()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
