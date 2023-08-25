//
//  Post.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import Foundation

class Post {
    var title: String
    var contents: String
    var contentImage: String?
    var createdDateTime: Date?
    var likeCount: Int?
    var commentCount: Int?
    var writerID: String?
    
    init(title: String, contents: String, contentImage: String? = nil, createdDateTime: Date? = nil, likeCount: Int? = nil, commentCount: Int? = nil, writerID: String? = nil) {
        self.title = title
        self.contents = contents
        self.contentImage = contentImage
        self.createdDateTime = createdDateTime
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.writerID = writerID
    }
}
