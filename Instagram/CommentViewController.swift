//
//  CommentViewController.swift
//  Instagram
//
//  Created by 中村航 on 2021/04/13.
//

import UIKit
import Firebase
import FirebaseUI
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var CommentArray: [CommentData] = []
    var listener: ListenerRegistration?
    
    @IBOutlet weak var POSTIMAGEVIEW: UIImageView!
    @IBOutlet weak var LIKELABEL: UILabel!
    @IBOutlet weak var DATELABEL: UILabel!
    @IBOutlet weak var CAPTIONLABEL: UILabel!
    @IBOutlet weak var LIKEBUTTON: UIButton!
    @IBOutlet weak var CtextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func CButton(_ sender: Any) {
        if CtextField.text != ""{
        let commentRef = Firestore.firestore().collection(Const.CommentPath).document()
        let Cname = Auth.auth().currentUser?.displayName
        let commentDic = [
            "Cname": Cname!,
            "Commet": self.CtextField.text!,
            "Cdate": FieldValue.serverTimestamp(),
            ] as [String : Any]
        commentRef.setData(commentDic)
        // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 投稿処理が完了したので先頭画面に戻る
            self.viewDidLoad()
            CtextField.text = ""
        }else if CtextField.text == ""{
            SVProgressHUD.showSuccess(withStatus: "コメントを入力してください")
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        if Auth.auth().currentUser != nil {
            // listenerを登録して投稿データの更新を監視する
            let commentsRef = Firestore.firestore().collection(Const.CommentPath).order(by: "date", descending: false)
            listener = commentsRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.CommentArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                    let comment = CommentData(document: document)
                    return comment
                }
                // TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CCell", for: indexPath) as! CommentTableViewCell
        cell.setCommentData(CommentArray[indexPath.row])
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
