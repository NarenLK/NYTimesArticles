//
//  ArticleViewModel.swift
//  NyTimes
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import Foundation

/// View model class for fetching the articles/images and updating the respective models
class ArticleViewModel {
    // MARK: - Static variable
    static let shared = ArticleViewModel()

    // MARK: - Member variable
    var articleModel: ArticleModel?
    // MARK: - Functions

    /// Function to call the article fetching API.
    /// - Parameter completionHandler: handler for updating the status once API communication is complete
    /// - Returns: nil
    func fetchArticle(completionHandler: @escaping(_ result: String?, _ response: ArticleModel?) -> Void) {
        let periodLength = UserDefaults.standard.value(forKey: Constants.period) as! String
        let url = Server.url + EndPoints.mostViewed + periodLength + Server.typeExtension + Server.apiKey

        NetworkLayer.shared.get(url: url, parameters: nil) { response in
            guard response.error == nil else {
                completionHandler(response.error?.localizedDescription ?? "GENERAL_ERROR_MESSAGE", nil)
                return
            }
            
            switch response.result {
            case .success:
                guard let responseData = response.data else {
                    completionHandler("EMPTY_RESPONSE", nil)
                    return
                }
                print(responseData)
                do {
                    self.articleModel = try JSONDecoder().decode(ArticleModel.self, from: response.data!)
                } catch let error {
                    completionHandler(error.localizedDescription, nil)
                    return
                }
                completionHandler("", self.articleModel)
                
            case .failure(let error):
                completionHandler(error.localizedDescription, nil)
                return
            }
        }
    }
    
    /// Function to download the images
    /// - Parameters:
    ///   - url: image url
    ///   - completionHandler: handler for updating the status once the download is complete
    /// - Returns: nil
    func fetchPhoto(url: String, completionHandler: @escaping (_ data: Data?) -> Void) {
        NetworkLayer.shared.getImage(url: url) { response in
            guard response == nil else {
                completionHandler(response)
                return
            }
            completionHandler(nil)
        }
    }
}
