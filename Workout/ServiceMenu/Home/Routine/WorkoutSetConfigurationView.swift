//
//  WorkoutSetConfigurationView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/19.
//

import UIKit



class WorkoutSetConfigurationView: UIView {
  private lazy var setIndex: Int = 0
  
  private var setSum: Float = 0 {
    didSet {
      delegate?.setSumUpdated(from: oldValue, to: setSum)
    }
  }
  
  private var weightValue: Float = 0 {
    didSet {
      delegate?.weightValueUpdated(to: weightValue, of: self.setIndex)
      
      setSum -= oldValue * Float(countValue)
      setSum += weightValue * Float(countValue)
    }
  }
  
  private var countValue: UInt = 0 {
    didSet {
      delegate?.countValueUpdated(to: countValue, of: self.setIndex)
      
      setSum -= Float(oldValue) * weightValue
      setSum += Float(countValue) * weightValue
    }
  }
  
  weak var delegate: WorkoutSetConfigurationViewDelegate?
  
  private let setIndexLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false

    label.textColor = .black
    label.font = .boldSystemFont(ofSize: 17)
    
    return label
  }()
  
  private lazy var weightTextFieldView: RoundedCornerTextFieldView = {
    let textFieldView = RoundedCornerTextFieldView(value: "0.0")
    let textField = textFieldView.valueTextField
    
    textField.addAction(UIAction { _ in self.textFieldValueChanged(sender: textField) }, for: .editingChanged)
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .clear
    textField.keyboardType = .decimalPad
    textField.textAlignment = .right
    textField.font = UIFont.boldSystemFont(ofSize: 16)
    textField.placeholder = "\(0.0)"
    
    return textFieldView
  }()
  
  private let weightUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "kg"
    label.textColor = .black
    
    return label
  }()
  
  private lazy var countTextFieldView: RoundedCornerTextFieldView = {
    let textFieldView = RoundedCornerTextFieldView(value: "0")
    let textField = textFieldView.valueTextField
    
    textField.addAction(UIAction { _ in self.textFieldValueChanged(sender: textField) }, for: .editingChanged)
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .clear
    textField.keyboardType = .numberPad
    textField.textAlignment = .right
    textField.font = UIFont.boldSystemFont(ofSize: 16)
    textField.placeholder = "\(0)"
    
    return textFieldView
  }()
  
  private let countUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "reps"
    label.textColor = .black
    
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
    
    stackView.setContentCompressionResistancePriority(.required, for: .vertical)
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fill
    
    return stackView
  }()
  
  init(index: Int, setInformation: SetConfiguration, unit: WeightUnit) {
    super.init(frame: .zero)
    
    self.setIndex = index
    weightTextFieldView.valueTextField.delegate = self
    countTextFieldView.valueTextField.delegate = self
    
    configureWeightStackView()
    configureCountStackView()
    configureWeightUnit(with: unit)
    configureSetStackView(with: setInformation)
    setUpLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    delegate?.setSumUpdated(from: setSum, to: 0)
  }
  
  func resetWeightAndCountValues() {
    self.weightValue = 0
    self.countValue = 0
  }
  
  func showDoingStatusView() {
    weightTextFieldView.isUserInteractionEnabled = true
    weightTextFieldView.backgroundColor = 0xBEC0C2.convertToRGB()
    weightTextFieldView.valueTextField.textColor = .black
    
    countTextFieldView.isUserInteractionEnabled = true
    countTextFieldView.backgroundColor = 0xBEC0C2.convertToRGB()
    countTextFieldView.valueTextField.textColor = .black
  }
  
  func showDoneStatusView() {
    weightTextFieldView.isUserInteractionEnabled = false
    weightTextFieldView.backgroundColor = .clear
    weightTextFieldView.valueTextField.textColor = 0x096DB6.convertToRGB()
    
    countTextFieldView.isUserInteractionEnabled = false
    countTextFieldView.backgroundColor = .clear
    countTextFieldView.valueTextField.textColor = 0x096DB6.convertToRGB()
  }
  
  func allFieldsAreWritten() -> Bool {
    return weightTextFieldView.valueTextField.hasText && countTextFieldView.valueTextField.hasText
  }
}
extension WorkoutSetConfigurationView {
  private func configureWeightStackView() {
    weightStackView.addArrangedSubview(weightTextFieldView)
    weightStackView.addArrangedSubview(weightUnitLabel)
    
    NSLayoutConstraint.activate([
      weightTextFieldView.widthAnchor.constraint(equalTo: weightUnitLabel.widthAnchor, multiplier: 2.0)
      ])
  }
  
  private func configureCountStackView() {
    countStackView.addArrangedSubview(countTextFieldView)
    countStackView.addArrangedSubview(countUnitLabel)
    
    NSLayoutConstraint.activate([
      countTextFieldView.widthAnchor.constraint(equalTo: countUnitLabel.widthAnchor, multiplier: 1.5)
    ])
  }
  
  private func configureWeightUnit(with unit: WeightUnit) {
    weightUnitLabel.text = unit.rawValue
  }
  
  private func configureSetStackView(with setInformation: SetConfiguration) {
    setStackView.addArrangedSubview(setIndexLabel)
    setIndexLabel.text = "Set \(self.setIndex + 1)  "
    setStackView.addArrangedSubview(weightStackView)
    setStackView.addArrangedSubview(countStackView)
    self.addSubview(setStackView)
    
    if let displayWeight = setInformation.displayWeight {
      weightTextFieldView.valueTextField.text = "\(displayWeight)"
    } else {
      weightTextFieldView.valueTextField.text = nil
    }
    
    if let displayCount = setInformation.displayCount {
      countTextFieldView.valueTextField.text = "\(displayCount)"
    } else {
      countTextFieldView.valueTextField.text = nil
    }
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      setStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
      setStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      setStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      setStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
      
      weightStackView.widthAnchor.constraint(equalTo: setStackView.widthAnchor, multiplier: 0.35),
      countStackView.widthAnchor.constraint(equalTo: weightStackView.widthAnchor),
      
    ])
  }
  
  private func updateSetSum(sender: UITextField) {
    switch sender {
    case self.countTextFieldView.valueTextField:
      guard let text = sender.text,
            let countValue = UInt(text) else {
              countValue = 0
              return
            }

      self.countValue = countValue
    case self.weightTextFieldView.valueTextField:
      guard let text = sender.text,
            let weightValue = Float(text) else {
              weightValue = 0
              return
            }

      self.weightValue = weightValue
    default:
      break
    }
  }
  
  private func textFieldValueChanged(sender: UITextField) {
    updateSetSum(sender: sender)
  }
}
extension WorkoutSetConfigurationView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    NotificationCenter.default.post(name: NSNotification.Name("TappedTextField"), object: textField, userInfo: nil)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateSetSum(sender: textField)
  }
}
