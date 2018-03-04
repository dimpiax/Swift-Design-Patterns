//: Playground - noun: a place where people can play

import Foundation

import UIKit

protocol Viewable {
    func draw() -> String
}

protocol Decorable {
    var parent: Decorable? { get set }
    var view: Viewable { get }
    
    init(parent: Decorable?)
    
    func execute() -> String
}

extension Decorable {
    func execute() -> String {
        var parentValue = ""
        if let p = parent {
            parentValue = "\n\(p.execute())"
        }
        
        return "\(view.draw())\(parentValue)"
    }
}

class Root: Decorable {
    struct View: Viewable {
        func draw() -> String {
            return "/\\/\\/\\"
        }
    }
    
    var parent: Decorable?
    var view: Viewable { return View() }
    
    required init(parent: Decorable? = nil) {
        self.parent = parent
    }
}

class Trunk: Decorable {
    struct View: Viewable {
        func draw() -> String {
            return " \\\\\\\\"
        }
    }
    
    var parent: Decorable?
    var view: Viewable { return View() }
    
    required init(parent: Decorable? = nil) {
        self.parent = parent
    }
}

class Leaves: Decorable {
    struct View: Viewable {
        func draw() -> String {
            return "🌿🌿"
        }
    }
    
    var parent: Decorable?
    var view: Viewable { return View() }
    
    required init(parent: Decorable? = nil) {
        self.parent = parent
    }
}

class CornLeaves: Decorable {
    struct View: Viewable {
        func draw() -> String {
            return "🌽🌽"
        }
    }
    
    var parent: Decorable?
    var view: Viewable { return View() }
    
    required init(parent: Decorable? = nil) {
        self.parent = parent
    }
}

func render(_ value: Decorable, title: String) -> String {
    // imperative way
    let result = value.execute()
    
    // declarative way
    // var result = ""
    // var part: Decorable? = value
    // while let p = part {
    //     result += "\(p.view.draw())\n"
    //     part = p.parent
    // }
    
    return "\(title)\n-\n\n\(result)"
}

let tree = Trunk(parent: Root())

// render items horizontally
print("Tree variants\n")
Output(separator: "\t|\t", delimiter: " ").print(
    render(tree, title: "A"),
    render(Leaves(parent: tree), title: "B"),
    render(CornLeaves(parent: tree), title: "C"),
    render(CornLeaves(parent: Leaves(parent: tree)), title: "D")
)
