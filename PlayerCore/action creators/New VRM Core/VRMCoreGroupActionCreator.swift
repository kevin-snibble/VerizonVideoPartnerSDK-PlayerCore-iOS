//  Copyright 2018, Oath Inc.
//  Licensed under the terms of the MIT License. See LICENSE.md file in project root for terms.
import Foundation

public extension VRMCore {
    public static func startGroupProcessing(group: Group) -> Action {
        return StartGroupProcessing(group: group)
    }
    
    public static func finishCurrentGroupProcessing() -> Action {
        return FinishCurrentGroupProcessing()
    }
}