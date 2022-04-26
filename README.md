# SimpleXMLParser

[![codecov](https://codecov.io/gh/michaelhenry/SimpleXMLParser/branch/main/graph/badge.svg?token=3BBGJUDV3M)](https://codecov.io/gh/michaelhenry/SimpleXMLParser)

A Simple XML Parser built with `Swift.Concurrency`.

## Example

```swift
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
```
