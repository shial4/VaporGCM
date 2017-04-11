#if os(Linux)
import XCTest
@testable import VaporAndroidGCM

XCTMain([
     testCase(testAndroidGCM.allTests),
])
#endif
