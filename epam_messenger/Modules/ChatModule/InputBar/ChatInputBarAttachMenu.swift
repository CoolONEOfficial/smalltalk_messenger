//
//  ChatInputBarAttachMenu.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import UIKit
import Photos

class ChatInputBarAttachMenu: UIAlertController {
    
    // MARK: - Vars
    
    lazy var stackItemWidth: CGFloat = (view.bounds.width - 20 - 5 * 4) / 5
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topToSuperview(offset: 0)
        stack.leftToSuperview(offset: 0)
        stack.rightToSuperview(offset: 0)
        stack.height(80)
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        stack.axis = .horizontal
        stack.layer.masksToBounds = true
        return stack
    }()
    
    lazy var cameraView: UIView = {
        let cameraView: UIView = .init()
        cameraView.width(stackItemWidth)
        addCameraPreviewLayer(cameraView) {
            self.addCameraIconLayer(cameraView)
        }
        return cameraView
    }()
    
    var didImageTapCompletion: ((UIImage) -> Void)?
    
    // MARK: - Init
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(
        cameraRecognizer: UITapGestureRecognizer,
        didImageTapCompletion: @escaping (UIImage) -> Void
    ) {
        self.init(nibName: nil, bundle: nil)
        
        self.didImageTapCompletion = didImageTapCompletion
        
        setupView()
        
        cameraView.addGestureRecognizer(cameraRecognizer)
        stack.addArrangedSubview(cameraView)
        
        getPhotos { image in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.width(self.stackItemWidth)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didImageTap)))
            self.stack.addArrangedSubview(imageView)
        }
        
        let photoVideoAction = UIAlertAction(title: "Photo", style: .default)
        let fileAction = UIAlertAction(title: "File", style: .default)
        let geoAction = UIAlertAction(title: "Geoposition", style: .default)
        let contactAction = UIAlertAction(title: "Contact", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(photoVideoAction) // TODO: photo select
        addAction(fileAction) // TODO: file select
        addAction(geoAction) // TODO: geolocations
        addAction(contactAction) // TODO: contacts select
        addAction(cancelAction)
    }
    
    @objc func didImageTap(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender,
            let pickedImageView = sender.view as? UIImageView,
            let pickedImage = pickedImageView.image {
            didImageTapCompletion?(pickedImage)
        }
    }
    
    private func setupView() {
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(380)
    }

    // MARK: - Preview camera layers helpers
    
    private func addCameraPreviewLayer(_ previewView: UIView, completion: @escaping () -> Void) {
        var captureSession: AVCaptureSession!
        var stillImageOutput: AVCapturePhotoOutput!
        var videoPreviewLayer: AVCaptureVideoPreviewLayer!
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.connection?.videoOrientation = .portrait
                previewView.layer.addSublayer(videoPreviewLayer)
            }
        } catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            captureSession.startRunning()
            DispatchQueue.main.async {
                videoPreviewLayer.frame = previewView.bounds
                completion()
            }
        }
    }
    
    private func addCameraIconLayer(_ previewView: UIView) {
        let myLayer = CALayer()
        let myImage = UIImage(
            systemName: "camera.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)
        )?.imageWithColor(color: .white).cgImage
        myLayer.contents = myImage
        previewView.layer.contentsGravity = .center
        myLayer.frame = previewView.bounds.insetBy(dx: 25, dy: 30)
        previewView.layer.addSublayer(myLayer)
    }
    
    // MARK: Get last 4 photos from gallery
    
    private func getPhotos(completion: @escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .none
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 4
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                manager.requestImage(
                    for: asset,
                    targetSize: .init(),
                    contentMode: .aspectFill,
                    options: requestOptions
                ) { (image, _) in
                    if let image = image {
                        completion(image)
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            print("no photos to display")
        }
        
    }
}
