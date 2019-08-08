//  Copyright © 2019 We Are Mobile First.

import AVKit
import ContainerCollection
import UIKit

struct VideoPlayerData: ComponentData, Equatable {
    let videoURL: URL
    let title: String
    let subtitle: String
}

class VideoPlayerViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!

    var videoPlayerData: VideoPlayerData? {
        didSet { refreshView() }
    }

    deinit {
        NSLog("********** Deinitializing ViewController: \(self.self) **********")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshView()
    }

    private func refreshView() {
        guard isViewLoaded,
            let data = videoPlayerData,
            let playerViewController = children.first as? AVPlayerViewController else { return }
        playerViewController.player = AVPlayer(url: data.videoURL)
        playerViewController.player?.play()

        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
}

extension VideoPlayerViewController: ConfigurableComponent {
    func configure(with data: ComponentData?) {
        guard let videoPlayerData = data as? VideoPlayerData, videoPlayerData != self.videoPlayerData else { return }
        (children.first as? AVPlayerViewController)?.player = nil
        self.videoPlayerData = videoPlayerData
    }
}
