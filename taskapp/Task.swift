//
//  Task.swift
//  taskapp
//
//  Created by USER on 2021/06/29.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0

    // タイトル
    @objc dynamic var title = ""

    // 内容
    @objc dynamic var contents = ""

    // 日時
    @objc dynamic var date = Date()

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //【課題↓】Taskクラスにcategoryと言うstringプロパティを追加
    @objc dynamic var category: String = ""
    //【課題↓】Taskクラスにcategoryと言うstringプロパティを追加
}
