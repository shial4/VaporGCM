#if os(Linux)
import XCTest
@testable import VaporGCM

XCTMain([
     testCase(testGCM.allTests),
])
#endif
