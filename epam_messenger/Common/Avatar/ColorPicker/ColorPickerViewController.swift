//
//  ColorPickerViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 14.04.2020.
//

import UIKit
import ChromaColorPicker

class ColorPickerViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var imageWheel: UIView!
    weak var delegate: ChromaColorPickerDelegate?
    
    // MARK: Vars
    
    let colorPicker = ChromaColorPicker()

    // MARK: Init

    init(initialColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        
        let homeHandle = colorPicker.addHandle(at: initialColor)
        homeHandle.accessoryViewEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 4, right: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorPicker()
        
        imageWheel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutside)))
        view.bringSubviewToFront(imageWheel)
    }
    
    @objc func didTapOutside() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupColorPicker() {
        colorPicker.delegate = delegate
        colorPicker.borderWidth = 0
        colorPicker.showsShadow = false
        imageWheel.layer.cornerRadius = imageWheel.bounds.width / 2
        imageWheel.addSubview(colorPicker)
        imageWheel.bringSubviewToFront(colorPicker)
        colorPicker.edgesToSuperview()
    }

}
