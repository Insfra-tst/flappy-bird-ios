import SpriteKit

final class FlappyScene: SKScene {
    private let bird = SKShapeNode(circleOfRadius: 18)
    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let messageLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private var score = 0
    private var started = false
    private var gameOver = false
    private var lastUpdate: TimeInterval = 0
    private var spawnTimer: TimeInterval = 0
    private var pipeSpeed: CGFloat = 190

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.35, green: 0.78, blue: 0.95, alpha: 1)
        physicsWorld.gravity = CGVector(dx: 0, dy: -7.5)
        physicsWorld.contactDelegate = self
        setupScene()
    }

    private func setupScene() {
        removeAllChildren()
        started = false
        gameOver = false
        score = 0
        scoreLabel.text = "0"
        scoreLabel.fontSize = 42
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 90)
        scoreLabel.zPosition = 20
        addChild(scoreLabel)

        drawBackground()
        bird.path = CGPath(ellipseIn: CGRect(x: -18, y: -18, width: 36, height: 36), transform: nil)
        bird.fillColor = .yellow
        bird.strokeColor = .orange
        bird.lineWidth = 3
        bird.position = CGPoint(x: size.width * 0.28, y: size.height * 0.55)
        bird.zPosition = 10
        bird.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = 1
        bird.physicsBody?.collisionBitMask = 0
        bird.physicsBody?.contactTestBitMask = 2
        addChild(bird)

        messageLabel.text = "TAP TO FLY"
        messageLabel.fontSize = 26
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.42)
        messageLabel.zPosition = 20
        addChild(messageLabel)
    }

    private func drawBackground() {
        let ground = SKShapeNode(rectOf: CGSize(width: size.width, height: 45))
        ground.fillColor = SKColor(red: 0.35, green: 0.72, blue: 0.2, alpha: 1)
        ground.strokeColor = .clear
        ground.position = CGPoint(x: size.width / 2, y: 22)
        ground.zPosition = 5
        ground.name = "ground"
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 2
        ground.physicsBody?.contactTestBitMask = 1
        addChild(ground)

        for x in stride(from: CGFloat(0), through: size.width, by: 34) {
            let cloud = SKShapeNode(ellipseOf: CGSize(width: 70, height: 28))
            cloud.fillColor = SKColor.white.withAlphaComponent(0.45)
            cloud.strokeColor = .clear
            cloud.position = CGPoint(x: x, y: size.height * 0.78 + CGFloat(Int(x) % 3) * 18)
            cloud.zPosition = 1
            addChild(cloud)
        }
    }

    private func flap() {
        guard !gameOver else { setupScene(); return }
        if !started {
            started = true
            messageLabel.removeFromParent()
            bird.physicsBody?.isDynamic = true
        }
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 235))
    }

    private func addPipePair() {
        let gap: CGFloat = 170
        let margin: CGFloat = 110
        let centerY = CGFloat.random(in: margin...(size.height - margin))
        let pipeWidth: CGFloat = 58
        let topHeight = size.height - centerY - gap / 2
        let bottomHeight = centerY - gap / 2 - 45

        addPipe(x: size.width + pipeWidth, y: size.height - topHeight / 2, height: topHeight)
        addPipe(x: size.width + pipeWidth, y: 45 + bottomHeight / 2, height: bottomHeight)

        let point = SKNode()
        point.position = CGPoint(x: size.width + pipeWidth + 5, y: centerY)
        point.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 8, height: gap))
        point.physicsBody?.isDynamic = false
        point.physicsBody?.categoryBitMask = 4
        point.physicsBody?.contactTestBitMask = 1
        point.name = "point"
        addChild(point)
    }

    private func addPipe(x: CGFloat, y: CGFloat, height: CGFloat) {
        let pipe = SKShapeNode(rectOf: CGSize(width: 58, height: max(1, height)))
        pipe.fillColor = SKColor(red: 0.18, green: 0.7, blue: 0.18, alpha: 1)
        pipe.strokeColor = SKColor(red: 0.08, green: 0.4, blue: 0.08, alpha: 1)
        pipe.lineWidth = 4
        pipe.position = CGPoint(x: x, y: y)
        pipe.name = "pipe"
        pipe.zPosition = 4
        pipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 58, height: max(1, height)))
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = 2
        pipe.physicsBody?.contactTestBitMask = 1
        addChild(pipe)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        flap()
    }

    override func update(_ currentTime: TimeInterval) {
        let delta = lastUpdate == 0 ? 0 : min(currentTime - lastUpdate, 0.05)
        lastUpdate = currentTime
        guard started && !gameOver else { return }
        spawnTimer += delta
        if spawnTimer > 1.55 {
            spawnTimer = 0
            addPipePair()
        }
        enumerateChildNodes(withName: "//*") { node, _ in
            guard node !== self.bird, node !== self.scoreLabel else { return }
            if node.position.x < -100 { node.removeFromParent() }
        }
        for node in children where (node.name == "pipe" || node.name == "point") && node.position.x > -100 {
            node.position.x -= self.pipeSpeed * CGFloat(delta)
        }
    }

    private func endGame() {
        guard !gameOver else { return }
        gameOver = true
        bird.physicsBody?.isDynamic = false
        let over = SKLabelNode(fontNamed: "AvenirNext-Bold")
        over.text = "GAME OVER  •  TAP TO RESTART"
        over.fontSize = 22
        over.fontColor = .white
        over.position = CGPoint(x: size.width / 2, y: size.height * 0.42)
        over.zPosition = 20
        addChild(over)
    }
}

extension FlappyScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 4 || contact.bodyB.categoryBitMask == 4 {
            score += 1
            scoreLabel.text = "\(score)"
            let pointBody = contact.bodyA.categoryBitMask == 4 ? contact.bodyA : contact.bodyB
            pointBody.categoryBitMask = 0
        } else {
            endGame()
        }
    }
}
