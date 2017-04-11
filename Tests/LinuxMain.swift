#if os(Linux)
import XCTest
@testable import VaporGCMTests

XCTMain([
     testCase(testVaporGCM.allTests),
])
#endif
