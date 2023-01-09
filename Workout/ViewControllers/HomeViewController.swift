//
//  ViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit
import FirebaseAuth
import AVFoundation

class HomeViewController: UIViewController {
  private var handle: AuthStateDidChangeListenerHandle?
  private var selectedDayInformation: DateInformation? = DateInformation(date: Date()) {
    didSet {
      if selectedDayInformation == nil {
        addRoutineButton.configureDisableMode(title: "등록 날짜를 먼저 선택해주세요")
      } else {
        addRoutineButton.configureAbleMode(title: "운동을 추가할래요")
        self.navigationController?.navigationBar.topItem?.title = selectedDayInformation?.fullDate
      }
      
      DispatchQueue.main.async {
        self.routineTableView.reloadData()
      }
    }
  }
  
  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  private let calendarView = CalendarView(frame: .zero)
  private let routineTableView = RoutineTableView()
  private var editableField: UITextField?
  private var calendarViewBottomConstraint: NSLayoutConstraint!
  private lazy var addRoutineButton: UIButton = {
    let button = UIButton(type: .custom, primaryAction: UIAction { _ in self.tappedAddRoutineButton() })
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.configureAbleMode(title: "운동을 추가할래요")
    button.applyCornerRadius(24)
    
    return button
  }()
  private lazy var openCalendarButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "달력펼치기", primaryAction: UIAction { _ in self.openCalendar() })
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(contentScrollView)
    
    contentScrollView.addSubview(calendarView)
    contentScrollView.addSubview(addRoutineButton)
    contentScrollView.addSubview(routineTableView)
    
    calendarView.delegate = self
    routineTableView.delegate = self
    routineTableView.dataSource = self
    routineTableView.dragInteractionEnabled = true
    routineTableView.dragDelegate = self
    routineTableView.dropDelegate = self
    
    configureNotification()
    configureGestureRecognizer()
    configureNavigationController()
    configureAuthListener()
    setUpLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    calendarView.reloadUserData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    Auth.auth().removeStateDidChangeListener(handle!)
  }
  
  private func configureNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(trackTappedTextField), name: NSNotification.Name("TappedTextField"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.checkRoutineData(_:)), name: Notification.Name("ReadRoutineData"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.updateCalendar(_:)), name: Notification.Name("ReadWorkoutData"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name("CheckKeyboard"), object: nil)
  }
  
  private func configureGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.isEnabled = true
    contentScrollView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func configureNavigationController() {
    self.navigationController?.navigationBar.isHidden = true
    self.navigationController?.navigationBar.topItem?.rightBarButtonItem = openCalendarButton
  }
  
  private func configureAuthListener() {
    handle = Auth.auth().addStateDidChangeListener { auth, user in
      guard let user = user, let email = user.email else { return }
      
      AuthenticationManager.shared.setAccountInformation(email)
      
      if currentUser == nil {
        AuthenticationManager.signedUpUser = user.uid
      }
      
      workoutManager.readWorkoutData()
    }
  }
  
  private func updateTableView() {
    routineTableView.beginUpdates()
    routineTableView.endUpdates()
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      
      calendarView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: 10),
      calendarView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
      calendarView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
      calendarView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),
      
      addRoutineButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
      addRoutineButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
      addRoutineButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
      
      routineTableView.topAnchor.constraint(equalTo: addRoutineButton.bottomAnchor, constant: 10),
      routineTableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor),
      routineTableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor),
      routineTableView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor, constant: -50),
    ])
  }
  
  private func tappedAddRoutineButton() {
    hideKeyboard()
    
    let routineSelectionViewController = RoutineSelectionViewController()
    routineSelectionViewController.delegate = self
    routineSelectionViewController.modalPresentationStyle = .formSheet
    self.present(routineSelectionViewController, animated: true, completion: nil)
  }
  
  private func openCalendar() {
    calendarView.isHidden = false
    NSLayoutConstraint.deactivate([calendarViewBottomConstraint])
    
    if let navigationController = self.navigationController {
      navigationController.navigationBar.isHidden = true
    }
    
    UIView.animate(withDuration: 0.7) {
      self.view.layoutIfNeeded()
    }
  }
  
  private func shakeAddRoutineButton() {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    let dur = 0.1
    
    UIView.animateKeyframes(withDuration: dur*5, delay: 0, options: [],
                            animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0,
                         relativeDuration: dur) {
        self.addRoutineButton.transform = CGAffineTransform(rotationAngle: -.pi/64)
      }
      UIView.addKeyframe(withRelativeStartTime: dur,
                         relativeDuration: dur) {
        self.addRoutineButton.transform = CGAffineTransform(rotationAngle: +.pi/64)
      }
      UIView.addKeyframe(withRelativeStartTime: dur*2,
                         relativeDuration: dur) {
        self.addRoutineButton.transform = CGAffineTransform(rotationAngle: -.pi/64)
      }
      UIView.addKeyframe(withRelativeStartTime: dur*3,
                         relativeDuration: dur) {
        self.addRoutineButton.transform = CGAffineTransform(rotationAngle: +.pi/64)
      }
      UIView.addKeyframe(withRelativeStartTime: dur*4,
                         relativeDuration: dur) {
        self.addRoutineButton.transform = CGAffineTransform.identity
      }
    },
                            
    completion: nil
    )
  }
  
  private func foldCalendar() {
    guard selectedDayInformation != nil else {
      shakeAddRoutineButton()
      return
    }
    
    self.calendarView.isHidden = true
    calendarViewBottomConstraint = calendarView.bottomAnchor.constraint(equalTo: calendarView.topAnchor)
    NSLayoutConstraint.activate([calendarViewBottomConstraint])
    
    if let navigationController = self.navigationController {
      navigationController.navigationBar.isHidden = false
    }
    
    UIView.animate(withDuration: 0.7) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func trackTappedTextField(notification: Notification) {
    if let activatedField = notification.object as? UITextField {
      self.editableField = activatedField
      activatedField.selectAll(nil)
    }
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
      return
    }
    
    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
    contentScrollView.contentInset = contentInsets
    contentScrollView.verticalScrollIndicatorInsets = contentInsets
    
    if let activeField = editableField {
      let activeRect = activeField.convert(activeField.bounds, to: contentScrollView)
      contentScrollView.scrollRectToVisible(activeRect, animated: true)
    }
  }
  
  @objc  private func checkRoutineData(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo, let dateInformation = userInfo["date"] as? DateInformation else { return }
    
    if selectedDayInformation == dateInformation {
      if let error = notification.userInfo?["error"] as? Error {
        let alert = UIAlertController(title: "\(error)\n데이터 읽기에 실패했어요.\n잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
        return
      }
      
      DispatchQueue.main.async {
        self.routineTableView.reloadData()
      }
    }
  }
  
  @objc private func updateCalendar(_ notification: NSNotification) {
    if let userInfo = notification.userInfo,
       let error = userInfo["error"] as? Error {
      let alert = UIAlertController(title: "\(error)\n데이터 읽기에 실패했어요.\n잠시후 다시 시도해주세요.", message: nil, preferredStyle: .alert)
      let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: false, completion: nil)
      return
    } else {
      self.calendarView.reloadUserData()
    }
  }
  
  @objc private func hideKeyboard() {
    if let activatedField = editableField {
      activatedField.resignFirstResponder()
    }
  }
}
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let selectedDayInformation = self.selectedDayInformation else { return 0 }
    
    return routineManager.plan(of: selectedDayInformation).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutPlanCardTableViewCell.identifier, for: indexPath) as? WorkoutPlanCardTableViewCell,
          let selectedDayInformation = self.selectedDayInformation else {
      return UITableViewCell()
    }
    
    let workout = routineManager.plan(of: selectedDayInformation)[indexPath.row]
    cell.setUp(with: workout)
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    guard sourceIndexPath.row != destinationIndexPath.row else { return }
    guard let selectedDayInformation = self.selectedDayInformation else { return }
    
    routineManager.reorderPlan(on: selectedDayInformation, removeAt: sourceIndexPath.row, insertAt: destinationIndexPath.row)
  }
}
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      guard let selectedDayInformation = self.selectedDayInformation else { return }
      
      routineManager.removePlannedWorkout(at: indexPath.row, on: selectedDayInformation)
      calendarView.updateSelectedCell()
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
extension HomeViewController: UITableViewDragDelegate {
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    return [UIDragItem(itemProvider: NSItemProvider())]
  }
}
extension HomeViewController: UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
  }
  
  func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    if session.localDragSession != nil {
      return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
  }
}
extension HomeViewController: RoutineSelectionDelegate {
  func addSelectedWorkouts(_ selectedWorkouts: [Workout]) {
    guard let selectedDayInformation = self.selectedDayInformation else { return }
    
    let plannedWorkoutNumber = routineManager.plan(of: selectedDayInformation).count
    let newPlannedWorkouts = selectedWorkouts.enumerated().map({ (index, workout) in
      PlannedWorkout(workout, UInt(index + plannedWorkoutNumber), selectedDayInformation)
    })
    
    routineManager.addPlan(with: newPlannedWorkouts, on: selectedDayInformation)
    calendarView.updateSelectedCell()
    
    routineTableView.beginUpdates()
    for i in plannedWorkoutNumber..<routineManager.plan(of: selectedDayInformation).count {
      self.routineTableView.insertRows(at: [IndexPath(item: i, section: 0)], with: .right)
    }
    routineTableView.layoutIfNeeded()
    routineTableView.endUpdates()
    
    contentScrollView.scrollToBottom()
  }
}
extension HomeViewController: CalendarViewDelegate {
  func changedSelectedDay(to dateInformation: DateInformation?) {
    self.selectedDayInformation = dateInformation
  }
  
  func calendarIsFolded() {
    foldCalendar()
  }
}
extension HomeViewController: WorkoutPlanCardTableViewCellDelegate {
  func currentDateInformation() -> DateInformation? {
    return selectedDayInformation
  }
  
  func cellExpand() {
    updateTableView()
  }
  
  func cellShrink() {
    updateTableView()
  }
  
  func textFieldsAreNotFilled() {
    let alert = UIAlertController(title: "모든 세트의 수행 무게와 횟수를 입력해주세요 :)", message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .destructive, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: false, completion: nil)
  }
}
extension HomeViewController: TabBarMenu {
  var tabTitle: String {
    return "홈"
  }
  
  var icon: String {
    return "house.fill"
  }
}
