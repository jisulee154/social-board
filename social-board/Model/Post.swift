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
    var writer: User?
    var comment: Comment?
    
    init(title: String, contents: String, contentImage: String? = nil, createdDateTime: Date? = nil, likeCount: Int? = nil, commentCount: Int? = nil, user: User? = nil, comment: Comment? = nil) {
        self.title = title
        self.contents = contents
        self.contentImage = contentImage
        self.createdDateTime = createdDateTime
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.writer = user
        self.comment = comment
    }
}

class User {
    var userID: UUID
    var userName: String?
    var userProfilePicture: String?
    var userJob: Job?
    
    init(userID: UUID, userName: String? = nil, userProfilePicture: String? = nil, userJob: Job? = nil) {
        self.userID = userID
        self.userName = userName
        self.userProfilePicture = userProfilePicture
        self.userJob = userJob
    }
}

class Comment {
    var postID: UUID
    var commentID: UUID?
    var writerID: String?
    
    init(postID: UUID, commentID: UUID? = nil, writerID: String? = nil) {
        self.postID = postID
        self.commentID = commentID
        self.writerID = writerID
    }
}

enum Job: String {
    case dev = "개발"
    case design = "디자인"
    case planner = "기획/전략"
    case marcketing = "마케팅"
}
