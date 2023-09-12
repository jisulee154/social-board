//
//  PostViewModel.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import RxSwift
import RealmSwift
import Foundation
import Realm

class PostViewModel {
    static let shared = PostViewModel()
    var posts = PublishSubject<[Post]>()
    var post = PublishSubject<Post>()
    
    var comments = PublishSubject<[Comment]>()
    
    let disposeBag = DisposeBag()
    
    var dummyjobs: [Job] = []
    var dummyUsers: [User] = []
    var dummyTopics: [Topic] = []
    
    private init() {
        //MARK: - 더미 데이터
        dummyjobs = [
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 1),
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 8),
            Job(jobID: ObjectId.generate(), category: JobCategory.design, workYear: 3),
            Job(jobID: ObjectId.generate(), category: JobCategory.business, workYear: 11),
            Job(jobID: ObjectId.generate(), category: JobCategory.hr, workYear: 7),
            Job(jobID: ObjectId.generate(), category: JobCategory.marcketing, workYear: 2)
        ]
        
        dummyUsers = [
            User(userID: ObjectId.generate(), userName: "초상화", userProfilePicture: "userProfile1", job: dummyjobs[0]),
            User(userID: ObjectId.generate(), userName: "불도그", userProfilePicture: "userProfile2", job: dummyjobs[1]),
            User(userID: ObjectId.generate(), userName: "뚱땅뚱땅", userProfilePicture: "userProfile3", job: dummyjobs[2]),
            User(userID: ObjectId.generate(), userName: "미소세상", userProfilePicture: "userProfile4", job: dummyjobs[3]),
            User(userID: ObjectId.generate(), userName: "초록", userProfilePicture: "userProfile5", job: dummyjobs[4]),
            User(userID: ObjectId.generate(), userName: "응시", userProfilePicture: "userProfile6", job: dummyjobs[5])
        ]
    }
    
    //MARK: - 새글 생성
    func createPost(with post: Post) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(post)
        }
        fetchPosts()
    }
    
    //MARK: - 글 모두 불러오기
    func fetchPosts() {
        //MARK: - Realm SchemaVersion 관리
        let config = Realm.Configuration(schemaVersion: 9)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        let fetchResult = realm.objects(Post.self).sorted(by: \.createdDateTime, ascending: false)
        var postResult: [Post] = []
        
        for element in fetchResult {
            postResult.append(element)
        }
        
        self.posts
            .onNext(postResult)
    }
    
    //MARK: - 특정 글 불러오기
    func fetchAPost(_ post: Post) {
        let realm = try! Realm()
        
        let allPosts = realm.objects(Post.self)
        let targetPost = allPosts.where {
            $0.postID == post.postID
        }.first ?? post
        
        self.post
            .onNext(targetPost)
    }
    
    //MARK: - 글 업데이트
    func updateAPost(_ post: Post, contents: String? = nil, contentImage: String? = nil, likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, comments: List<Comment>? = nil, expanded: Bool? = nil, isLiked: Bool? = nil) {
        let realm = try! Realm()
        
        guard let post = realm.object(ofType: Post.self, forPrimaryKey: post.postID) else {
            print(#fileID, #function, #line, " - Error: Post \(post.postID) not found")
            return
        }
        
        try! realm.write {
            if let newContentImage = contentImage {
                post.contentImage = newContentImage
            }
            if let newLikeCount = likeCount {
                post.likeCount = newLikeCount
            }
            if let newCommentCount = commentCount {
                post.commentCount = newCommentCount
            }
            if let newWriter = writer {
                post.writer = newWriter
            }
            if let newComments = comments {
                post.comments = newComments
            }
            if let newExpanded = expanded {
                post.expanded = newExpanded
            }
            if let newIsLiked = isLiked {
                post.isLiked = newIsLiked
                
                if newIsLiked {
                    post.likeCount = (post.likeCount ?? 0) + 1
                } else {
                    post.likeCount = (post.likeCount ?? 1) - 1
                }
            }
        }
        fetchPosts()
//        fetchAPost(post)
    }
    
    ///모든 글 접기
    func reset() {
        //MARK: - 모든 글'더보기' 해제 -> 펼쳤던 글을 접습니다.
        let realm = try! Realm()
        
        let expandedPosts = realm.objects(Post.self).filter("expanded == true")
        
        try! realm.write {
            expandedPosts.setValue("false", forKey: "expanded")
        }
        fetchPosts()
    }
        
    //MARK: - 새 댓글 생성
    func createComment(_ comment: Comment) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(comment)
        }
        
        // 글의 기존 댓글 List에 새 댓글을 추가합니다.
        try! realm.write {
            comment.belongsTo?.comments.append(comment)
        }
        
        fetchComments(of: comment.belongsTo!)
        fetchPosts()
    }
    
    //MARK: - 댓글 불러오기
    func fetchComments(of post:Post) {
        let realm = try! Realm()
        
        let comments = post.comments.sorted(by: \.createdDateTime, ascending: false)
        
        var commentResult: [Comment] = []
        for element in comments {
            commentResult.append(element)
        }
        
        self.comments
            .onNext(commentResult)
    }
}

//MARK: - Utils
extension PostViewModel {
    //MARK: - 작성 시간 String 변환
    func getCreatedDateTime(_ createdDateTime: Date) -> String {
        let dateFormatter = DateFormatter()
        
        let now = Date()
        let day = Double(60 * 60 * 24)
        let hour = Double(60 * 60)
        let min = Double(60)
        
        let interval = now.timeIntervalSince(createdDateTime) // 글 작성시간과 현재시간 차이
        print(#fileID, #function, #line, " - interval: ", interval)
        
        switch interval {
        case 0:
            return "방금 전"
        case 1..<min:
            let seconds = Int(interval)
            return "\(seconds)초 전"
        case min..<hour:
            let mins = Int(interval / min)
            return "\(mins)분 전"
        case hour..<day:
            let hours = Int(interval / hour)
            return "\(hours)시간 전"
        default:
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: createdDateTime)
        }
    }
}
