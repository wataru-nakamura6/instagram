//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 中村航 on 2021/04/12.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var CommentButton: UIButton!
    @IBOutlet weak var CtextView: UITextView!
    //@IBAction func CommentButton(_ sender: Any) {
    //    print("DEBUG_PRINT: likeボタンがタップされました。")
        
    //    let Comment = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
    //    self.present(Comment, animated: true, completion: nil)
    //}
    
    func CtextView(_ CtextView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = CtextView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるため。
        return linesAfterChange <= 3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        CtextView.textContainer.maximumNumberOfLines = 3
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)

        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"

        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        //allCommentは最初は空である
        var allComment = ""
        CtextView.text = ""
        //postData.commentsの中から要素をひとつずつ取り出すのを繰り返す、というのがcomment
        for comment in postData.Comment{
            //comment + comment = allCommentである
            allComment += comment
            //commentLabelに表示するのはallComment（commentを足していったもの）である
            self.CtextView.text = allComment
        }

        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //コメントの数
        let commentNumber = postData.Comment.count
        commentLabel.text = "\(commentNumber)"

        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
