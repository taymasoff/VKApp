//
//  NewsTableCell.swift
//  VKApp
//
//  Created by Тимур Таймасов on 29.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit

class NewsTableCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var postAuthorImg: UIImageView!
    @IBOutlet weak var postAuthorName: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var amountOfLikes: UILabel!
    @IBOutlet weak var amountOfComments: UILabel!
    @IBOutlet weak var amountOfReposts: UILabel!
    @IBOutlet weak var amountOfViews: UILabel!
    
    // MARK: - Properties
    
    var news: News? {
        didSet {
            
            postAuthorImg.translatesAutoresizingMaskIntoConstraints = false
            postImage.translatesAutoresizingMaskIntoConstraints = false
            
            if let postAuthorName = news?.postAuthorName {
                self.postAuthorName.translatesAutoresizingMaskIntoConstraints = false
                self.postAuthorName.isHidden = false
                self.postAuthorName.text = "\(postAuthorName)"
            } else {
                self.postAuthorName.isHidden = true
            }
            
            if let postTime = news?.postTime {
                self.postTime.translatesAutoresizingMaskIntoConstraints = false
                self.postTime.isHidden = false
                self.postTime.text = "\(postTime)"
            } else {
                self.postTime.isHidden = true
            }
            
            if let postText = news?.postText {
                self.postText.translatesAutoresizingMaskIntoConstraints = false
                self.postText.text = "\(postText)"
            }
            
            if let amountOfLikes = news?.likes {
                self.amountOfLikes.translatesAutoresizingMaskIntoConstraints = false
                self.amountOfLikes.text = "\(amountOfLikes.roundedWithAbbreviations)"
            } else {
                self.amountOfLikes.text = "?"
            }
            
            if let amountOfComments = news?.comments {
                self.amountOfComments.translatesAutoresizingMaskIntoConstraints = false
                self.amountOfComments.text = "\(amountOfComments)"
            } else {
                self.amountOfComments.text = "?"
            }
            
            if let amountOfReposts = news?.reposts {
                self.amountOfReposts.translatesAutoresizingMaskIntoConstraints = false
                self.amountOfReposts.text = "\(amountOfReposts.roundedWithAbbreviations)"
            } else {
                self.amountOfReposts.text = "?"
            }
            
            if let amountOfViews = news?.views {
                self.amountOfViews.translatesAutoresizingMaskIntoConstraints = false
                self.amountOfViews.text = "\(amountOfViews.roundedWithAbbreviations)"
            } else {
                self.amountOfViews.text = "?"
            }
        }
    }
    
    // MARK: - Frames
    
    override func awakeFromNib() {
        postAuthorPhotoFrame()
        postAuthorNameFrame()
        postTextFrame()
        postImageFrame()
        likesFrame()
        commentsFrame()
        repostsFrame()
        viewsFrame()
    }
    
    let insets: CGFloat = 10.0
    
    private func ​getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - insets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    private func postAuthorPhotoFrame() {
        let postAuthorPhotoLength: CGFloat = 40
        let postAuthorPhotoWidth = bounds.width - insets * 2
        let postAuthorPhotoSize = CGSize(width: postAuthorPhotoWidth, height: postAuthorPhotoLength)
        let postAuthorImgOrig = CGPoint(x: insets, y: insets)
        postAuthorImg.frame = CGRect(origin: postAuthorImgOrig, size: postAuthorPhotoSize)
    }
    
    private func postAuthorNameFrame() {
        let postAuthorNameSize = ​getLabelSize(text: postAuthorName.text!, font: postAuthorName.font)
        let postAuthorNameX = (bounds.width - postAuthorNameSize.width) / 2
        let postAuthorNameOrig = CGPoint(x: postAuthorNameX, y: insets)
        postAuthorName.frame = CGRect(origin: postAuthorNameOrig, size: postAuthorNameSize)
    }
    
    private func postTextFrame() {
        let postTextSize = ​getLabelSize(text: postText.text!, font: postText.font)
        let postTextX = (bounds.width - postTextSize.width) / 2
        let postTextY = (bounds.height - postTextSize.height) / 4
        let postTextOrigin = CGPoint(x: postTextX, y: postTextY)
        postText.frame = CGRect(origin: postTextOrigin, size: postTextSize)
    }
    
    private func postImageFrame() {
        let postImageLength: CGFloat = 300
        let postImageWidth = bounds.width - insets * 2
        let postImageSize = CGSize(width: postImageWidth, height: postImageLength)
        let postImageOrigin = CGPoint(x: bounds.midX - postImageWidth / 2, y: bounds.midY - postImageLength / 2)
        postImage.frame = CGRect(origin: postImageOrigin, size: postImageSize)
    }
    
    private func likesFrame() {
        let likesSize = ​getLabelSize(text: amountOfLikes.text!, font: amountOfLikes.font)
        let likesY = bounds.height - likesSize.height
        let likesX = bounds.width - likesSize.width - insets
        let likesOrigin = CGPoint(x: likesX , y: likesY)
        amountOfLikes.frame = CGRect(origin: likesOrigin, size: likesSize)
    }
    
    private func commentsFrame() {
        let commentsSize = ​getLabelSize(text: amountOfComments.text!, font: amountOfComments.font)
        let commentsY = bounds.height - commentsSize.height
        let commentsX = (bounds.width - commentsSize.width) / 2 + 130
        let commentsOrigin = CGPoint(x: commentsX , y: commentsY)
        amountOfComments.frame = CGRect(origin: commentsOrigin, size: commentsSize)
    }
    
    private func repostsFrame() {
        let repostsSize = ​getLabelSize(text: amountOfReposts.text!, font: amountOfReposts.font)
        let repostsY = bounds.height - repostsSize.height
        let repostsX = (bounds.width - repostsSize.width) / 2
        let repostsOrigin = CGPoint(x: repostsX , y: repostsY)
        amountOfReposts.frame = CGRect(origin: repostsOrigin, size: repostsSize)
    }
    
    private func viewsFrame() {
        let viewsSize = ​getLabelSize(text: amountOfViews.text!, font: amountOfViews.font)
        let viewsY = bounds.height - viewsSize.height
        let viewsX = (bounds.width - viewsSize.width) / 2 + 65
        let viewsOrigin = CGPoint(x: viewsX , y: viewsY)
        amountOfViews.frame = CGRect(origin: viewsOrigin, size: viewsSize)
    }
    
    
    
    
    
}
