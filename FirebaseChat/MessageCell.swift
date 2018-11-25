//
//  ChatCell.swift
//  FirebaseChat
//
//  Created by Ranjith Kumar on 10/16/18.
//  Copyright © 2018 DrawRect. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    private let bubbleImageView = UIImageView()
    private var outgoingConstraints: [NSLayoutConstraint]!
    private var incomingConstraints: [NSLayoutConstraint]!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: bubbleImageView.centerYAnchor).isActive = true
        
        bubbleImageView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 50).isActive = true
        bubbleImageView.heightAnchor.constraint(equalTo: messageLabel.heightAnchor, constant: 20).isActive = true

        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bubbleImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor)
        ]
        
        incomingConstraints = [
            bubbleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor)
        ]
        
        bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        bubbleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incoming(_ incoming: Bool) {
        if incoming {
            NSLayoutConstraint.deactivate(outgoingConstraints)
            NSLayoutConstraint.activate(incomingConstraints)
            bubbleImageView.image = bubble.incoming
        }else {
            NSLayoutConstraint.deactivate(incomingConstraints)
            NSLayoutConstraint.activate(outgoingConstraints)
            bubbleImageView.image = bubble.outgoing
        }
    }
}

let bubble = makeBubble()

func makeBubble() -> (incoming: UIImage, outgoing: UIImage) {
    let image = UIImage(named: "MessageBubble")!
    
    let insetsIncoming = UIEdgeInsets.init(top: 17, left: 26, bottom: 17.5, right: 21)
    let insetsOutgoing = UIEdgeInsets.init(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
    let outgoing = coloredImage(image: image, red: 0/255, green: 122/255, blue: 255/255, alpha: 1).resizableImage(withCapInsets: insetsOutgoing)
    
    let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImage.Orientation.upMirrored)
    
    let incoming = coloredImage(image: flippedImage, red: 229/255, green: 229/255, blue: 229/255, alpha: 1).resizableImage(withCapInsets: insetsIncoming)

    return (incoming,outgoing)
}

func coloredImage(image: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIImage! {

    let rect = CGRect(origin: .zero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.draw(in: rect)
    
    context?.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
    context?.setBlendMode(.sourceAtop)
    context?.fill(rect)
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return result
}
