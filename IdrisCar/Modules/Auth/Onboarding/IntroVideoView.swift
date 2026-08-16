//
//  IntroVideoView.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 29/04/2026.
//

import UIKit
import Combine
import AVFoundation

class IntroVideoView: UIViewController {
    
    private let dataService: LoginRepository = RemoteLoginRepository()
    var cancellables: Set<AnyCancellable> = []
    
    var player: AVPlayer?
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getIntroVideo()
        self.onFinish?()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    func getIntroVideo() {
        dataService.getIntroVideo()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        print("Publisher stopped observing")
                    }
                },
                receiveValue: { response in
                    if let videoURL = response.data?.video {
                        self.playVideo(with: videoURL)
                    } else {
                        self.onFinish?()
                    }
                }
            )
            .store(in: &cancellables)
        
    }
    
    func playVideo(with url: String) {
        guard let url = URL(string: url) else { return }
        
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            player?.pause()
            onFinish?()
        }
    }
}
