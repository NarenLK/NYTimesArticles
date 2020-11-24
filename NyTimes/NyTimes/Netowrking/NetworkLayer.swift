//
//  NetworkLayer.swift
//  NyTimes
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import Alamofire
import Foundation

/// Class for communicating the server through http methods
class NetworkLayer {

    // MARK: - Variables
    static let shared = NetworkLayer()
    typealias Response = ((_ response: AFDataResponse<Any>) -> Void)

    // MARK: - http methods
    /// 'get' method for server communication
    /// - Parameters:
    ///   - url: server url
    ///   - parameters: api parameters
    ///   - completionHandler: handler for updating status once api response is received
    /// - Returns: request object (to check the correctness of sent request)
    @discardableResult
    func get(url: String, parameters: Parameters?, completionHandler: @escaping Response) -> DataRequest? {
        guard let url = try? (url).asURL() else {
            return nil
        }

        return AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil, interceptor: nil).responseJSON { response in
            completionHandler(response)
        }
    }

    /// Image downloader function
    /// - Parameters:
    ///   - url: server url
    ///   - completionHandler: handler for updating status once api response is received
    /// - Returns: nil
    func getImage(url: String, completionHandler: @escaping(_ response: Data?) -> Void) {
        AF.request(url, method: .get).response { response in
           switch response.result {
           case .success:
                completionHandler(response.data)
           case .failure(let error):
                print("error->", error)
                completionHandler(nil)
            }
        }
    }
}
