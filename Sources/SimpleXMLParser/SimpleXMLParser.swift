import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

public class Element {

    public var name: String
    public var attributes: [String: String] = [:]
    public var children: [Element] = []
    public var characters: String?
    public weak var parent: Element?

    public init(name: String) {
        self.name = name
    }
}

final public class SimpleXMLParser: NSObject, XMLParserDelegate {

    private var root = Element(name: "Root")
    private var addedElements = [Element]()
    private var continuation: CheckedContinuation<Element, Error>?

    public func parse(xml: String) async throws -> Element {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            self.continuation = continuation
            let parser = XMLParser(data: xml.data(using: .utf8)!)
            parser.delegate = self
            _ = parser.parse()
        }
    }

    public func parserDidStartDocument(_ parser: XMLParser) {
        reset()
    }

    public func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        continuation?.resume(throwing: validationError)
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        continuation?.resume(throwing: parseError)
    }

    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
            let newElement = Element(name: elementName)
            let parentElement = addedElements.last
            newElement.parent = parentElement
            newElement.attributes = attributeDict
            parentElement?.children.append(newElement)
            addedElements.append(newElement)
        }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        addedElements.last?.characters = string
    }

    public func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?) {
            addedElements.removeLast()
        }

    public func parserDidEndDocument(_ parser: XMLParser) {
        guard let continuation = continuation else {
            return
        }
        continuation.resume(returning: root)
    }

    // MARK: - Private
    private func reset() {
        addedElements = []
        root = Element(name: "Root")
        addedElements.append(root)
    }
}
