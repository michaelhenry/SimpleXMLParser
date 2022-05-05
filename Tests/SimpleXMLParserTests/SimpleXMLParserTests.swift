import XCTest
@testable import SimpleXMLParser

final class SimpleXMLParserTests: XCTestCase {

    func testValidXML() async throws {

        let junit = """
        <?xml version="1.0" encoding="UTF-8"?>
        <testsuites>
            <testsuite tests="3" failures="1" disabled="0" errors="0" time="0.006" name="SwiftTests">
                <testcase classname="Tests.SwiftTests" name="testShouldPass" time="0.001"></testcase>
                <testcase classname="Tests.SwiftTests" name="testShouldPassAgain" time="0.004"></testcase>
                <testcase classname="Tests.SwiftTests" name="testFail" time="0.001">
                    <failure message="Assertion failed"></failure>
                </testcase>
            </testsuite>
            <testsuite tests="1" failures="1" disabled="0" errors="0" time="0.001" name="AnotherTests">
                <testcase classname="Tests.AnotherTests" name="testShouldFail" time="0.001">
                    <failure message="Oops, something went wrong!"></failure>
                </testcase>
            </testsuite>
        </testsuites>
        """

        let parser = SimpleXMLParser()
        let rootElement = try await parser.parse(xml: junit)
        XCTAssertEqual(rootElement.children[0].name, "testsuites")

        XCTAssertEqual(rootElement.children[0].children[0].name, "testsuite")
        XCTAssertEqual(rootElement.children[0].children[0].children[0].name, "testcase")
        XCTAssertEqual(rootElement.children[0].children[0].children[1].name, "testcase")
        XCTAssertEqual(rootElement.children[0].children[0].children[2].name, "testcase")
        XCTAssertEqual(rootElement.children[0].children[0].children[2].name, "testcase")
        XCTAssertEqual(rootElement.children[0].children[0].children[2].children[0].name, "failure")

        XCTAssertEqual(rootElement.children[0].children[1].name, "testsuite")
        XCTAssertEqual(rootElement.children[0].children[1].children[0].name, "testcase")
        XCTAssertEqual(rootElement.children[0].children[1].children[0].children[0].name, "failure")
    }

    func testEmptyXML() async throws {
        do {
            let xml = """
            hello world
            """
            let parser = SimpleXMLParser()
            _ = try await parser.parse(xml: xml)
        } catch {
            XCTAssertEqual(XMLParser.ErrorCode.emptyDocumentError.rawValue, (error as NSError).code)
        }
    }
}
