//
//  NewWorkoutView.swift
//  Workout
//
//  Created by 강인희 on 2021/12/02.
//

import Foundation
import UIKit

class BodySectionTapGesture: UITapGestureRecognizer {
  var tappedCell: BodySectionCollectionViewCell?
}

protocol UpdateWorkoutActionDelegate: AnyObject {
  func tappedCancel()
  func register(_ name: String, _ bodySection: BodySection)
  func resignFirstResponder(on textField: UITextField)
}

class WorkoutSettingView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "새로운 운동 등록"
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.textColor = .black
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.isUserInteractionEnabled = false
    textField.backgroundColor = .clear
    textField.borderStyle = .roundedRect
    textField.placeholder = "등록할 운동명을 입력하세요."
    
    return textField
  }()
  
  private lazy var nameCheckLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = " "
    label.textColor = .red
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 13)
    
    return label
  }()
  
  private lazy var bodySectionCollectionView = BodySectionCollectionView()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.red, for: .normal)
    
    return button
  }()
  
  private lazy var updateButton: UIButton = {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(tappedUpdate), for: .touchUpInside)
    button.setTitle("정보 수정", for: .normal)
    button.setTitleColor(.black, for: .normal)
    
    return button
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 3
    
    return stackView
  }()
  
  private var selectedCell: BodySectionCollectionViewCell?
  private var selectedBodySection: BodySection?
  private var previousName = String()
  private var isEditable = false {
    didSet {
      if isEditable {
        updateButton.setTitle("수정 완료", for: .normal)
        
        nameTextField.isUserInteractionEnabled = true
        nameTextField.textColor = .black
        
        bodySectionCollectionView.isUserInteractionEnabled = true
        setFirstResponder()
      } else {
        updateButton.setTitle("정보 수정", for: .normal)
        
        nameTextField.isUserInteractionEnabled = false
        nameTextField.backgroundColor = .clear
        
        bodySectionCollectionView.isUserInteractionEnabled = false
      }
    }
  }
  
  weak var delegate: UpdateWorkoutActionDelegate?
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.translatesAutoresizingMaskIntoConstraints = false
    self.applyShadow()
    
    bodySectionCollectionView.dataSource = self
    bodySectionCollectionView.delegate = self
    
    addSubview(titleLabel)
    addSubview(nameTextField)
    addSubview(nameCheckLabel)
    addSubview(bodySectionCollectionView)
    bodySectionCollectionView.isUserInteractionEnabled = false
    
    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(updateButton)
    addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 30),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      nameCheckLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
      nameCheckLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      nameCheckLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      bodySectionCollectionView.topAnchor.constraint(equalTo: nameCheckLabel.bottomAnchor, constant: 20),
      bodySectionCollectionView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
      bodySectionCollectionView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
      bodySectionCollectionView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
      
      buttonStackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
      buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
    ])
    
    nameTextField.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func cellTapped(gesture: BodySectionTapGesture) {
    if let currentSelectedCell = selectedCell {
      currentSelectedCell.isSelected = false
      currentSelectedCell.showDeselectedStatus()
    }
    
    if let currentTappedCell = gesture.tappedCell {
      currentTappedCell.isSelected = true
      currentTappedCell.showSelectedStatus()
      self.selectedCell = currentTappedCell
    }
  }
  
  func setUp(with workout: Workout) {
    titleLabel.text = "운동 정보"
    nameTextField.text = workout.displayName()
    selectedBodySection = workout.bodySection
    previousName = workout.displayName()
  }
  
  func setFirstResponder() {
    nameTextField.becomeFirstResponder()
  }
}
extension WorkoutSettingView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate?.resignFirstResponder(on: textField)
    return true
  }
}
extension WorkoutSettingView {
  @objc private func tappedCancel() {
    delegate?.tappedCancel()
  }
  
  @objc private func tappedUpdate() {
    if !self.isEditable {
      self.isEditable = true
    } else {
      guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            let bodySectionCell = self.selectedCell else {
        nameCheckLabel.text = "필수사항을 전부 입력해주세요 :)"
        return
      }
      
      guard let bodySection = bodySectionCell.getBodySection() else { return }
      guard workoutManager.checkNameValidation(previousName, name) else {
        nameCheckLabel.text = "\(name)는 이미 사용중인 운동명이에요 :)"
        return
      }
      
      self.isEditable = false
      self.delegate?.register(name, bodySection)
    }
  }
}
extension WorkoutSettingView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    BodySection.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let bodySection = BodySection.allCases[indexPath.row]
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BodySectionCollectionViewCell.identifier, for: indexPath) as? BodySectionCollectionViewCell else { return UICollectionViewCell()
    }
    
    if let selectedBodySection = self.selectedBodySection, selectedBodySection == bodySection {
      cell.isSelected = true
      self.selectedCell = cell
    }
    cell.setUp(with: bodySection)
    
    let bodySectionTapGesture = BodySectionTapGesture(target: self, action: #selector(cellTapped(gesture:)))
    bodySectionTapGesture.tappedCell = cell
    cell.addGestureRecognizer(bodySectionTapGesture)
    
    return cell
  }
}
extension WorkoutSettingView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth =  bodySectionCollectionView.frame.width / 4
    let cellHeight = cellWidth / 2
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
