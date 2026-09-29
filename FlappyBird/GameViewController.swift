import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    override func loadView() {
        let view = SKView(frame: UIScreen.main.bounds)
        view.ignoresSiblingOrder = true
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = FlappyScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        (view as? SKView)?.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}
