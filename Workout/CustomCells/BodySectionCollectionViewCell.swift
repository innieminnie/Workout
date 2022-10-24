//
//  BodySectionCollectionViewCell.swift
//  Workout
//
//  Created by 강인희 on 2022/10/24.
//

import UIKit

class BodySectionCollectionViewCell: UICollectionViewCell {
  static let identifier = "bodySectionCollectionViewCell"
  private var bodySection: BodySection?
  private var roundedCornerLabelView: RoundedCornerLabelView?
  
  @IBOutlet weak var bodySectionLabelView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setUp(with bodySection: BodySection) {
    self.bodySection = bodySection
    self.roundedCornerLabelView = RoundedCornerLabelView(title: bodySection.rawValue)
    guard let roundedCornerLabelView = roundedCornerLabelView else {
      return
    }

    bodySectionLabelView.addSubview(roundedCornerLabelView)
    
    NSLayoutConstraint.activate([
      roundedCornerLabelView.topAnchor.constraint(equalTo: bodySectionLabelView.topAnchor, constant: 5),
      roundedCornerLabelView.leadingAnchor.constraint(equalTo: bodySectionLabelView.leadingAnchor, constant: 5),
      roundedCornerLabelView.trailingAnchor.constraint(equalTo: bodySectionLabelView.trailingAnchor, constant: -5),
      roundedCornerLabelView.bottomAnchor.constraint(equalTo: bodySectionLabelView.bottomAnchor, constant: -5)
    ])
  }
  
  func showSelectedStatus() {
    guard let roundedCornerLabelView = roundedCornerLabelView else {
      return
    }
    
    roundedCornerLabelView.changeToSelectedBackgroundColor()
  }
  
  func showDeselectedStatus() {
    guard let roundedCornerLabelView = roundedCornerLabelView else {
      return
    }
    
    roundedCornerLabelView.changeToDeselectedBackgroundColor()
  }
}
