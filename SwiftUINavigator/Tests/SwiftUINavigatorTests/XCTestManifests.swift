import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(SwiftUINavigatorTests.allTests),
    ]
}
#endif
