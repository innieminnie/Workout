//
//  PreviousRecordViewController.swift
//  pitapatpumping
//
//  Created by 강인희 on 2023/01/10.
//

import UIKit

class PreviousRecordViewController: UIViewController {
  weak var delegate: RoutineSelectionDelegate?
  
  private let previousRecordsTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    
    return tableView
  }()
  private var records = [Dictionary<DateInformation, [PlannedWorkout]>.Element]()
  private var selectedRecordDate = DateInformation(date: Date())
  private var selectedRecord = [PlannedWorkout]()
  private var dateInformation = DateInformation(date: Date())
  
  private lazy var addRoutineButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.tappedAddRoutineButton() })
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.configureDisableMode(title: "선택한 기록을 불러올래요")
    button.applyCornerRadius(24)
    
    return button
  }()
  
  private lazy  var noticeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    let notice = "이전 기록이 아직없네요 :)"
    label.text = notice
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = UIFont.Pretendard(type: .Bold, size: 20)
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    if self.records.count == 0 {
      view.addSubview(noticeLabel)
      setUpNoticeLabel()
    } else {
      view.addSubview(previousRecordsTableView)
      view.addSubview(addRoutineButton)
      setUpListTableView()
      setUpLayout()
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRoutineData(_:)), name: Notification.Name("ReadRoutineData"), object: nil)
  }
  
  func setUpDateInformation(with dateInformation: DateInformation?) {
    guard let dateInformation = dateInformation else {
      return
    }
    
    self.dateInformation = dateInformation
  }
  
  func setUpSelection(with records: [DateInformation : [PlannedWorkout]]) {
    self.records = records.sorted { $0.key >= $1.key }
  }
  
  private func setUpNoticeLabel() {
    NSLayoutConstraint.activate([
      noticeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      noticeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      noticeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      noticeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ])
  }
  
  private func tappedAddRoutineButton() {
    self.dismiss(animated: true) {
      self.delegate?.copyPlannedWorkouts(from: self.selectedRecordDate)
    }
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      previousRecordsTableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 20),
      previousRecordsTableView.leadingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      previousRecordsTableView.trailingAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      
      addRoutineButton.topAnchor.constraint(equalTo: previousRecordsTableView.bottomAnchor, constant: 10),
      addRoutineButton.leadingAnchor.constraint(equalTo:previousRecordsTableView.leadingAnchor),
      addRoutineButton.trailingAnchor.constraint(equalTo: previousRecordsTableView.trailingAnchor),
      addRoutineButton.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  @objc  private func checkRoutineData(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo, let dateInformation = userInfo["date"] as? DateInformation else { return }
    
    if selectedRecordDate == dateInformation {
      if let error = notification.userInfo?["error"] as? Error {
        let alert = UIAlertController(title: "\(error)\n데이터 읽기에 실패했어요.\n잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
        return
      }
      
      
    }
  }
}
extension PreviousRecordViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    self.records.count <= 10 ? self.records.count : 10
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell else {
      return UITableViewCell()
    }
    
    let recordDate = self.records[indexPath.section].key
    let workoutData = routineManager.plan(of: recordDate)
    cell.setUp(with: workoutData)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "\(self.records[section].key.fullDate)요일의 기록"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.tintColor = 0xF58423.convertToRGB()
    headerView.textLabel?.textColor = .white
    headerView.textLabel?.font = UIFont.Pretendard(type: .Bold, size: 15)
  }
}
extension PreviousRecordViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedRecordDate = self.records[indexPath.section].key
    
    guard addRoutineButton.isEnabled else {
      addRoutineButton.isEnabled = true
      addRoutineButton.backgroundColor = 0x096DB6.convertToRGB()
      return
    }
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard tableView.indexPathsForSelectedRows != nil else {
      addRoutineButton.isEnabled = false
      return
    }
  }
}
extension PreviousRecordViewController {
  private func setUpListTableView() {
    previousRecordsTableView.dataSource = self
    previousRecordsTableView.delegate = self
    
    let nib = UINib(nibName: "RecordTableViewCell", bundle: nil)
    self.previousRecordsTableView.register(nib, forCellReuseIdentifier: RecordTableViewCell.identifier)
  }
}
