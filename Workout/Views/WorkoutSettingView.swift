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

class WorkoutSettingView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "새로운 운동 등록"
    label.font = UIFont.Pretendard(type: .Regular, size: 17)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.textColor = .black
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var nameTextFieldView: RoundedCornerTextFieldView = {
    let textFieldView = RoundedCornerTextFieldView(value: " ")
    let textField = textFieldView.valueTextField
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.isUserInteractionEnabled = true
    textField.textColor = .black
    textField.textAlignment = .center
    textField.font = UIFont.Pretendard(type: .Bold, size: 20)
    textField.placeholder = "등록할 운동명을 입력하세요."
    
    return textFieldView
  }()
  
  private lazy var nameCheckLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = " "
    label.textColor = .red
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Regular, size: 12)
    
    return label
  }()
  
  private lazy var weightUnitSegmentedControl: UISegmentedControl = {
    let unitsLabel = WeightUnit.allCases.map { $0.rawValue }
    let uiSegmentedControl = UISegmentedControl(items: unitsLabel)
    uiSegmentedControl.addAction( UIAction { _ in self.selectedWeightUnit(sender: uiSegmentedControl) }, for: .valueChanged)
    uiSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    
    uiSegmentedControl.layer.borderColor = 0xF58423.convertToRGB().withAlphaComponent(0.3).cgColor
    uiSegmentedControl.layer.borderWidth = 1
    uiSegmentedControl.selectedSegmentTintColor = 0xF58423.convertToRGB()
    
    return uiSegmentedControl
  }()
  
  private lazy var weightUnitCheckLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = " "
    label.textColor = .red
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Regular, size: 12)
    
    return label
  }()
  
  private lazy var bodySectionCollectionView = BodySectionCollectionView()
  
  private lazy var bodySectionCheckLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = " "
    label.textColor = .red
    label.textAlignment = .center
    label.font = UIFont.Pretendard(type: .Regular, size: 12)
    
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.tappedCancel() })
    button.customizeConfiguration(with: "취소", foregroundColor: .red, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.backgroundColor = .white
    button.layer.borderColor = 0xBEC0C2.convertToRGB().cgColor
    button.layer.borderWidth = 2
    button.applyCornerRadius(12)
    
    return button
  }()
  
  private lazy var updateButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.tappedUpdate() })
    button.customizeConfiguration(with: "등록할게요", foregroundColor: .white, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.backgroundColor = 0x096DB6.convertToRGB()
    button.applyCornerRadius(12)
    
    return button
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    
    return stackView
  }()
  
  private var selectedCell: BodySectionCollectionViewCell?
  private var selectedBodySection: BodySection?
  private var selectedWeightUnit: WeightUnit?
  private var previousName = String()
  private var isEditable = true {
    didSet {
      if isEditable {
        self.titleLabel.isHidden = true
        
        updateButton.customizeConfiguration(with: "등록할게요", foregroundColor: .white, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
        
        nameTextFieldView.isUserInteractionEnabled = true
        nameTextFieldView.valueTextField.textColor = .black
        nameTextFieldView.backgroundColor = .lightGray
        
        weightUnitSegmentedControl.isUserInteractionEnabled = true
        bodySectionCollectionView.isUserInteractionEnabled = true
        setFirstResponder()
      } else {
        updateButton.customizeConfiguration(with: "수정할래요", foregroundColor: .white, font: UIFont.Pretendard(type: .Bold, size: 15), buttonSize: .medium)
        
        nameTextFieldView.isUserInteractionEnabled = false
        nameTextFieldView.backgroundColor = .clear
        
        weightUnitSegmentedControl.isUserInteractionEnabled = false
        bodySectionCollectionView.isUserInteractionEnabled = false
      }
    }
  }
  
  weak var delegate: UpdateWorkoutActionDelegate?
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.translatesAutoresizingMaskIntoConstraints = false
    self.applyCornerRadius(24)
    
    bodySectionCollectionView.dataSource = self
    bodySectionCollectionView.delegate = self
    
    addSubview(titleLabel)
    addSubview(nameTextFieldView)
    addSubview(nameCheckLabel)
    addSubview(weightUnitSegmentedControl)
    addSubview(weightUnitCheckLabel)
    addSubview(bodySectionCollectionView)
    addSubview(bodySectionCheckLabel)
    
    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(updateButton)
    addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      nameTextFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      nameTextFieldView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      nameTextFieldView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      nameCheckLabel.topAnchor.constraint(equalTo: nameTextFieldView.bottomAnchor),
      nameCheckLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      nameCheckLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      weightUnitSegmentedControl.topAnchor.constraint(equalTo: nameCheckLabel.bottomAnchor),
      weightUnitSegmentedControl.centerXAnchor.constraint(equalTo: nameCheckLabel.centerXAnchor),
      weightUnitSegmentedControl.widthAnchor.constraint(equalTo: nameCheckLabel.widthAnchor, multiplier: 0.5),
      
      weightUnitCheckLabel.topAnchor.constraint(equalTo: weightUnitSegmentedControl.bottomAnchor),
      weightUnitCheckLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      weightUnitCheckLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      bodySectionCollectionView.topAnchor.constraint(equalTo: weightUnitCheckLabel.bottomAnchor),
      bodySectionCollectionView.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor),
      bodySectionCollectionView.trailingAnchor.constraint(equalTo: nameTextFieldView.trailingAnchor),
      bodySectionCollectionView.bottomAnchor.constraint(equalTo: bodySectionCheckLabel.topAnchor),
      
      bodySectionCheckLabel.topAnchor.constraint(equalTo: bodySectionCollectionView.bottomAnchor),
      bodySectionCheckLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      bodySectionCheckLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      bodySectionCheckLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -10),
      
      buttonStackView.leadingAnchor.constraint(equalTo: nameTextFieldView.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: nameTextFieldView.trailingAnchor),
      buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
    ])
    
    nameTextFieldView.valueTextField.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUp(with workout: Workout) {
    self.isEditable = false
    titleLabel.text = "운동 정보"
    nameTextFieldView.valueTextField.text = workout.displayName()
    selectedBodySection = workout.bodySection
    selectedWeightUnit = workout.weightUnit
    setSelectedWeightUnit()
    previousName = workout.displayName()
  }
  
  func setFirstResponder() {
    nameTextFieldView.becomeFirstResponder()
  }
}
extension WorkoutSettingView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate?.resignFirstResponder(on: textField)
    return true
  }
}
extension WorkoutSettingView {
  private func tappedCancel() {
    delegate?.tappedCancel()
  }
  
  private func tappedUpdate() {
    if !self.isEditable {
      self.isEditable = true
    } else {
      guard let name = nameTextFieldView.valueTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
        nameCheckLabel.text = "새로운 운동명을 입력해주세요 :)"
        return
      }
      
      guard let weightUnit = self.selectedWeightUnit else {
        weightUnitCheckLabel.text = "무게단위를 선택해주세요 :)"
        return
      }
      
      guard let bodySectionCell = self.selectedCell else {
        bodySectionCheckLabel.text = "운동 부위를 선택해주세요 :)"
        return
      }
      
      guard let bodySection = bodySectionCell.getBodySection() else { return }
      guard workoutManager.checkNameValidation(previousName, name) else {
        nameCheckLabel.text = "\(name)는 이미 사용중인 운동명이에요 :)"
        return
      }
      
      
      self.delegate?.register(name, weightUnit, bodySection)
    }
  }
  
  private func selectedWeightUnit(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      self.selectedWeightUnit =  .kg
    case 1:
      self.selectedWeightUnit = .lb
    default:
      break
    }
  }
  
  private func setSelectedWeightUnit() {
    guard let selectedWeightUnit = selectedWeightUnit else {
      return
    }
    
    switch selectedWeightUnit {
    case .kg:
      self.weightUnitSegmentedControl.selectedSegmentIndex = 0
    case .lb:
      self.weightUnitSegmentedControl.selectedSegmentIndex = 1
    }
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
