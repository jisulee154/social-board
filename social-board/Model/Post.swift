//
//  Post.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var userID: ObjectId
    @Persisted var userName: String?
    @Persisted var userProfilePicture: String?
    
    @Persisted var job: Job? //외래키
    
    @Persisted var posts: List<Post> //외래키
    
    @Persisted var comments: List<Comment> //외래키
    
    @Persisted var topics: List<Topic> //외래키
    
    convenience init(userID: ObjectId, userName: String, userProfilePicture: String, job: Job? = nil) {
        self.init()
        
        self.userID = userID
        self.userName = userName
        self.userProfilePicture = userProfilePicture
        self.job = job
    }
}


class Post: Object {
    @Persisted(primaryKey: true) var postID: ObjectId
//    @Persisted var title: String
    @Persisted var contents: String
    @Persisted var contentImage: String?
    @Persisted var createdDateTime: Date?
    @Persisted var likeCount: Int?
    @Persisted var commentCount: Int? // computed property로 전환?
    
    @Persisted var writer: User? //외래키
    @Persisted var comments: List<Comment> //외래키
    
    @Persisted var expanded: Bool? //긴글의 경우, 모든 내용을 다 보여줄 것인지 결정합니다.
    @Persisted var isLiked: Bool? //좋아요 버튼 상태 //true:좋아요 누른 상태 false:누르지 않은 상태
    
//    @Persisted(originProperty: "posts") var writer: LinkingObjects<User> //외래키
    
    convenience init(postID: ObjectId = ObjectId.generate(), title: String = "", contents: String, contentImage: String? = nil, createdDateTime: Date = Date(), likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, expanded: Bool? = false, isLiked: Bool? = nil) {
        self.init()
        
        self.postID = postID
        self.contents = contents
        self.contentImage = contentImage
        self.createdDateTime = createdDateTime
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.writer = writer
        self.expanded = expanded
        self.isLiked = isLiked
    }
}
    

class Comment: Object {
    @Persisted(primaryKey: true) var commentID: ObjectId
    @Persisted var createdDateTime: Date?
    @Persisted var contents: String?
    
//    @Persisted(originProperty: "comments") var writtenBy: LinkingObjects<User> //외래키
//    @Persisted(originProperty: "comments") var belongsTo: LinkingObjects<Post> //외래키
    @Persisted var writtenBy: User? //외래키
    @Persisted var belongsTo: Post?//외래키
    
    convenience init(commentID: ObjectId = ObjectId.generate(), createdDateTime: Date? = nil, contents: String? = nil, writtenBy: User? = nil, belongsTo: Post? = nil) {
        self.init()
        
        self.commentID = commentID
        self.createdDateTime = createdDateTime
        self.contents = contents
        self.writtenBy = writtenBy
        self.belongsTo = belongsTo
    }
}

class Job: Object {
    @Persisted(primaryKey: true) var jobID: ObjectId
    @Persisted var category: JobCategory?
    @Persisted var workYear: Int?
    
//    @Persisted(originProperty: "job") var worker: LinkingObjects<User> //외래키 //필요한가?
    
    convenience init(jobID: ObjectId = ObjectId.generate(), category: JobCategory, workYear: Int) {
        self.init()
        
        self.jobID = jobID
        self.category = category
        self.workYear = workYear
//        self.worker = worker
    }
}

class Topic: Object {
    @Persisted(primaryKey: true) var topicID: ObjectId
    @Persisted var categories: List<TopicCategory>
    
//    @Persisted(originProperty: "topics") var postIDs: LinkingObjects<User> //외래키 //필요한가?
    
    convenience init(topicID: ObjectId, categories: List<TopicCategory> = List<TopicCategory>()) {
        self.init()
        
        self.topicID = topicID
        self.categories = categories
//        self.postIDs = postIDs
    }
}

enum JobCategory: String, PersistableEnum {
    case dev = "개발"
    case design = "디자인"
    case marcketing = "마케팅・광고"
    case hr = "HR"
    case media = "미디어"
    case business = "비즈니스"
    case service = "고객서비스・리테일"
}

enum TopicCategory: String, PersistableEnum {
    case worries = "커리어고민"
    case jobSearching = "취업/이직"
    case companySocial = "회사생활"
    case social = "인간관계"
    case dev = "개발"
    case it = "IT/기술"
}
