//
//  WorkoutSetConfigurationView.swift
//  Workout
//
//  Created by 강인희 on 2022/05/19.
//

import UIKit

protocol WorkoutSetConfigurationViewDelegate: AnyObject {
  func setSumUpdated(from oldValue: Int, to newValue: Int)
  func weightValueUpdated(to newValue: Int, of index: Int)
  func countValueUpdated(to newValue: Int, of index: Int)
}

class WorkoutSetConfigurationView: UIView {
  private lazy var setIndex: Int = 0
  
  private var setSum: Int = 0 {
    didSet {
      delegate?.setSumUpdated(from: oldValue, to: setSum)
    }
  }
  
  private var weightValue: Int = 0 {
    didSet {
      delegate?.weightValueUpdated(to: weightValue, of: self.setIndex)
      
      setSum -= oldValue * countValue
      setSum += weightValue * countValue
    }
  }
  
  private var countValue: Int = 0 {
    didSet {
      delegate?.countValueUpdated(to: countValue, of: self.setIndex)
      
      setSum -= oldValue * weightValue
      setSum += weightValue * countValue
    }
  }
  
  weak var delegate: WorkoutSetConfigurationViewDelegate?
  
  private let setIndexLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false

    label.textColor = .black
    return label
  }()
  
  private let weightTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .systemBlue
    textField.layer.cornerRadius = 5
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    
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
  
  private let countTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    textField.backgroundColor = .systemBlue
    textField.layer.cornerRadius = 5
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    
    textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
    return textField
  }()
  
  private let countUnitLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "회"
    label.textColor = .black
    
    return label
  }()
  
  private let multiplierLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.text = "X"
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
    stackView.distribution = .equalSpacing
    
    return stackView
  }()
  
  init(index: Int, setInformation: SetConfiguration) {
    super.init(frame: .zero)
    
    self.setIndex = index
    weightTextField.delegate = self
    countTextField.delegate = self
    
    configureWeightStackView(with: setInformation.weight)
    configureCountStackView(with: setInformation.count)
    configureSetStackView()
    setUpLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    delegate?.setSumUpdated(from: setSum, to: 0)
  }
  
  private func configureWeightStackView(with weight: Int) {
    weightStackView.addArrangedSubview(weightTextField)
    weightTextField.text = "\(weight)"
    weightStackView.addArrangedSubview(weightUnitLabel)
  }
  
  private func configureCountStackView(with count: Int) {
    countStackView.addArrangedSubview(countTextField)
    countTextField.text = "\(count)"
    countStackView.addArrangedSubview(countUnitLabel)
  }
  
  private func configureSetStackView() {
    setStackView.addArrangedSubview(setIndexLabel)
    setIndexLabel.text = "Set \(self.setIndex)"
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
  
  private func updateSetSum(sender: UITextField) {
    switch sender {
    case self.countTextField:
      guard let text = sender.text,
            let countValue = Int(text) else {
              countValue = 0
              return
            }
      
      self.countValue = countValue
    case self.weightTextField:
      guard let text = sender.text,
            let weightValue = Int(text) else {
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
    weightTextField.backgroundColor = .systemBlue
    weightTextField.textColor = .black
    
    countTextField.isUserInteractionEnabled = true
    countTextField.backgroundColor = .systemBlue
    countTextField.textColor = .black
  }
  
  func showDoneStatusView() {
    weightTextField.isUserInteractionEnabled = false
    weightTextField.backgroundColor = .clear
    weightTextField.textColor = .gray
    
    countTextField.isUserInteractionEnabled = false
    countTextField.backgroundColor = .clear
    countTextField.textColor = .gray
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
