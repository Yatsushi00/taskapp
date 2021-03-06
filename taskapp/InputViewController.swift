//
//  InputViewController.swift
//  taskapp
//
//  Created by USER on 2021/06/29.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    //【課題】
    @IBOutlet weak var categoryTextField: UITextField!
    //【課題】
    
    let realm = try! Realm()
    var task: Task!
    
    //【↓】タスク作成/編集画面にやってきた時に、タスクの情報を反映させて表示するーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        //【課題】
        categoryTextField.text = task.category
        //【課題】
    }
    //【↑】タスク作成/編集画面にやってきた時に、タスクの情報を反映させて表示するーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    //【↓】タスク作成/編集画面を離れる際に情報を保存するーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            //【課題】
            self.task.category = self.categoryTextField.text!
            //【課題】
            self.realm.add(self.task, update: .modified)
        }

        setNotification(task: task) //ローカル通知用
        super.viewWillDisappear(animated)
    }
    //【↑ß∫】タスク作成/編集画面を離れる際に情報を保存するーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    
    
    //【↓】ローカル通知を設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    //UNMtableNotificationContentクラスのインスタンスを使って通知内容を設定
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier,content,tiriggerからローカル通知を作成(identifierが同じだとローカル通知を上書き保存)
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK") // errorがnilならローカル通知に成功したと表示します。errorが存在すればerrorを表示します。
        
        //未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests {(requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/--------")
                    print(request)
                    print("/--------")
                }
            }
        }
    }
    //【↑】ローカル通知を設定ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
