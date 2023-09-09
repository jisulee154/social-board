//
//  PostViewModel.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import RxSwift
import RealmSwift
import Foundation

class PostViewModel {
    static let shared = PostViewModel()
    var posts = PublishSubject<[Post]>()
    var comments = PublishSubject<[Comment]>()
    
    let disposeBag = DisposeBag()
    
    var dummyjobs: [Job] = []
    var dummyUsers: [User] = []
//    var dummyComments: [Comment] = []
    
    private init() {
        //MARK: - 더미 데이터
        dummyjobs = [
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 1),
            Job(jobID: ObjectId.generate(), category: JobCategory.design, workYear: 3),
            Job(jobID: ObjectId.generate(), category: JobCategory.business, workYear: 11),
            Job(jobID: ObjectId.generate(), category: JobCategory.hr, workYear: 4),
            Job(jobID: ObjectId.generate(), category: JobCategory.marcketing, workYear: 2)
        ]
        
        dummyUsers = [
            User(userID: ObjectId.generate(), userName: "신사임당", userProfilePicture: "userProfile1", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "유관순", userProfilePicture: "userProfile2", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "아이바오", userProfilePicture: "userProfile3", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "곰", userProfilePicture: "userProfile4", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "여우", userProfilePicture: "userProfile5", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "푸바오", userProfilePicture: "userProfile6", job: dummyjobs.randomElement())
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
    
    //MARK: - 글 불러오기
    func fetchPosts() {
        //MARK: - Realm SchemaVersion 관리
        let config = Realm.Configuration(schemaVersion: 7)
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
    
    //MARK: - 글 업데이트
    func updatePost(_ post: Post, contents: String? = nil, contentImage: String? = nil, likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, comments: List<Comment>? = nil, expanded: Bool? = nil) {
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
//            print(#fileID, #function, #line, " - update as: ", post.expanded ?? "nil")
        }
        fetchPosts()
    }
    
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
    #warning("무슨 포스트랑 관련이 있는지 어떻게 알지??? 일단 제껴")
    func createComment(of post: Post) {
        let realm = try! Realm()
        
        let dummyCommentContents: [String] = [
            "댓글1 내용 내용 내용",
            "댓글2 한치 두치 세치 네치 뿌꾸 빵 뿌꾸 빵",
            "댓글3 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용",
            "댓글4 좋은 내용 감사합니다.",
            "댓글5 저도 얼른 써보고 싶네요! "
        ]
        
        let comment: Comment = Comment(commentID: ObjectId.generate(),
                                       createdDateTime: Date(),
                                       contents: dummyCommentContents.randomElement(),
                                       writtenBy: post.writer,
                                       belongsTo: post)
        
        try! realm.write {
            realm.add(comment)
        }
        
        fetchComments(of: post)
    }
    
    //MARK: - 댓글 불러오기
    func fetchComments(of post:Post) {
        let realm = try! Realm()
        
        let allComments = realm.objects(Comment.self)
        let commentsOfPost = allComments.where {
            $0.belongsTo == post
        }.sorted(by: \.createdDateTime, ascending: false)
        
        var commentResult: [Comment] = []
        
        for element in commentsOfPost {
            commentResult.append(element)
        }
        
        self.comments
            .onNext(commentResult)
    }
}
