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

class CommentViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var POSTIMAGEVIEW: UIImageView!
    @IBOutlet weak var LIKELABEL: UILabel!
    @IBOutlet weak var DATELABEL: UILabel!
    @IBOutlet weak var CAPTIONLABEL: UILabel!
    @IBOutlet weak var LIKEBUTTON: UIButton!
    @IBOutlet weak var CtextField: UITextField!
    @IBOutlet weak var CtextView: UITextView!
    @IBAction func CtextField(_ sender: Any) {
        CtextField.text = (sender as AnyObject).text
    }
    
    var postDataReceived: PostData?

    func setPostData(_ postData: PostData) {
        postDataReceived = postData
    }
    
    @IBAction func CButton(_ sender: Any) {
        guard let postData = postDataReceived else {
            return
        }
        
        let Cname = Auth.auth().currentUser?.displayName
    
        if let CommentText = self.CtextField.text{
            postData.Comment.append("@\(Cname!)-\(CommentText)\n")
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
        }
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        let commentDictionary = ["Comment": postData.Comment]
        postRef.updateData(commentDictionary)
        
        var allcomment = ""
        for comment in postData.Comment{
            allcomment += comment
            self.CtextView.text = allcomment
            print("DEBUG_PRINT: comment")
        }
        CtextField.text = ""
        self.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        // ログイン済みか確認
        guard let postData = postDataReceived else {
            return
        }
        CAPTIONLABEL.text = "\(postData.name!) : \(postData.caption!)"
        
       DATELABEL.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            DATELABEL.text = dateString
        }
        
        POSTIMAGEVIEW.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        POSTIMAGEVIEW.sd_setImage(with: imageRef)

        let likeNumber = postData.likes.count
        LIKELABEL.text = "\(likeNumber)"
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            LIKEBUTTON.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            LIKEBUTTON.setImage(buttonImage, for: .normal)
        }
        
        CtextField.becomeFirstResponder()
        
        //allCommentは最初は空である
        var allComment = ""
        //postData.commentsの中から要素をひとつずつ取り出すのを繰り返す、というのがcomment
        for comment in postData.Comment{
            //comment + comment = allCommentである
            allComment += comment
            //commentLabelに表示するのはallComment（commentを足していったもの）である
            self.CtextView.text = allComment
        }
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.CtextField.delegate = self
        CtextField.returnKeyType = .done
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
