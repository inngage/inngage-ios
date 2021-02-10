import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(inngage_iosTests.allTests),
    ]
}
#endif
