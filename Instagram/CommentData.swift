//
//  CommentData.swift
//  Instagram
//
//  Created by 中村航 on 2021/04/13.
//

import UIKit
import Firebase

class CommentData: NSObject {
    
    var id: String
    var Cname: String?
    var Comment: String?
    var Cdate: Date?
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let commentDic = document.data()
        
        self.Cname = commentDic["Cname"] as? String

        self.Comment = commentDic["Comment"] as? String
        
        let Ctimestamp = commentDic["Cdate"] as? Timestamp
        self.Cdate = Ctimestamp?.dateValue()
    }
}
