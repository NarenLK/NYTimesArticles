//
//  NyTimesTests.swift
//  NyTimesTests
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import XCTest
@testable import NyTimes

class NyTimesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchArticlesWebservice() {
        let serverUrl = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=GLdHw57A1S543pjSPVbQsAYe1OMO9GlA"
        let testExpectation = expectation(description: "GET \(serverUrl)")
        
        NetworkLayer.shared.get(url: serverUrl, parameters: nil) { response in
            
            guard response.error == nil else {
                XCTFail(response.error?.localizedDescription ?? "GENERAL_ERROR_MESSAGE")
                return
            }
            
            switch response.result {
            case .success:
                guard let _ = response.data else {
                    XCTAssert(true)
                    testExpectation.fulfill()
                    return
                }
                
                let articleModel : ArticleModel
                do {
                    articleModel = try JSONDecoder().decode(ArticleModel.self, from: response.data!)
                } catch let error {
                    XCTFail(error.localizedDescription)
                    return
                }
                testExpectation.fulfill()
                XCTAssert(articleModel.status == "OK")
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
                return
            }
        }
        
        waitForExpectations(timeout: 30) { error in
            XCTAssert( error == nil)
        }
    }
    
    func testFetchImageWebservice() {
        
        let serverUrl = "https://static01.nyt.com/images/2020/11/24/multimedia/24xp-monolith4/24xp-monolith4-thumbStandard.jpg"
        let testExpectation = expectation(description: "GET \(serverUrl)")
        
        NetworkLayer.shared.getImage(url: serverUrl) { responseData in

            guard responseData == nil else {
                testExpectation.fulfill()
                XCTAssert(true)
                return
            }
            XCTFail("Image download error")
        }
        
        waitForExpectations(timeout: 30) { error in
            XCTAssert( error == nil)
        }
    }

}
