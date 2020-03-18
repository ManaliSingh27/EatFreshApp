//
//  NetworkManagerTests.swift
//  EatFreshAppTests
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import EatFreshApp

class NetworkManagerTests: XCTestCase {

    var networkManager : NetworkManager!
          let mockSession = MockURLSession()
          var newData : Data!

          override func setUp() {
              // Put setup code here. This method is called before the invocation of each test method in the class.
              super.setUp()
              networkManager = NetworkManager(session: mockSession)
          }
          

          override func tearDown() {
              // Put teardown code here. This method is called after the invocation of each test method in the class.
          }

          func test_correct_url_called()
          {
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=\(Constants.PLACES_API_KEY)")
              networkManager.downloadData(url: url!, completion: {_ in
                  
              })
              XCTAssert(mockSession.lastUrl == url)
          }
         
          func test_Resume_Called()
          {
              let dataTask = MockURLSessionDataTask()
              mockSession.nextDataTask = dataTask
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=\(Constants.PLACES_API_KEY)")
              networkManager.downloadData(url: url!, completion: {_ in
              })
              XCTAssert(dataTask.resumeWasCalled == true)
          }
          
          func test_get_data()
          {
            let url = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=\(Constants.PLACES_API_KEY)")
              let exp = expectation(description: "Wait for url to load.")

              let networkManager = NetworkManager(session: URLSession.shared)
              networkManager.downloadData(url: url!, completion: {[weak self](result)  in
                  switch(result)
                  {
                  case .Success(let data):
                      self!.newData = data
                      exp.fulfill()

                  case .Error(let string):
                      print(string)
                  }
              })
              waitForExpectations(timeout: 5, handler: nil)
              XCTAssertNotNil(newData)
          }


}
