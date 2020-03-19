//
//  EateriesTableViewControllerTests.swift
//  EatFreshAppTests
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
import CoreLocation
@testable import EatFreshApp

class EateriesTableViewControllerTests: XCTestCase {
    
    var viewControllerUnderTest: EateriesTableViewController!
    var locationMgr:CLLocationManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "EateriesTableViewController") as? EateriesTableViewController
        
        locationMgr = CLLocationManager()
        self.viewControllerUnderTest.locationManager = locationMgr

        self.viewControllerUnderTest.eateries = [getEateryObj()]
        // in view controller, menuItems = ["one", "two", "three"]
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
    }
    
    private func getEateryObj()->Eatery
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let eateryObj  = Eatery(context: context)
        eateryObj.name = "test name"
        eateryObj.rating = 4.1
        eateryObj.userRatingTotal = 230
        eateryObj.vicinity = "Test vicinity"
        eateryObj.iconUrl = "test url"
        
        let OpenHrsObj  = OpeningHours(context: context)
        OpenHrsObj.openNow = true
        OpenHrsObj.eatery = eateryObj
        
        let photoObj  = Photos(context: context)
        photoObj.width = 320
        photoObj.height = 320
        photoObj.photoRef = "test"
        photoObj.eatery = eateryObj
        return eateryObj
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.numberOfSections(in:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EateryTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "cell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testTableCellHasCorrectLabelText() {
        let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? EateryTableViewCell
        XCTAssertNotNil(cell?.eateryNameLabel)
        XCTAssertNotNil(cell?.openLabel)
        XCTAssertNotNil(cell?.ratingsLabel)
        XCTAssertNotNil(cell?.imageView)
        
        
    }
    
    func testLocationManagerIsSet(){
        
        XCTAssertNotNil(viewControllerUnderTest.locationManager)
    }
    
    func testLocationManagerDelegateIsSet(){
        
        XCTAssertNotNil(viewControllerUnderTest.locationManager.delegate)
        XCTAssert((viewControllerUnderTest.locationManager.delegate!.isKind(of: EateriesTableViewController.self)))
    }
    
   
    func testPopUpMessageShownWhenStatusDeniend(){
        
        class FakeLocationManager:CLLocationManager{
            
        }
        let fakeLocationManager = FakeLocationManager()
        viewControllerUnderTest.locationManager.delegate!.locationManager!(fakeLocationManager, didChangeAuthorization: .denied)
    }
    
    func testWhwnLocationIsSetToNepal(){
        
        class FakeLocationManager:CLLocationManager{
            
        }
        
        class FakeLocationManagerDelegate:NSObject, CLLocationManagerDelegate{
        
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             
                let loc = locations.first!
                print("mock location is \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
            }
        }
        
        let fakeDelegate = FakeLocationManagerDelegate()
        let fakeLocationManager = FakeLocationManager()
        viewControllerUnderTest.locationManager.delegate = fakeDelegate
        ((viewControllerUnderTest.locationManager.delegate) as! FakeLocationManagerDelegate).locationManager(viewControllerUnderTest.locationManager, didUpdateLocations:  [CLLocation(latitude:21.2,longitude:23.22)])
    }
    
}
