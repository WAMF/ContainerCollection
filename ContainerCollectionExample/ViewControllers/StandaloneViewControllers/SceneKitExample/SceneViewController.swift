//  Copyright © 2019 We Are Mobile First.

import ContainerCollection
import SceneKit
import UIKit

struct SceneViewData: ComponentData, Equatable {
    let sceneFileName: String
}

class SceneViewController: UIViewController {
    @IBOutlet private var sceneView: SCNView!

    var sceneViewData: SceneViewData? {
        didSet { refreshView() }
    }

    deinit {
        sceneView.removeFromSuperview()
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.pause(nil)
    }

    private func refreshView() {
        guard isViewLoaded, let data = sceneViewData else { return }
        sceneView.scene = SCNScene(named: data.sceneFileName)
        sceneView.play(nil)
    }
}

extension SceneViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let sceneViewData = data as? SceneViewData,
            sceneViewData != self.sceneViewData else { return }
        sceneView.scene = nil
        self.sceneViewData = sceneViewData
    }
}
