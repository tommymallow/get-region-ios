//
//  TESTGetRegionCacheManager.swift
//  FrameworkClasses
//
//  Created by Tommy Mallow on 7/31/17.
//

import Foundation
import XCTest
import RealmSwift

@testable import CompassionAppServices

class TESTGetRegionCacheManager: XCTestCase {
    
    // MARK: - Properties
    
    var sut:            GetRegion!
    var expectation:    XCTestExpectation!
    var result:         GetRegionResult!
    var response:       HTTPURLResponse?
    
    /// Defines the number of seconds to wait for an asynchronous call.
    
        let asyncTimeout: Double = 7
    let URLCode = "BF0100"
    let regionDisplay = "Urban"
    let countryDisplay = "Burkina Faso"
    let regionCode = "urbanBF"
    let UUID = "urbanBF"
    let dailyLifeImage = "http://localhost:3001/uploads/urbanBFdailylife.jpg"
    let communityImage = "http://localhost:3001/uploads/bike-1500500547306.png"
    let compassionchilddevelopmentcenter = "Child development centers provide registered children with a place to learn, grow and study.\n\nChildren whose families have never been able to offer them clean water, health care or an education now have access to these necessities.\n\nCompassion-assisted children attend health classes, tutoring sessions and Bible studies at the center.\n\nThey also spend time writing to and praying for their sponsors."
    let workingthroughthelocalchurch = "The local church, as a spiritual and social institution, is Compassion’s most crucial partner in each community.\n\nMore churches in urban Burkina Faso are working with Compassion to nurture and protect children.\n\nSuch partnerships are vital in implementing Compassion’s holistic, age-appropriate curriculum, which focuses on children’s spiritual, intellectual, socio-emotional and physical development."
    let compassionregionImage = "http://localhost:3001/uploads/bike-1500500547306.png"
    let educationregionImage = "http://localhost:3001/uploads/bike-1500500547306.png"
    
    let howcompassionworksArray = ["Compassion began working in Burkina Faso in 2004.", "Currently more than 56,000 children are registered in 221 child development centers.", "Most children attend the center for 8 hours per week.", "Burkina Faso also has 401 mothers and their babies served through the Child Survival Program."]
    let childrenathomeArray = ["Although many urban homes are relatively modernized with electricity and running water, urban poor have little access to these amenities.", "The disparity between the rich and the poor is no more evident than in the cities of Burkina Faso.", "Extended family is very important to the Burkinabe. It is not uncommon for three or more generations to live under one roof."]
    let economyArray = ["In Burkino Faso, about 44 percent of the urban population lives below the poverty line. It is one of the poorest countries in the world.", "With few natural resources the Burkinabe are forced to travel to neighboring countries for seasonal agricultural work and to labor in mines and on plantations."]
    let geographyandclimateArray = ["Burkina Faso is a landlocked country in western Africa.", "The three primary rivers are the Nazinon, the Nakambé and the Mouhoun.", "The climate is tropical, with warm, dry winters and hot, rainy summers."]
    let issuesandconcernsArray = ["In 2009, Ouagadougou was hit by severe flooding, which forced 150,000 people out of their homes. Many families still live in ramshackle shelters in squatter camps on the city’s outskirts.", "Burkina Faso is in the midst of a polio outbreak. Despite aggressive vaccination campaigns, Burkina Faso hosts an unusually contagious strain of the virus.", "Chronic malnutrition is one of the most pervasive health concerns for Burkina Faso children.", "Urban Burkina Faso medical centers are flooded with cases of malnutrition, particularly near the end of the growing season, when food is most scarce and farmers are waiting for harvest." ]
    let localneedsandchallengesArray = ["Persistent drought -\n This serious problem affects most of the crops, and food supplies have been devastated.", "Malnutrition - Compassion centers throughout Burkina Faso report cases of malnutrition among children, especially around the capital city of Ouagadougou.", "Unemployment - Many people in the capital are unemployed because so many have migrated there looking for work.", "Other challenges - Child trafficking is a huge threat. Malaria and meningitis are serious health concerns. Housing is typically inadequate. Children’s school fees are often too costly for many parents."]
    let schoolsandeducationArray = ["Not many Burkinabe receive a formal education. Only about 30 percent of the adult population can read or write.", "Only about one-third of Burkina Faso children are enrolled in elementary school. Most schools are in cities.", "Some tribal practices bar children, particularly girls, from school. Girls under 15 are frequently forced into early marriage and out of the school system.", "Pervasive poverty also dictates that children work, sometimes performing grueling labor in mines, rather than attend school."]
    let whatcompassionsponsorshipprovidesArray = ["regular nutritious meals and snacks", "health checkups and medical care as needed", "education reinforcement, especially for girls. Compassion believes that a child’s place is in a classroom, where he or she can prepare for a better future rather than laboring to help meet their families’ financial needs.", "programs to help partner churches actively combat all forms of abuse and exploitation of children for commercial or economic purposes", "school tuition, which eases parents’ economic burden and ensures children’s education and the promise of a brighter future", "parent education, including training in income-generating activities that will enable them to better meet the needs of their families"]

    
    
    // MARK:  Setup/teardown
    
    override func setUp() {
        super.setUp()
        
        // Base setup for the getRegion() calls.
        CASConfiguration.shared.buildConfiguration = .staging
        ConnectionKeyManager.shared.addKey(name: GetRegion.apiKeyNameStage,
                                           key: "somethings",
                                           version: 1,
                                           override: false)
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Remove any child which has been added to the Realm DB during a test.
        RegionCacheManager.shared.deleteRegionFromRealm(regionCode : regionCode)
    }
    
    
    // MARK:  Test
    func testGetRegion() {
        
        expectation = self.expectation(description: "Fetch region data and save to Realm.")
        
        RegionCacheManager.shared.getRegion(regionCode : URLCode, callback:
            {
                getRegionResult, expectUpdate in
                self.expectation.fulfill()
                
                self.verifyResult(getRegionResult: getRegionResult)
        },
                                            failureCallback:
            {
                regionCode in
                self.expectation.fulfill()
                XCTFail("Failed to get a realm object for ID \(self.URLCode).")
        }
        ) // End getRegion() call.
        
        waitForExpectations(timeout: asyncTimeout, handler: nil)
    }
    
    
    func testGetCachedRegion() {
        
        expectation = self.expectation(description: "Fetch region and save to Realm.")
        
        RegionCacheManager.shared.getRegion(regionCode : URLCode, callback:
            {
                
                rlmGetRegion, expectUpdate in
                self.expectation.fulfill()
                RegionCacheManager.shared.getRegion(regionCode: self.URLCode, callback:
                    {
                        
                        getRegionResult, expectUpdate in
                        
                        self.verifyResult(getRegionResult : getRegionResult)
                },
                                                    failureCallback:
                    {
                        regionCode in self.expectation.fulfill()
                        XCTFail("Failed to get a realm object for ID \(self.URLCode).")
                }
                )
        },
                                            failureCallback:
            {
                regionCode in self.expectation.fulfill(); XCTFail("Failed to get a realm object.")
        }) // End original getRegion() call.
        
        waitForExpectations(timeout: asyncTimeout, handler: nil)
    }
    
    func testSetUpdateFrequency() {
        RegionCacheManager.shared.updateFrequency = CASCDataUpdateFrequency.daily
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, CASCDataUpdateFrequency.daily)
        RegionCacheManager.shared.updateFrequency = CASCDataUpdateFrequency.everyLaunch
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, CASCDataUpdateFrequency.everyLaunch)
        RegionCacheManager.shared.updateFrequency = CASCDataUpdateFrequency.never
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, CASCDataUpdateFrequency.never)
        RegionCacheManager.shared.updateFrequency = CASCDataUpdateFrequency.weekly
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, CASCDataUpdateFrequency.weekly)
    }
    
    func testResetUpdateFrequency() {
        let originalUpdateFrequency = RegionCacheManager.shared.updateFrequency
        
        RegionCacheManager.shared.updateFrequency = CASCDataUpdateFrequency.everyLaunch
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, CASCDataUpdateFrequency.everyLaunch)
        
        RegionCacheManager.shared.resetUpdateFrequencyToDefault()
        XCTAssertEqual(RegionCacheManager.shared.updateFrequency, originalUpdateFrequency)
    }
    
    func testCreateRLMGetRegionObject() {
        let rlmGetRegion = buildRlmRegion()
        
        let result = RegionCacheManager.shared.createRLMGetRegionResultObject(fromRLMGetRegion: rlmGetRegion)
        
        verifyResult(getRegionResult: result)
    }
    
    // MARK:  Verify functions
    
    private func verifyResult(getRegionResult: GetRegionResult?) {
        if let getRegionResult = getRegionResult{
            
            XCTAssertEqual(getRegionResult.regionDisplay, regionDisplay, "regionDisplay should be equal")
            XCTAssertEqual(getRegionResult.regionDisplay, regionDisplay, "regionDisplay should be equal")
            XCTAssertEqual(getRegionResult.regionCode, regionCode, "regionCode should be equal")
            XCTAssertEqual(getRegionResult.dailylifeList?[0].UUID, UUID, "daily life UUID should be equal")
            XCTAssertEqual(getRegionResult.dailylifeList?[0].image, dailyLifeImage, "daily life image should be equal")
            
            
            verifyStringArray(array: getRegionResult.dailylifeList?[0].childrenathomeArray, expected: childrenathomeArray, message: "daily life result should be equal")
            verifyStringArray(array: getRegionResult.dailylifeList?[0].economyArray, expected: economyArray, message: "daily life result should be equal")
            verifyStringArray(array: getRegionResult.dailylifeList?[0].geographyandclimateArray, expected: geographyandclimateArray, message: "daily life result should be equal")
            
            verifyStringArray(array: getRegionResult.communityList?[0].issuesandconcernsArray, expected: issuesandconcernsArray, message: "community result should be equal")
            
            //print ("............>>>>>>>>>>>>>>", (getRegionResult.communityList?[0].issuesandconcernsArray))
            
            verifyStringArray(array: getRegionResult.communityList?[0].localneedsandchallengesArray, expected: localneedsandchallengesArray, message: "community result should be equal")
            
            verifyStringArray(array: getRegionResult.educationregionList?[0].schoolsandeducationArray, expected: schoolsandeducationArray, message: "educationregion result should be equal")
            verifyStringArray(array: getRegionResult.educationregionList?[0].whatcompassionsponsorshipprovidesArray, expected: whatcompassionsponsorshipprovidesArray, message: "educationregion result should be equal")
            verifyStringArray(array: getRegionResult.compassionregionList?[0].howcompassionworksArray, expected: howcompassionworksArray, message: "compassionrmessage: egion UUID should be equal")
            
        }
    }
    
    fileprivate func verifyStringArray(array: [String]?, expected: [String], message: String) {
        if let array = array {
            XCTAssertEqual(array, expected, message)
        }
        else {
            XCTFail()
        }
    }
    
    
    fileprivate func createCsvString(array: [String]?) -> String? {
        if let array = array {
            return array.joined(separator: "$..$")
        }
        
        return nil
    }
    
    fileprivate func buildRlmRegion() -> RLMGetRegion {
        
        let dailyLife = RLMGetRegionItem()
        let community = RLMGetRegionItem()
        let educationRegion = RLMGetRegionItem()
        let compassionRegion = RLMGetRegionItem()
        
        
        dailyLife.UUID = UUID
        dailyLife.image = dailyLifeImage
        dailyLife.childrenathome = createCsvString(array: childrenathomeArray)
        dailyLife.economy = createCsvString(array: economyArray)
        dailyLife.geographyandclimate = createCsvString(array: geographyandclimateArray)
        
        community.UUID = UUID
        community.image = communityImage
        community.issuesandconcerns = createCsvString(array: issuesandconcernsArray)
        community.localneedsandchallenges = createCsvString(array: localneedsandchallengesArray)
        
        educationRegion.UUID = UUID
        educationRegion.image = educationregionImage
        educationRegion.compassionchilddevelopmentcenter = compassionchilddevelopmentcenter
        educationRegion.schoolsandeducation = createCsvString(array: schoolsandeducationArray)
        educationRegion.whatcompassionsponsorshipprovides = createCsvString(array: whatcompassionsponsorshipprovidesArray)
        
        compassionRegion.UUID = UUID
        compassionRegion.image = compassionregionImage
        compassionRegion.howcompassionworks = createCsvString(array: howcompassionworksArray)
        compassionRegion.workingthroughthelocalchurch = workingthroughthelocalchurch
        
        let dailylifeList = List<RLMGetRegionItem>()
        dailylifeList.append(dailyLife)
        
        let communityList = List<RLMGetRegionItem>()
        communityList.append(community)
        
        let educationregionList = List<RLMGetRegionItem>()
        educationregionList.append(educationRegion)
        
        let compassionregionList = List<RLMGetRegionItem>()
        compassionregionList.append(compassionRegion)
        
        // *** RLMBeneficiary ***
        let rlmGetRegion = RLMGetRegion()
        
        rlmGetRegion.regionDisplay = regionDisplay
        rlmGetRegion.countryDisplay = countryDisplay
        rlmGetRegion.regionCode = regionCode
        
        
        rlmGetRegion.dailylifeList = dailylifeList
        
        rlmGetRegion.communityList = communityList
        
        rlmGetRegion.educationregionList = educationregionList
        
        rlmGetRegion.compassionregionList = compassionregionList
        
        
        return rlmGetRegion
    }
    
}
