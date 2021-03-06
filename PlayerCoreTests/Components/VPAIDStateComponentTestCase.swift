//  Copyright 2018, Oath Inc.
//  Licensed under the terms of the MIT License. See LICENSE.md file in project root for terms.

import XCTest
@testable import PlayerCore

class VPAIDStateComponentTestCase: XCTestCase {
    let initial = VPAIDState(events: [], adClickthrough: nil)
    
    func testOnShowAdAction() {
        var sut = reduce(state: initial, action: ShowVPAIDAd(creative: AdCreative.vpaid(with: testUrl), id: UUID()))
        XCTAssertEqual(sut.adClickthrough, testUrl)
        
        sut = reduce(state: VPAIDState(events: [.AdSkipped], adClickthrough: nil),
                     action: ShowVPAIDAd(creative: AdCreative.vpaid(with: testUrl), id: UUID()))
        XCTAssertEqual(sut.adClickthrough, testUrl)
        XCTAssert(sut.events.isEmpty)
    }
    
    func testOnAdStoppedAction() {
        let state = VPAIDState(events: [.AdLoaded, .AdStarted], adClickthrough: nil)
        var sut = reduce(state: state, action: VPAIDActions.AdStopped())
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, [])
        
        sut = reduce(state: state, action: SelectVideoAtIdx(idx: 1, id: UUID(), hasPrerollAds: true, midrolls: []))
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, [])
    }
    func testOnVPAIDAdActions() {
        var events: [VPAIDEvents] = []
        
        var state: VPAIDState {
          return VPAIDState(events: events, adClickthrough: nil)
        }
        var sut = reduce(state: state, action: VPAIDActions.AdLoaded())
        events.append(.AdLoaded)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdStarted())
        events.append(.AdStarted)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdSkipped())
        events.append(.AdSkipped)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdPaused())
        events.append(.AdPaused)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdResumed())
        events.append(.AdResumed)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdImpression())
        events.append(.AdImpression)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdVideoStart())
        events.append(.AdVideoStart)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdVideoFirstQuartile())
        events.append(.AdVideoFirstQuartile)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdVideoMidpoint())
        events.append(.AdVideoMidpoint)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdVideoThirdQuartile())
        events.append(.AdVideoThirdQuartile)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdVideoComplete())
        events.append(.AdVideoComplete)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdUserAcceptInvitation())
        events.append(.AdUserAcceptInvitation)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdUserClose())
        events.append(.AdUserClose)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdUserMinimize())
        events.append(.AdUserMinimize)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdClickThru(url: testUrl.absoluteString))
        events.append(.AdClickThru(testUrl.absoluteString))
        XCTAssertEqual(sut.adClickthrough, testUrl)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdError(error: NSError(domain: "", code: 901)))
        events.append(.AdError(NSError(domain: "", code: 901)))
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, events)
        
        sut = reduce(state: state, action: VPAIDActions.AdStopped())
        events.append(.AdStopped)
        XCTAssertEqual(sut.adClickthrough, nil)
        XCTAssertEqual(sut.events, [])
    }
}

extension VPAIDEvents: Equatable {
    public static func == (lhs: VPAIDEvents, rhs: VPAIDEvents) -> Bool {
        switch (lhs, rhs) {
        case (.AdDurationChange(let lv), .AdDurationChange(let rv)): return lv == rv
        case (.AdCurrentTimeChanged(let lv), .AdCurrentTimeChanged(let rv)): return lv == rv
        case (.AdClickThru(let lv), .AdClickThru(let rv)): return lv == rv
        case (.AdWindowOpen(let lv), .AdWindowOpen(let rv)): return lv == rv
        case (.AdVolumeChange(let lv), .AdVolumeChange(let rv)): return lv == rv
        case (.AdLoaded, .AdLoaded), (.AdStarted, .AdStarted),
             (.AdStopped, .AdStopped), (.AdSkipped, .AdSkipped),
             (.AdPaused, .AdPaused), (.AdResumed, .AdResumed),
             (.AdError, .AdError), (.AdImpression, .AdImpression),
             (.AdVideoStart, .AdVideoStart), (.AdVideoFirstQuartile, .AdVideoFirstQuartile),
             (.AdVideoMidpoint, .AdVideoMidpoint), (.AdVideoThirdQuartile, .AdVideoThirdQuartile),
             (.AdVideoComplete, .AdVideoComplete), (.AdUserAcceptInvitation, .AdUserAcceptInvitation),
             (.AdUserMinimize, .AdUserMinimize), (.AdUserClose, .AdUserClose): return true
        default: return false
        }
    }
}
