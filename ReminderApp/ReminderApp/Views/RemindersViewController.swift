//
//  RemindersViewController.swift
//  ReminderApp
//
//  Created by Ahmed Fayeq on 28/08/2022.
//

import UIKit
import UserNotifications

class RemindersViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerNotifications()
        guard let data = UserDefaults.standard.data(forKey: "reminders"),
              let savedItems = try? JSONDecoder().decode([Reminder].self, from: data) else { return }
        
        reminders = savedItems
    }
    
    @IBAction func didTapAdd () {
        //show AddVC
        guard let addVC = storyboard?.instantiateViewController(withIdentifier: "add") as? AddReminderViewController else { return }
        addVC.title = "New Reminder"
        addVC.navigationItem.largeTitleDisplayMode = .never
        addVC.completion = { [weak self] title, body, date in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                let newReminder = Reminder(title: title, Identifier: body, date: date)
                self?.reminders.append(newReminder)
                self?.saveData()
                self?.tableView.reloadData()
                self?.scheduleNotification(title: title, body: body, date: date)
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @IBAction func registerNotifications() {
        // fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {_, error in
            if error != nil {
                print("error")
            }
        }
    }
    
    private func saveData() {
        if let encodedData = try? JSONEncoder().encode(self.reminders) {
            UserDefaults.standard.set(encodedData, forKey: "reminders")
        }
    }
    
    func scheduleTest() {
        scheduleNotification(title: "Test Alert", body: "this is the body of the alert")
    }
    
    private func scheduleNotification(title: String, body: String, date: Date = Date().addingTimeInterval(10)) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body
        
        let targetDate = date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_Id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("somthing went wrong")
            }
        }
    }
    
}


extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = reminders[indexPath.row].title
        let date = reminders[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        cell.detailTextLabel?.text = "\(reminders[indexPath.row].Identifier) -->  \(formatter.string(from: date))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            reminders.remove(at: indexPath.row)
            saveData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
