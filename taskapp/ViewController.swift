//
//  ViewController.swift
//  taskapp
//
//  Created by USER on 2021/06/29.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    //【課題】
    @IBOutlet weak var searchBar: UISearchBar!
    //【課題】    
    
    //【↓】データベースの準備
    //Realmインスタンス作成
    let realm = try! Realm()
    //データベース内のタスクが格納されるリスト＝こっちもRealmのインスタンスを作成してると思う
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    //【終了】データベースの準備
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //【開始】デリゲート
        tableView.delegate = self
        tableView.dataSource = self
        
        //【↓課題】
        //デリゲート先を自分に設定する。
        searchBar.delegate = self
        //【↑課題】

        //【終了】デリゲート
        
        //【↓課題】
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        //【↑課題】
    }
    //【↑】データベースの準備
    
    //【↓課題】UISearchBarの検索が押された時の処理を書く。Realmのフィルターメソッドでフィルター条件を宣言した定数predicateを作成し、タスク一覧であるtaskArrayに入れ直す。最後にtableViewをリロードする。
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        //検索結果配列を空にする。←多分、検索を一度かけた状態からもう一度検索した時に、前のフィルタリングを全部消してから始めるためだと思う。
        //必要ないとのことでコメントアウトtaskArray.removeAll()
        //サイトのコードを書いてるだけ。searchResult.removeAll()
        
        //エラーになるのでコメントアウトしていた場所
        let predicate = NSPredicate(format: "category CONTAINS %@", searchBar.text!)
        taskArray = realm.objects(Task.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
        
        //テーブルを再読み込みする。
        tableView.reloadData()
    }
    //【↑課題】
    
    //セルの数を返すメソッド
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //【開始】各セルに中身を入れて、最後にreturn cellでセルを返す
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //再利用可能なcellを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //【開始】cellに値を設定する
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        //【終了】cellに値を設定する
        
        return cell
        }
    
    //【開始】各セルに中身を入れて、最後にreturn cellでセルを返す
    
    //【開始】セルが選択された時に実行されるメソッドに、Identifier指定でセグエを指定して遷移するコードを書き込む
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    //【終了】セルが選択された時に実行されるメソッドに、Identifier指定でセグエを指定して遷移するコードを書き込む
    
    //【↓】セルが削除可能だと伝える
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    //【↑】セルが削除可能だと伝える
    
    //【↓】Deleteが押された時に呼ばれるメソッドに、データベースからのデータ削除を書き込む
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //【変更開始↓】ローカル通知用：タスクを削除するときに通知をキャンセルする
    if editingStyle == .delete {
        
        //ローカル通知用：削除するタスクを取得する
        let task = self.taskArray[indexPath.row]
        //ローカル通知用：ローカル通知をキャンセルする
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
        
        //データベースから削除する
        try! realm.write {
            self.realm.delete(self.taskArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        //ローカル通知用：未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests {
            (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/-------")
                print(request)
                print("/-------")
            }
        }
    }
    //【変更終了↑】ローカル通知用：タスクを削除するときに通知をキャンセルする
   }
    //【↑】Deleteが押された時に呼ばれるメソッドに、データベースからのデータ削除を書き込む
    
    
    
    //【↓】画面遷移時にデータを渡すーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()

            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }

            inputViewController.task = task
        }
    }
    //【↑】画面遷移時にデータを渡すーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    
    //【↓】入力画面から戻ってきた時に TableView を更新させるーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //【↑】入力画面から戻ってきた時に TableView を更新させるーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

}

