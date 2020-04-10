//
//  ChatInputBar.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView
import Photos

class ChatInputBar: InputBarAccessoryView {
    
    // MARK: - Vars
    
    var chatDelegate: ChatInputBarDelegate?
    
    let attachButton = InputBarButtonItem()
    let voiceCancelButton = InputBarButtonItem()
    let voiceButton = InputBarSendButton()
    lazy var voiceTimerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    var voiceTimer: Timer?
    var startTime: Double = 0
    
    static let defaultLeftStackWidth: CGFloat = 30
    static let defaultRightStackWidth: CGFloat = 30
    static let sendImageInset: CGFloat = 6
    static let sendButtonInsets: UIEdgeInsets = .init(
        top: sendImageInset, left: sendImageInset,
        bottom: sendImageInset, right: sendImageInset
    )
    static let attachImageInset: CGFloat = 2
    static let attachButtonInsets: UIEdgeInsets = .init(
        top: attachImageInset, left: attachImageInset,
        bottom: attachImageInset, right: attachImageInset
    )
    static let stacksPadding: CGFloat = 4
    
    let imagePicker = UIImagePickerController()
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .accent
        
        setupInputTextView()
        setupLeftStack()
        setupRightStack()
        separatorLine.backgroundColor = .plainBackground
        backgroundView.backgroundColor = .systemBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLeftStack() {
        setupAttachButton()
        setLeftStackViewWidthConstant(to: ChatInputBar.defaultLeftStackWidth, animated: false)
        setStackViewItems([attachButton], forStack: .left, animated: false)
        padding.left = ChatInputBar.stacksPadding
        middleContentViewPadding.left = ChatInputBar.stacksPadding
    }
    
    func setupRightStack() {
        setupSendButton()
        setupVoiceButton()
        setupVoiceCancelButton()
        rightStackView.spacing = 30
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth, animated: false)
        setStackViewItems([voiceButton], forStack: .right, animated: false)
        padding.right = ChatInputBar.stacksPadding
        middleContentViewPadding.right = ChatInputBar.stacksPadding
    }
    
    func setupSendButton() {
        sendButton.imageEdgeInsets = ChatInputBar.sendButtonInsets
        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        sendButton.image = UIImage(systemName: "arrow.up")
        sendButton.tintColor = UIColor.lightText.withAlphaComponent(1)
        sendButton.activityViewColor = .plainText
        
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.contentMode = .scaleToFill
        sendButton.title = nil
        
        sendButton.layer.backgroundColor = UIColor.accent.cgColor
        sendButton.layer.cornerRadius = 15
    }
    
    func setupAttachButton() {
        attachButton.imageEdgeInsets = ChatInputBar.attachButtonInsets
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.image = UIImage(systemName: "paperclip")
        attachButton.tintColor = .plainIcon
        
        attachButton.contentHorizontalAlignment = .fill
        attachButton.contentVerticalAlignment = .fill
        attachButton.contentMode = .scaleToFill
        attachButton.title = nil
        attachButton.addTarget(self, action: #selector(didClickAttachButton), for: .touchUpInside)
    }
    
    func setupVoiceCancelButton() {
        voiceCancelButton.setSize(CGSize(width: 30, height: 30), animated: false)
        voiceCancelButton.image = UIImage(systemName: "xmark")
        voiceCancelButton.tintColor = .plainText
        voiceCancelButton.imageEdgeInsets = .uniform(5)
        
        voiceCancelButton.contentHorizontalAlignment = .fill
        voiceCancelButton.contentVerticalAlignment = .fill
        voiceCancelButton.contentMode = .scaleToFill
        voiceCancelButton.title = nil
        voiceCancelButton.addTarget(self, action: #selector(didTouchDownVoiceCancelButton), for: .touchDown)
    }
    
    func setupVoiceButton() {
        voiceButton.imageEdgeInsets = ChatInputBar.attachButtonInsets
        voiceButton.setSize(CGSize(width: 30, height: 30), animated: false)
        voiceButton.image = UIImage(systemName: "mic")
        voiceButton.tintColor = .plainIcon
        voiceButton.activityViewColor = .plainText
        
        voiceButton.contentHorizontalAlignment = .fill
        voiceButton.contentVerticalAlignment = .fill
        voiceButton.contentMode = .scaleToFill
        voiceButton.title = nil
        voiceButton.isEnabled = false
        voiceButton.addTarget(self, action: #selector(didTouchUpVoiceButton), for: .touchUpInside)
        voiceButton.addTarget(self, action: #selector(didTouchDragOutsideVoiceButton), for: .touchDragOutside)
        voiceButton.addTarget(self, action: #selector(didTouchDownVoiceButton), for: .touchDown)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [
                    .mixWithOthers,
                    .allowAirPlay,
                    .defaultToSpeaker
                ]
            )
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { result in
                if result {
                    DispatchQueue.main.async {
                        self.voiceButton.isEnabled = true
                    }
                }
            }
        } catch {
            debugPrint("Errorr while get record permissions: \(error.localizedDescription)")
        }
    }
    
    func setupInputTextView() {
        inputTextView.backgroundColor = .systemBackground
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 4, right: 44)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 12, bottom: 4, right: 33)
        inputTextView.placeholderLabel.text = "Message..."
        inputTextView.textColor = .white
        inputTextView.font = UIFont.preferredFont(forTextStyle: .body).withSize(16)
        inputTextView.layer.borderColor = UIColor.plainBackground.cgColor
        inputTextView.layer.borderWidth = 1.3
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Events
    
    override func inputTextViewDidChange() {
        super.inputTextViewDidChange()
        
        sendButton.isEnabled = true
    }
    
    @objc func advanceTimer(timer: Timer) {
        let time = Date().timeIntervalSinceReferenceDate - startTime
        
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int(time * 100) % 100
        
        voiceTimerLabel.text = String(format: "%02i:%02i:%02i", minutes, seconds, milliseconds)
    }
    
    @objc func didClickAttachButton() {
        let optionMenu = ChatInputBarAttachMenu(
            cameraRecognizer: UITapGestureRecognizer(
                target: self, action: #selector(self.showCameraPicker)
            ),
            didImageTapCompletion: pickImage,
            didActionImageTapCompletion: presentImagePicker
        )
        
        window?
            .rootViewController?
            .present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func didTouchDownVoiceCancelButton() {
        audioRecorder = nil
        willFinishRecording()
    }
    
    @objc func didTouchUpVoiceButton() {
        finishRecording()
    }
    
    @objc func didTouchDragOutsideVoiceButton() {
        voiceButton.image = UIImage(systemName: "stop.circle.fill")
        
        voiceButton.contentEdgeInsets = .init(top: -20, left: -30, bottom: -20, right: -10)
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth * 2 + 30, animated: true)
        setStackViewItems([voiceCancelButton, voiceButton], forStack: .right, animated: true)
    }
    
    @objc func didTouchDownVoiceButton() {
        if audioRecorder != nil {
            finishRecording()
        } else {
            startRecording()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        willStartRecording()
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(Date().iso8601withFractionalSeconds).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            didStartRecording()
        } catch {
            debugPrint("Error while get audio recorder: \(error.localizedDescription)")
            finishRecording()
        }
    }
    
    func finishRecording() {
        willFinishRecording()
        if audioRecorder != nil {
            audioRecorder.stop()
            let stopTime = Date().timeIntervalSinceReferenceDate - startTime
            if stopTime > 1 {
                chatDelegate?.didVoiceMessageRecord(data: try! Data(contentsOf: audioRecorder.url))
                audioRecorder.deleteRecording()
            }
            audioRecorder = nil
        }
    }
    
    private func willStartRecording() {
        voiceButton.image = UIImage(systemName: "mic.circle.fill")
        UIView.animate(withDuration: 0.3) {
            self.voiceButton.contentEdgeInsets = .uniform(-20)
            self.voiceButton.tintColor = .plainText
            self.voiceButton.layoutIfNeeded()
        }
        setStackViewItems([], forStack: .left, animated: true)
        middleContentView?.isHidden = true
        addSubview(voiceTimerLabel)
        voiceTimerLabel.leftToSuperview(offset: 10)
        voiceTimerLabel.bottom(to: leftStackView)
        voiceTimerLabel.top(to: leftStackView)
    }
    
    private func didStartRecording() {
        startTime = Date().timeIntervalSinceReferenceDate
        voiceTimer = Timer.scheduledTimer(
            timeInterval: 0.05,
            target: self,
            selector: #selector(advanceTimer(timer:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func willFinishRecording() {
        voiceTimerLabel.removeFromSuperview()
        voiceButton.image = UIImage(systemName: "mic")
        UIView.animate(withDuration: 0.3) {
            self.voiceButton.contentEdgeInsets = .zero
            self.voiceButton.tintColor = .plainIcon
            self.voiceButton.layoutIfNeeded()
        }
        setStackViewItems([attachButton], forStack: .left, animated: true)
        middleContentView?.isHidden = false
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth, animated: true)
        setStackViewItems([voiceButton], forStack: .right, animated: true)
    }
    
    @objc private func showCameraPicker() {
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .camera
        window?.rootViewController?.dismiss(animated: true) {
            self.window?.rootViewController?
                .present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    private func pickImage(image: UIImage) {
        window?.rootViewController?.dismiss(animated: true) {
            self.inputPlugins.forEach { _ = $0.handleInput(of: image) }
        }
    }
    
    private func presentImagePicker() {
        chatDelegate?.didActionImageTap()
    }
    
    // MARK: - Side stacks visibility functions
    
    public func hideSideStacks() {
        setRightStackViewWidthConstant(to: 0, animated: true)
        setLeftStackViewWidthConstant(to: 0, animated: true)
        sendButton.imageEdgeInsets = .zero
        attachButton.imageEdgeInsets = .zero
    }
    
    public func showSideStacks() {
        sendButton.imageEdgeInsets = ChatInputBar.sendButtonInsets
        attachButton.imageEdgeInsets = ChatInputBar.attachButtonInsets
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth, animated: true)
        setLeftStackViewWidthConstant(to: ChatInputBar.defaultLeftStackWidth, animated: true)
        padding.right = ChatInputBar.stacksPadding
        middleContentViewPadding.right = ChatInputBar.stacksPadding
    }
}

extension ChatInputBar: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true) {
            if let pickedImage = image {
                self.inputPlugins.forEach { _ = $0.handleInput(of: pickedImage) }
            } else {
                debugPrint("Error while unwrapping selected image")
            }
        }
    }
}

// MARK: Camera preview helper

fileprivate extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
            case .aspectFill:
                self.contentMode = .scaleAspectFill
            case .aspectFit:
                self.contentMode = .scaleAspectFit
            @unknown default:
                fatalError()
            }
            self.image = image
        }
    }
}

// MARK: Format number helper

fileprivate extension Int {
    func format(_ f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

fileprivate extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
