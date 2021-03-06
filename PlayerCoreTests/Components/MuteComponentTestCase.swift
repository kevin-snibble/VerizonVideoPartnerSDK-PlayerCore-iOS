//  Copyright 2018, Oath Inc.
//  Licensed under the terms of the MIT License. See LICENSE.md file in project root for terms.

import XCTest
@testable import PlayerCore

class SoundComponentTestCase: XCTestCase {

    func testReduceOnMute() {
        let initial = Mute(player: false, vpaid: false)
        let sut = reduce(state: initial, action: PlayerMute())
        XCTAssertEqual(sut.player, true)
        XCTAssertEqual(sut.vpaid, true)
    }
    
    func testReduceOnUnmute() {
        let initial = Mute(player: true, vpaid: false)
        let sut = reduce(state: initial, action: PlayerUnmute())
        XCTAssertEqual(sut.player, false)
        XCTAssertEqual(sut.vpaid, false)
    }
    
    func testReduceOnAdVolumeChangeMute() {
        let initial = Mute(player: false, vpaid: false)
        let sut = reduce(state: initial, action: VPAIDActions.AdVolumeChange(volume: 0.0))
        XCTAssertEqual(sut.player, false)
        XCTAssertEqual(sut.vpaid, true)
    }
    
    func testReduceOnAdVolumeChangeUnmute() {
        let initial = Mute(player: true, vpaid: true)
        let sut = reduce(state: initial, action: VPAIDActions.AdVolumeChange(volume: 1.0))
        XCTAssertEqual(sut.player, true)
        XCTAssertEqual(sut.vpaid, false)
    }
    
    func testReduceOnShowAd() {
        let initial = Mute(player: false, vpaid: true)
        var sut = reduce(state: initial, action: ShowVPAIDAd(creative: AdCreative.vpaid(with: testUrl), id: UUID()))
        XCTAssertEqual(sut.player, false)
        XCTAssertEqual(sut.vpaid, false)
        
        sut = reduce(state: initial, action: ShowMP4Ad(creative: AdCreative.mp4(with: testUrl), id: UUID()))
        XCTAssertEqual(sut.player, false)
        XCTAssertEqual(sut.vpaid, false)
    }
    
    func testReduceOnOtherActions() {
        let initial = Mute(player: true, vpaid: true)
        let sut = reduce(state: initial, action: Play(time: .init()))
        XCTAssertEqual(sut.player, true)
        XCTAssertEqual(sut.vpaid, true)
    }
}
