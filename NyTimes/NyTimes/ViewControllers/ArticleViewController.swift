//
//  ArticleViewController.swift
//  NyTimes
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import MBProgressHUD
import UIKit

/// View controller Class for diaplying the detailed article.
class ArticleViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var lblArticle: UITextView!

    // MARK: - Variables
    var article = Article.init()
    var articleList: [Article] = []
    var articleIndex: Int = -1
    
    // MARK: - Viewcontroller life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        guard articleIndex > -1 else {
            return
        }
        updateArticle()
    }
    
    // MARK: - IBActions
    @IBAction func btnBackward_Tapped(_ sender: UIBarButtonItem) {
        
        if articleIndex == -1 || articleIndex == 0 {
            return
            
        } else {
            articleIndex -= 1
        }
        
        updateArticle()
    }
    
    @IBAction func btnForward_Tapped(_ sender: Any) {
        if articleIndex == -1 || articleIndex == articleList.count - 1 {
            return
            
        } else {
            articleIndex += 1
        }
        updateArticle()
    }
    
    // MARK: - Custom functions
    func updateArticle() {

        article = articleList[articleIndex]
        title = article.section

        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSMutableAttributedString(string: "\n\(String(describing: article.title!))", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.label]))
        
        attributedString.append(NSMutableAttributedString(string: "\n\n\(String(describing: article.abstract!))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        
        attributedString.append(NSMutableAttributedString(string: "\n\n\(String(describing: article.byline!))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
        
        attributedString.append(NSMutableAttributedString(string: "\n\nPublished on : \(String(describing: article.published_date!))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
        
        attributedString.append(NSMutableAttributedString(string: "\nUpdated on : \(String(describing: article.updated!))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
        
        lblArticle.attributedText = attributedString
        
        guard article.media!.isEmpty else {
            let media = article.media!
            
            guard media[0].media_metadata!.isEmpty else {
                let metadata = media[0].media_metadata!
                
                MBProgressHUD.showAdded(to: view, animated: true)
                ArticleViewModel.shared.fetchPhoto(url: metadata[2].url!) { [self] responseData in
                    
                    MBProgressHUD.hide(for: view, animated: true)
                    if responseData == nil {
                        return
                    }
                    
                    let textAttachment = NSTextAttachment()
                    textAttachment.image = UIImage(data: responseData!)
                    let oldWidth = textAttachment.image!.size.width
                    
                    let scaleFactor = oldWidth / (lblArticle.frame.size.width - 10)
                    textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
                    let attrStringWithImage = NSMutableAttributedString(attachment: textAttachment)
                    attrStringWithImage.append(NSMutableAttributedString(string: "\n\(String(describing: media[0].caption!))", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
                    
                    attrStringWithImage.append(NSMutableAttributedString(string: "\n\n"))
                    attributedString.insert(attrStringWithImage, at: 0)
                    lblArticle.attributedText = attributedString
                }
                return
            }
            return
        }
    }
}
