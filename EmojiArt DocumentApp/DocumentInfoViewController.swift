//
//  DocumentInfoViewController.swift
//  EmojiArt DocumentApp
//
//  Created by Abdurakhmon Jamoliddinov on 12/20/20.
//

import UIKit

class DocumentInfoViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var returnButton: UIButton!
    
    var document: EmojiArtDocument? {
        didSet {
            updateUI()
        }
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let bestSmalledSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: bestSmalledSize.width + 30, height: bestSmalledSize.height + 30)
        }
    }

    
    private func updateUI(){
        if sizeLabel != nil,
           createdLabel != nil,
           let url = document?.fileURL,
           let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                createdLabel.text = formatter.string(from: created)
            }
        }
        
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspectRatio)
            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView!,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0
            )
            thumbnailImageView.addConstraint(thumbnailAspectRatio)
        }
        
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnButton?.isHidden = true
            view.backgroundColor = .clear
        }
        
    }
    
    @IBAction func done(){
        presentingViewController?.dismiss(animated: true)
    }
    
    
    
}
