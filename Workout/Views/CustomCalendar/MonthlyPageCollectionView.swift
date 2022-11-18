//
//  MonthlyPageCollectionView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/13.
//

import UIKit

class MonthlyPageCollectionView: UICollectionView {
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return contentSize
  }
  
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    super.init(frame: .zero, collectionViewLayout: layout)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.backgroundColor = .white
    self.layer.borderColor = 0xF58423.converToRGB().cgColor
    self.layer.borderWidth = 2
    self.applyCornerRadius()
    
    let nib = UINib(nibName: "CalendarDateCollectionViewCell", bundle: nil)
    self.register(nib, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.identifier)
    self.showsHorizontalScrollIndicator = false
    self.showsVerticalScrollIndicator = false
    self.allowsMultipleSelection = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
