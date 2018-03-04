import Foundation

extension Array {
    func maxLength(body: (Element) -> Index) -> Int {
        var max = 0
        for value in self {
            let count = body(value)
            if max < count {
                max = count
            }
        }
        return max
    }
}

struct Size {
    let width: Int
    let height: Int
}

struct OutputMessage {
    let value: String?
    let size: Size
}

struct OutputBox {
    private let _parts: [String]
    
    private var _size: Size
    var size: Size {
        return _size
    }
    
    init(_ value: String) {
        _parts = value.components(separatedBy: "\n")
        
        let width = _parts.maxLength { $0.count }
        _size = Size(width: width, height: _parts.count)
    }
    
    func getLineAt(index: Int) -> String? {
        guard index < _parts.count else {
            return nil
        }
        
        return _parts[index]
    }
}

struct OutputPrinter {
    private let _items: [OutputBox]
    
    init(items: [OutputBox]) {
        _items = items
    }
    
    func print(separator: String = " ", delimiter: String = " ") {
        let output = getItemsOutput()
        
        var result = ""
        for value in output {
            for message in value {
                let string = message.value ?? ""
                let offset = Array(repeating: delimiter, count: message.size.width - string.utf16.count).joined()
                
                result = "\(result)\(string)\(offset)\(separator)"
            }
            result = "\(result)\n"
        }
        
        Swift.print(result)
    }
    
    // PRIVATE
    private func getItemsOutput() -> [[OutputMessage]] {
        let height = _items.maxLength { $0.size.height }
        
        var value = [[OutputMessage]]()
        for index in 0..<height {
            var lineOutputs = [OutputMessage]()
            for item in _items {
                lineOutputs.append(OutputMessage(value: item.getLineAt(index: index), size: item.size))
            }
            
            value.append(lineOutputs)
        }
        
        return value
    }
}

public struct Output {
    let separator: String
    let delimiter: String
    
    public init(separator: String = " ", delimiter: String = " ") {
        self.separator = separator
        self.delimiter = delimiter
    }
    
    public func print(_ value: String...) {
        OutputPrinter(items: value.map(OutputBox.init)).print(separator: separator, delimiter: delimiter)
    }
}
