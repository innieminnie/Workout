//
//  WorkoutSetConfigurationView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/19.
//

import UIKit

class WorkoutSetConfigurationView: UIView {
  private let checkButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    button.addTarget(self, action: #selector(tappedCheckButton), for: .touchUpInside)
    
    return button
  }()
  
  private let weightTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .systemBlue
    textField.layer.cornerRadius = 5
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    
    return textField
  }()
  
  private let weightUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "kg"
    return label
  }()
  
  private let countTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .systemBlue
    textField.layer.cornerRadius = 5
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    
    return textField
  }()
  
  private let countUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "회"
    return label
  }()
  
  private let multiplierLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "X"
    return label
  }()
  
  private let weightStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 8
    
    return stackView
  }()
  
  private let countStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 8
    
    return stackView
  }()
  
  private let setStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    
    return stackView
  }()
  
  init() {
    super.init(frame: .zero)
    
    weightTextField.delegate = self
    countTextField.delegate = self
   
    configureWeightStackView()
    configureCountStackView()
    configureSetStackView()
    setUpLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureWeightStackView() {
    weightStackView.addArrangedSubview(weightTextField)
    weightStackView.addArrangedSubview(weightUnitLabel)
  }
  
  private func configureCountStackView() {
    countStackView.addArrangedSubview(countTextField)
    countStackView.addArrangedSubview(countUnitLabel)
  }
  
  private func configureSetStackView() {
    setStackView.addArrangedSubview(checkButton)
    setStackView.addArrangedSubview(weightStackView)
    setStackView.addArrangedSubview(multiplierLabel)
    setStackView.addArrangedSubview(countStackView)
    
    self.addSubview(setStackView)
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      weightTextField.widthAnchor.constraint(equalToConstant: 30),
      countTextField.widthAnchor.constraint(equalToConstant: 30),
      setStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      setStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      setStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      setStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
    ])
  }
  
  @objc private func tappedCheckButton(sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
}
extension WorkoutSetConfigurationView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    NotificationCenter.default.post(name: NSNotification.Name("TappedTextField"), object: textField, userInfo: nil)
  }
}
