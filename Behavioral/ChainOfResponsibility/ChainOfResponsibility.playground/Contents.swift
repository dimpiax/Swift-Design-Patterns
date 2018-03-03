//: Playground - noun: a place where people can play

import UIKit

protocol Documentable {
    func sign(_ value: Int8)
    func applyAddendum(_ value: Int)
}

class Handler {
    var value: Documentable?
    var chain: Handler?
    
    init(chain: Handler? = nil, value: Documentable? = nil) {
        self.chain = chain
        self.value = value
    }
    
    func execute() -> Bool {
        // for subclass
        
        guard let value = value else {
            return false
        }
        
        guard let chain = chain else {
            return true
        }
        
        chain.value = value
        return chain.execute()
    }
}

class President: Handler {
    override func execute() -> Bool {
        value?.sign(0x11)
        value?.applyAddendum(0x00FF00)
        
        return super.execute()
    }
}

class VicePresident: Handler {
    override func execute() -> Bool {
        value?.sign(0x10)
        
        return super.execute()
    }
}

class PrimeMinister: Handler {
    override func execute() -> Bool {
        value?.sign(0x01)
        value?.applyAddendum(0x00FFCC)
        
        return super.execute()
    }
}

class Agreement: Documentable {
    private(set) var signatures = [Int8]()
    private(set) var addendumHashes = [Int]()
    
    func sign(_ value: Int8) {
        signatures.append(value)
    }
    
    func applyAddendum(_ value: Int) {
        addendumHashes.append(value)
    }
}

// create object
let doc = Agreement()

// create responsables and chain
let c = President()
let b = VicePresident(chain: c)
let a = PrimeMinister(chain: b, value: doc)

// start execution
a.execute()

print("""
Agreement has:
- signs: \(doc.signatures);
- addendum hashes: \(doc.addendumHashes)
""")
