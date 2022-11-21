//
//  WorkoutSetConfigurationView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/19.
//

import UIKit

protocol WorkoutSetConfigurationViewDelegate: AnyObject {
  func setSumUpdated(from oldValue: Float, to newValue: Float)
  func weightValueUpdated(to newValue: Float, of index: Int)
  func countValueUpdated(to newValue: UInt, of index: Int)
}

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
  
  private lazy var weightTextField: UITextFieldWithPadding = {
    let textField = UITextFieldWithPadding()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = 0xBEC0C2.convertToRGB()
    textField.applyCornerRadius(8)
    textField.keyboardType = .decimalPad
    textField.textAlignment = .right
    textField.font = UIFont.boldSystemFont(ofSize: 16)
    textField.placeholder = "\(0.0)"
    textField.text = "\(0.0)"
    
    textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    return textField
  }()
  
  private let weightUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "kg"
    label.textColor = .black
    
    return label
  }()
  
  private lazy var countTextField: UITextFieldWithPadding = {
    let textField = UITextFieldWithPadding()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = 0xBEC0C2.convertToRGB()
    textField.applyCornerRadius(8)
    textField.keyboardType = .numberPad
    textField.textAlignment = .right
    textField.font = UIFont.boldSystemFont(ofSize: 16)
    textField.placeholder = "\(0)"
    textField.text = "\(0)"
    
    textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    return textField
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
    
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fill
    
    return stackView
  }()
  
  init(index: Int, setInformation: SetConfiguration) {
    super.init(frame: .zero)
    
    self.setIndex = index
    weightTextField.delegate = self
    countTextField.delegate = self
    
    configureWeightStackView()
    configureCountStackView()
    configureSetStackView(with: setInformation)
    setUpLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    delegate?.setSumUpdated(from: setSum, to: 0)
  }
  
  private func configureWeightStackView() {
    weightStackView.addArrangedSubview(weightTextField)
    weightStackView.addArrangedSubview(weightUnitLabel)
    
    NSLayoutConstraint.activate([
      weightTextField.widthAnchor.constraint(equalTo: weightUnitLabel.widthAnchor, multiplier: 2.0)
      ])
  }
  
  private func configureCountStackView() {
    countStackView.addArrangedSubview(countTextField)
    countStackView.addArrangedSubview(countUnitLabel)
    
    NSLayoutConstraint.activate([
      countTextField.widthAnchor.constraint(equalTo: countUnitLabel.widthAnchor, multiplier: 1.5)
    ])
  }
  
  private func configureSetStackView(with setInformation: SetConfiguration) {
    setStackView.addArrangedSubview(setIndexLabel)
    setIndexLabel.text = "Set \(self.setIndex + 1)  "
    setStackView.addArrangedSubview(weightStackView)
    setStackView.addArrangedSubview(countStackView)
    self.addSubview(setStackView)
    
    weightTextField.text = "\(setInformation.displayWeight)"
    countTextField.text = "\(setInformation.displayCount)"
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      setStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      setStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      setStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      setStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      
      weightStackView.widthAnchor.constraint(equalTo: setStackView.widthAnchor, multiplier: 0.35),
      countStackView.widthAnchor.constraint(equalTo: weightStackView.widthAnchor),
      
    ])
  }
  
  private func updateSetSum(sender: UITextField) {
    switch sender {
    case self.countTextField:
      guard let text = sender.text,
            let countValue = UInt(text) else {
              countValue = 0
              return
            }
      
      self.countValue = countValue
    case self.weightTextField:
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
  
  func resetWeightAndCountValues() {
    self.weightValue = 0
    self.countValue = 0
  }
  
  func showDoingStatusView() {
    weightTextField.isUserInteractionEnabled = true
    weightTextField.backgroundColor = 0xBEC0C2.convertToRGB()
    weightTextField.textColor = .black
    
    countTextField.isUserInteractionEnabled = true
    countTextField.backgroundColor = 0xBEC0C2.convertToRGB()
    countTextField.textColor = .black
  }
  
  func showDoneStatusView() {
    weightTextField.isUserInteractionEnabled = false
    weightTextField.backgroundColor = .clear
    weightTextField.textColor = 0x096DB6.convertToRGB()
    
    countTextField.isUserInteractionEnabled = false
    countTextField.backgroundColor = .clear
    countTextField.textColor = 0x096DB6.convertToRGB()
  }
  
  func allFieldsAreWritten() -> Bool {
    return weightTextField.hasText && countTextField.hasText
  }
  
  @objc private func textFieldValueChanged(sender: UITextField) {
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

class UITextFieldWithPadding: UITextField {
  var textPadding = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.editingRect(forBounds: bounds)
    return rect.inset(by: textPadding)
  }
}
