//
//  MediaCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import Reusable

protocol MediaCellDelegate: AnyObject {
    func didMediaTap(_ media: MediaProtocol)
}

class MediaCell: UICollectionViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet var image: UIImageView!
    
    // MARK: - Vars
    
    var media: MediaProtocol! {
        didSet {
            image.sd_setSmallImage(with: media.ref)
        }
    }
    
    weak var delegate: MediaCellDelegate?
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc func didTap() {
        delegate?.didMediaTap(media)
    }
    
    // MARK: - Init
    
    func loadMedia(_ media: MediaProtocol) {
        self.media = media
    }
    
}
