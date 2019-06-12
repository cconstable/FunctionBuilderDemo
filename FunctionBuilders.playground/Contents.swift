
import PlaygroundSupport

indirect enum Node {
    case empty
    case tag(String, Node)
    case text(String)
    case siblings([Node])
}

@_functionBuilder
struct HtmlBuilder {
    static func buildBlock(_ nodes: Node...) -> Node {
        .siblings(nodes)
    }
    
    static func buildOptional(_ node1: Node?) -> Node {
        node1 ?? .empty
    }
    
    static func buildIf(_ node: Node?) -> Node {
        node ?? .empty
    }
}

func render(_ node: Node) -> String {
    switch node {
    case .empty:
        return ""
    case let .tag(name, innerNode):
        return "<\(name)>\(render(innerNode))</\(name)>"
    case let .text(text):
        return text
    case let .siblings(siblings):
        return siblings
            .map { "\(render($0))\n" }
            .joined()
    }
}

func html(@HtmlBuilder builder: () -> Node) -> Node { .tag("html", builder()) }
func body(@HtmlBuilder builder: () -> Node) -> Node { .tag("body", builder()) }
func div(@HtmlBuilder builder: () -> Node) -> Node { .tag("div", builder()) }
func h1(text: () -> String) -> Node { .tag("h1", .text(text())) }
func h2(text: () -> String) -> Node { .tag("h2", .text(text())) }
func p(text: () -> String) -> Node { .tag("p", .text(text())) }

var showFooter = false
let doc =
    html {
        body {
            div {
                h1 { "Title" }
                p {
                    "This is some content"
                }
            }
            if (showFooter) {
                div {
                    p {
                        "This is a footer"
                    }
                }
            }
        }
}

render(doc)
