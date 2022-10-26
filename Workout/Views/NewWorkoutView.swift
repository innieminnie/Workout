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
}

class NewWorkoutView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.text = "NEW"
    label.textColor = .black
    label.textAlignment = .center
    
    return label
  }()
  
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .lightGray
    textField.borderStyle = .roundedRect
    textField.placeholder = "등록할 운동명을 입력하세요."
    
    return textField
  }()
  
  private lazy var bodySectionSelectionCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.allowsMultipleSelection = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    
    let nib = UINib(nibName: "BodySectionCollectionViewCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: BodySectionCollectionViewCell.identifier)
    
    return collectionView
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.red, for: .normal)
    
    return button
  }()
  
  private lazy var completeButton: UIButton = {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(tappedComplete), for: .touchUpInside)
    button.setTitle("완료", for: .normal)
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
  
  weak var delegate: UpdateWorkoutActionDelegate?
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    bodySectionSelectionCollectionView.dataSource = self
    bodySectionSelectionCollectionView.delegate = self
    
    addSubview(titleLabel)
    addSubview(nameTextField)
    addSubview(bodySectionSelectionCollectionView)
    
    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(completeButton)
    addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      nameTextField.bottomAnchor.constraint(equalTo: bodySectionSelectionCollectionView.topAnchor, constant: -20),
      
      bodySectionSelectionCollectionView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
      bodySectionSelectionCollectionView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
      bodySectionSelectionCollectionView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
      
      buttonStackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
      buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -300)
    ])
    
    let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
    self.addGestureRecognizer(viewTapGesture)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    nameTextField.text = workout.displayName()
    selectedBodySection = workout.bodySection
    previousName = workout.displayName()
  }
}
extension NewWorkoutView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
extension NewWorkoutView {
  @objc private func viewTapped() {
    self.endEditing(true)
  }
  
  @objc private func tappedCancel() {
    delegate?.tappedCancel()
  }

  @objc private func tappedComplete() {
    guard let name = nameTextField.text else { print("필수사항을 전부 작성해주세요"); return }
    guard let bodySectionCell = self.selectedCell else { print("필수사항을 전부 작성해주세요"); return }
    guard let bodySection = bodySectionCell.getBodySection() else { return }
    guard workoutManager.checkNameValidation(previousName, name) else { print("이미 사용중인 운동명이에요. 운동명을 변경해주세요"); return }
    
    self.delegate?.register(name, bodySection)
  }
  
  @objc private func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
    
    let keyboardHeight = keyboardFrame.height
    if self.frame.height - keyboardHeight < buttonStackView.frame.origin.y   {
      buttonStackView.frame.origin.y -= keyboardHeight
    }
  }
  
  @objc private func keyboardWillHide(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
    
    let keyboardHeight = keyboardFrame.height
    buttonStackView.frame.origin.y += keyboardHeight
  }
}
extension NewWorkoutView: UICollectionViewDataSource {
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
extension NewWorkoutView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth =  bodySectionSelectionCollectionView.frame.width / 4
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
