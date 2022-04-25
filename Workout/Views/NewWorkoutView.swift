//
//  NewWorkoutView.swift
//  Workout
//
//  Created by 강인희 on 2021/12/02.
//

import Foundation
import UIKit

protocol NewWorkoutActionDelegate: AnyObject {
  func tappedCancel()
  func tappedComplete(with newWorkout: Workout)
}

class NewWorkoutView: UIView {
  static let measurementTypes: [Measurement] = {
    return Measurement.allCases
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
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
    textField.placeholder = "새로운 운동명을 입력하세요."
    
    return textField
  }()
  
  private let nameStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.spacing = 3
    
    return stackView
  }()
  
  private let measurementStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    
    return stackView
  }()
  
  private let newWorkoutRegisterFormStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.axis = .vertical
    stackView.spacing = 20
    
    return stackView
  }()
  
  private let cancelButton: UIButton = {
    let button = UIButton()
    
    button.addTarget(self, action: #selector(tappedCancel), for: .touchUpInside)
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.red, for: .normal)
    
    return button
  }()
  
  private let completeButton: UIButton = {
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
  
  private var activatedMeasurementView: RoundedCornerLabelView?
  weak var delegate: NewWorkoutActionDelegate?
  
  init() {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(titleLabel)
    
    for measurementValue in NewWorkoutView.measurementTypes {
      let measurementRoundedCornerView = RoundedCornerLabelView(title: measurementValue.rawValue)
      measurementStackView.addArrangedSubview(measurementRoundedCornerView)
      
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(measurementTapped(_:)))
      measurementRoundedCornerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    newWorkoutRegisterFormStackView.addArrangedSubview(nameTextField)
    newWorkoutRegisterFormStackView.addArrangedSubview(measurementStackView)
    addSubview(newWorkoutRegisterFormStackView)
    
    buttonStackView.addArrangedSubview(cancelButton)
    buttonStackView.addArrangedSubview(completeButton)
    addSubview(buttonStackView)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
      newWorkoutRegisterFormStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      newWorkoutRegisterFormStackView.bottomAnchor.constraint(lessThanOrEqualTo: buttonStackView.topAnchor, constant: -20),
      newWorkoutRegisterFormStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
      newWorkoutRegisterFormStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
      
      buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
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
  
  @objc private func measurementTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
    guard let tappedMeasurementView = tapGestureRecognizer.view as? RoundedCornerLabelView else {
      return
    }
    
    guard let activatedMeasurementView = self.activatedMeasurementView else {
      tappedMeasurementView.backgroundColor = .blue
      self.activatedMeasurementView = tappedMeasurementView
      return
    }
    
    if activatedMeasurementView == tappedMeasurementView {
      tappedMeasurementView.backgroundColor = .white
      self.activatedMeasurementView = nil
    } else {
      activatedMeasurementView.backgroundColor = .white
      tappedMeasurementView.backgroundColor = .blue
      self.activatedMeasurementView = tappedMeasurementView
    }
  }
  
  @objc private func tappedCancel() {
    delegate?.tappedCancel()
  }
  
  @objc private func tappedComplete() {
    guard let name = nameTextField.text else {
      return
    }
    
    for (index, measurmentTypeView) in measurementStackView.arrangedSubviews.enumerated() {
      if self.activatedMeasurementView == measurmentTypeView {
        let selectedType = NewWorkoutView.measurementTypes[index]
        delegate?.tappedComplete(with: Workout(name, selectedType))
      }
    }
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
