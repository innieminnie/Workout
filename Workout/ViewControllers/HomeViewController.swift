//
//  ViewController.swift
//  Workout
//
//  Created by 강인희 on 2021/11/23.
//

import UIKit

class HomeViewController: UIViewController {
  var workouts = [Workout]()
  
  private let contentScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  
  private let calendarView = CalendarView(frame: .zero)
  
  private let addRoutineButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    
    button.setTitle("루틴 추가하기", for: .normal)
    button.layer.cornerRadius = 13
    button.backgroundColor = .purple
    button.addTarget(self, action: #selector(tappedAddRoutineButton(sender:)), for: .touchUpInside)
    
    return button
  }()
  
  private let routineTableView = RoutineTableView()
  
  private weak var editableField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(contentScrollView)
    
    contentScrollView.addSubview(calendarView)
    calendarView.delegate = self
    
    contentScrollView.addSubview(addRoutineButton)
    
    contentScrollView.addSubview(routineTableView)
    routineTableView.delegate = self
    routineTableView.dataSource = self
    routineTableView.dragInteractionEnabled = true
    routineTableView.dragDelegate = self
    routineTableView.dropDelegate = self
    
    configureNotification()
    configureGestureRecognizer()
    setUpLayout()
  }
  
  @objc private func tappedAddRoutineButton(sender: UIButton) {
    let routineSelectionViewController = RoutineSelectionViewController()
    routineSelectionViewController.delegate = self
    routineSelectionViewController.modalPresentationStyle = .formSheet
    self.present(routineSelectionViewController, animated: true, completion: nil)
  }
  
  @objc private func trackTappedTextField(notification: Notification) {
    if let activatedField = notification.object as? UITextField {
      self.editableField = activatedField
    }
  }
  
  @objc private func hideKeyboard() {
    if let activatedField = editableField {
      activatedField.resignFirstResponder()
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
  
  private func configureNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(trackTappedTextField), name: NSNotification.Name("TappedTextField"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
  }
  
  private func configureGestureRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.isEnabled = true
    contentScrollView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setUpLayout() {
    NSLayoutConstraint.activate([
      contentScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      contentScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      contentScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      contentScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      
      calendarView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor, constant: 30),
      calendarView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
      calendarView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
      calendarView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),
      
      addRoutineButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
      addRoutineButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
      addRoutineButton.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
      
      routineTableView.topAnchor.constraint(equalTo: addRoutineButton.bottomAnchor, constant: 10),
      routineTableView.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor, constant: 10),
      routineTableView.trailingAnchor.constraint(equalTo: calendarView.trailingAnchor, constant: -10),
      routineTableView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
    ])
  }
  
  private func updateTableView() {
    routineTableView.beginUpdates()
    routineTableView.endUpdates()
  }
}
extension HomeViewController: RoutineSelectionDelegate {
  func addSelectedWorkouts(_ selectedWorkouts: [Workout]) {
    self.workouts += selectedWorkouts
    routineTableView.reloadData()
    routineTableView.layoutIfNeeded()
  }
}
extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutPlanCardTableViewCell.identifier, for: indexPath) as? WorkoutPlanCardTableViewCell else {
      return UITableViewCell()
    }
    
    let workout = workouts[indexPath.row]
    cell.setUp(with: workout)
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    guard sourceIndexPath.row != destinationIndexPath.row else { return }
    
    let workout = workouts[sourceIndexPath.row]
    workouts.remove(at: sourceIndexPath.row)
    workouts.insert(workout, at: destinationIndexPath.row)
  }
}
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      workouts.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
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
extension HomeViewController: WorkoutPlanCardTableViewCellDelegate {
  func cellExpand() {
    updateTableView()
  }
  
  func cellShrink() {
    updateTableView()
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
extension HomeViewController: CalendarViewDelegate {
  func changedSelectedDay(to dateInformation: DateInformation) {
  }
}
