//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 中村航 on 2021/04/13.
//

import UIKit
import FirebaseUI

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CommentName: UILabel!
    @IBOutlet weak var CommentCaption: UILabel!
    @IBOutlet weak var CommentDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCommentData(_ commentData: CommentData) {
        self.CommentCaption.text = commentData.Comment!
        
        self.CommentName.text = commentData.Cname!
        
        CommentDate.text = ""
        if let date = commentData.Cdate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.CommentDate.text = dateString
        }
    }
}
