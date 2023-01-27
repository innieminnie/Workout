//
//  MonthlyPageCollectionView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/13.
//

import UIKit

class MonthlyPageCollectionView: UICollectionView {
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    super.init(frame: .zero, collectionViewLayout: layout)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.backgroundColor = .white
    
    let nib = UINib(nibName: "CalendarDateCollectionViewCell", bundle: nil)
    self.register(nib, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.identifier)
    self.showsHorizontalScrollIndicator = false
    self.showsVerticalScrollIndicator = false
    self.allowsMultipleSelection = false
    self.isScrollEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
