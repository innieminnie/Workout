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

  @IBOutlet weak var bodySectionLabelView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setUp(with bodySection: BodySection) {
    self.bodySection = bodySection
    let roundedCornerLabelView = RoundedCornerLabelView(title: bodySection.rawValue)
    bodySectionLabelView.addSubview(roundedCornerLabelView)
    
    NSLayoutConstraint.activate([
      roundedCornerLabelView.topAnchor.constraint(equalTo: bodySectionLabelView.topAnchor, constant: 5),
      roundedCornerLabelView.leadingAnchor.constraint(equalTo: bodySectionLabelView.leadingAnchor, constant: 5),
      roundedCornerLabelView.trailingAnchor.constraint(equalTo: bodySectionLabelView.trailingAnchor, constant: -5),
      roundedCornerLabelView.bottomAnchor.constraint(equalTo: bodySectionLabelView.bottomAnchor, constant: -5)
    ])
  }
}
