//
//  DeviceCollectionViewCell.swift
//  CollectionViewStickyCells
//
//  Created by Jhonny Mena on 1/15/20.
//  Copyright © 2020 Jhonny Bill Mena. All rights reserved.
//

import Foundation
import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = "deviceCollectionViewCellReuseIdentifier"
  
  private var iconImageView: UIImageView!
  private var nameLabel: UILabel!
  private var stackView: UIStackView!
  
  var device: Device! = nil {
    didSet { configureCell() }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    iconImageView = UIImageView(frame: frame)
    nameLabel = UILabel(frame: frame)
    
    stackView = UIStackView(arrangedSubviews: [iconImageView, nameLabel])
    stackView.axis = .horizontal
    stackView.spacing = 10.0
    stackView.alignment = .center
    
    nameLabel.font = .preferredFont(forTextStyle: .headline)
    nameLabel.textColor = .label
    nameLabel.numberOfLines = 0
    nameLabel.adjustsFontForContentSizeCategory = true
    
    iconImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.tintColor = .systemPurple
    
    translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
      iconImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
      
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
    
    contentView.backgroundColor = .secondarySystemBackground
    contentView.layer.cornerRadius = 15
    contentView.layer.cornerCurve = .continuous
    contentView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureCell() {
    iconImageView.image = device.icon
    nameLabel.text = device.name
  }
}
