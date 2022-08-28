//
//  AddReminderViewController.swift
//  ReminderApp
//
//  Created by Ahmed Fayeq on 28/08/2022.
//

import UIKit

class AddReminderViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!

    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapSave() {
        if let titleText = titleTextField.text, !titleText.isEmpty,
           let bodyText  = bodyTextField.text, !bodyText.isEmpty {
            let targetDate = datePicker.date
        }
    }
    

}
