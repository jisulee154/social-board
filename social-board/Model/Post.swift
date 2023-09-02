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
    @Persisted var title: String
    @Persisted var contents: String
    @Persisted var contentImage: String?
    @Persisted var createdDateTime: Date?
    @Persisted var likeCount: Int?
    @Persisted var commentCount: Int? // computed property로 전환?
    
    @Persisted var writer: User? //외래키
    @Persisted var comments: List<Comment> //외래키
    
    @Persisted var expanded: Bool? //긴글의 경우, 모든 내용을 다 보여줄 것인지 결정합니다.
    
//    @Persisted(originProperty: "posts") var writer: LinkingObjects<User> //외래키
    
    convenience init(postID: ObjectId = ObjectId.generate(), title: String = "", contents: String, contentImage: String? = nil, createdDateTime: Date = Date(), likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, expanded: Bool? = false) {
        self.init()
        
        self.postID = postID
        self.title = title
        self.contents = contents
        self.contentImage = contentImage
        self.createdDateTime = createdDateTime
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.writer = writer
        self.expanded = expanded
//        self.comments = comments
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
    
    convenience init(commentID: ObjectId, createdDateTime: Date? = nil, contents: String? = nil, writtenBy: User? = nil, belongsTo: Post? = nil) {
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
    
    convenience init(jobID: ObjectId, category: JobCategory, workYear: Int) {
        self.init()
        
        self.jobID = jobID
        self.category = category
        self.workYear = workYear
//        self.worker = worker
    }
}

class Topic: Object {
    @Persisted(primaryKey: true) var topicID: ObjectId
    @Persisted var category: TopicCategory?
    
//    @Persisted(originProperty: "topics") var postIDs: LinkingObjects<User> //외래키 //필요한가?
    
    convenience init(topicID: ObjectId, category: TopicCategory? = nil) {
        self.init()
        
        self.topicID = topicID
        self.category = category
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

//class Post {
//    var postID: UUID
//    var title: String
//    var contents: String
//    var contentImage: String?
//    var createdDateTime: Date?
//    var likeCount: Int?
//    var commentCount: Int {
//        get {
//            return comments?.count ?? 0
//        }
//    }
//    var writerID: UUID? //외래키
//    var comments: [Comment]? //외래키
//
//    init(postID: UUID, title: String, contents: String, contentImage: String? = nil, createdDateTime: Date? = nil, likeCount: Int? = nil,  writerID: UUID? = nil, comments: [Comment]? = nil) {
//        self.postID = postID
//        self.title = title
//        self.contents = contents
//        self.contentImage = contentImage
//        self.createdDateTime = createdDateTime
//        self.likeCount = likeCount
//        self.writerID = writerID
//        self.comments = comments
//    }
//}
//
//class User {
//    var userID: UUID
//    var userName: String?
//    var userProfilePicture: String?
//    var userJobID: UUID? //외래키
//    var postIDs: [UUID]? //외래키
//    var commentIDs: [UUID]? //외래키
//    var topicIDs: [UUID]? //외래키
//
//    init(userID: UUID, userName: String? = nil, userProfilePicture: String? = nil, userJobID: UUID? = nil, postIDs: [UUID]? = nil, commentIDs: [UUID]? = nil, topicIDs: [UUID]? = nil) {
//        self.userID = userID
//        self.userName = userName
//        self.userProfilePicture = userProfilePicture
//        self.userJobID = userJobID
//        self.postIDs = postIDs
//        self.commentIDs = commentIDs
//        self.topicIDs = topicIDs
//    }
//}
//
//class Comment {
//    var commentID: UUID
//    var postID: UUID? //외래키
//    var writerID: UUID? //외래키
//    var createdDateTime: Date?
//    var contents: String?
//
//    init(commentID: UUID, postID: UUID? = nil, writerID: UUID? = nil, createdDateTime: Date? = nil, contents: String? = nil) {
//        self.commentID = commentID
//        self.postID = postID
//        self.writerID = writerID
//        self.createdDateTime = createdDateTime
//        self.contents = contents
//    }
//}
//
//class Job {
//    var jobID: UUID
//    var userID: UUID? //외래키
//    var category: JobCategory?
//    var workYear: Int?
//
//    init(jobID: UUID, userID: UUID? = nil, category: JobCategory? = nil, workYear: Int? = nil) {
//        self.jobID = jobID
//        self.userID = userID
//        self.category = category
//        self.workYear = workYear
//    }
//}
//
//class Topic {
//    var topicID: UUID
//    var category: TopicCategory?
//    var postIDs: [UUID]? //외래키
//
//    init(topicID: UUID, category: TopicCategory? = nil, postIDs: [UUID]? = nil) {
//        self.topicID = topicID
//        self.category = category
//        self.postIDs = postIDs
//    }
//}
//
//enum JobCategory: String {
//    case dev = "개발"
//    case design = "디자인"
//    case marcketing = "마케팅・광고"
//    case hr = "HR"
//    case media = "미디어"
//    case business = "비즈니스"
//    case service = "고객서비스・리테일"
//}
//
//enum TopicCategory: String {
//    case worries = "커리어고민"
//    case jobSearching = "취업/이직"
//    case companySocial = "회사생활"
//    case social = "인간관계"
//    case dev = "개발"
//    case it = "IT/기술"
//}
