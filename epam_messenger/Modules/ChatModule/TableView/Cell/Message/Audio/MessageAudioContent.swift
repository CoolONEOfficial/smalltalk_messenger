//
//  MessageAudioContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 28.03.2020.
//

import UIKit
import FDWaveformView
import FirebaseStorage
import AVFoundation

class MessageAudioContent: UIView, MessageCellContentProtocol {

    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var waveform: FDWaveformView!
    @IBOutlet var playButton: UIButton!
    
    // MARK: - Vars
    
    var shouldSetupConstraints = true
    
    var player: AVAudioPlayer! {
        didSet {
            if player != nil {
                setupPlayer()
            }
        }
    }
    
    var cell: MessageCellProtocol!
    var mergeContentNext: Bool!
    var mergeContentPrev: Bool!
    var kindIndex: Int!
    var messageAudio: MessageAudioProtocol! {
        didSet {
            setupWaveform()
            setupPlayButton()
        }
    }
    var message: MessageProtocol! {
        return messageAudio
    }
    
    var topMargin: CGFloat {
        return 0
    }
    
    var bottomMargin: CGFloat {
        return 0
    }
    
    private func setupPlayer() {
        player.delegate = self
    }
    
    private func setupWaveform() {
        waveform.wavesColor = UIColor.accentText.withAlphaComponent(0.3)
        waveform.progressColor = .accentText
        
        let kindAudio = messageAudio.kindAudio(at: kindIndex)!
        let imageRef = Storage.storage().reference().child(kindAudio)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(kindAudio.replacingOccurrences(of: "/", with: "_"))
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            didAudioLoaded(fileURL)
        } else {
            debugPrint("load from storage")
            imageRef.getData(maxSize: Int64.max) { data, err in
                guard err == nil else {
                    debugPrint("Error while get audio data: \(err!.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        try data.write(to: fileURL)
                        self.didAudioLoaded(fileURL)
                    } catch {
                        print("Error while writing audio to cache: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func didAudioLoaded(_ fileURL: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: fileURL)
        } catch {
            print(error)
        }
        self.waveform.audioURL = fileURL
    }
    
    private func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    private func setupPlayButton() {
        playButton.tintColor = message.isIncoming
            ? .plainText
            : .accentText
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MessageAudioContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    
    func loadMessage(
        _ message: MessageProtocol,
        index: Int,
        cell: MessageCellProtocol,
        mergeContentNext: Bool,
        mergeContentPrev: Bool
    ) {
        self.kindIndex = index
        self.cell = cell
        self.mergeContentNext = mergeContentNext
        self.mergeContentPrev = mergeContentPrev
        self.messageAudio = message as? MessageAudioProtocol
    }
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            
            horizontalToSuperview()
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    // MARK: - Actions
    
    func didTap(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: playButton)
        if playButton.frame.contains(tapLocation) {
            didPlayButtonTap()
        }
    }
    
    func didPlayButtonTap() {
        if player.isPlaying {
            player.pause()
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            self.waveform.layer.pause()
        } else {
            player.play()
            playButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            if player.currentTime.isZero {
                UIView.animate(withDuration: player.duration, delay: 0, options: .curveLinear, animations: {
                    self.waveform.highlightedSamples =  0 ..< self.waveform.totalSamples
                }, completion: nil)
            } else {
                self.waveform.layer.resume()
            }
        }
    }
}

extension MessageAudioContent: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        waveform.highlightedSamples = nil
    }
}

fileprivate extension CALayer {
    func pause() {
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }

    func resume() {
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
