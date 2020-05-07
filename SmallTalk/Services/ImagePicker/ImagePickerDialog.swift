//
//  ImagePickerDialog.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit
import AVFoundation
import Photos

protocol ImagePickerDialogDelegate: AnyObject {
    func didCameraTap()
    func didLastImageTap(_ image: UIImage)
    func didPhotosTap(mode: ImagePickerDialog.Mode)
}

class ImagePickerDialog: UIAlertController {
    
    enum Mode {
        case single
        case multiple
    }
    
    // MARK: - Vars
    
    weak var delegate: ImagePickerDialogDelegate?
    var mode: Mode!
    
    lazy var stackItemWidth: CGFloat = (view.bounds.width - 20 - 5 * 4) / 5
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topToSuperview()
        stack.horizontalToSuperview()
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
        return cameraView
    }()
    
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
        delegate: ImagePickerDialogDelegate,
        mode: Mode
    ) {
        self.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.mode = mode
        
        setupView()
        
        self.cameraView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(didCameraTap)
        ))
        self.stack.addArrangedSubview(self.cameraView)
        
        let photosCount = 4
        
        for _ in 0 ..< photosCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.width(self.stackItemWidth)
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didImageTap)))
            self.stack.addArrangedSubview(imageView)
        }
        
        self.addCameraPreviewLayer(self.cameraView) {
            self.addCameraIconLayer(self.cameraView)
            
            self.getPhotos(photosCount) { image, index in
                (self.stack.arrangedSubviews[index + 1] as! UIImageView).image = image
            }
        }
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didPhotosTap(mode: mode)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(photoAction)
        addAction(cancelAction)
    }
    
    @objc func didCameraTap() {
        delegate?.didCameraTap()
    }
    
    @objc func didImageTap(_ sender: UITapGestureRecognizer? = nil) {
        if let sender = sender,
            let pickedImageView = sender.view as? UIImageView,
            let pickedImage = pickedImageView.image {
            delegate?.didLastImageTap(pickedImage)
        }
    }
    
    private func setupView() {
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(205)
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
    
    private func getPhotos(_ count: Int, completion: @escaping (UIImage, Int) -> Void) {
        PHPhotoLibrary.requestAuthorization { _ in
            let manager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.resizeMode = .none
            let fetchOptions = PHFetchOptions()
            fetchOptions.fetchLimit = count
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
                            completion(image, i)
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
}
