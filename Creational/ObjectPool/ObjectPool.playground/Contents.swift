//: Playground - noun: a place where people can play

import Foundation

protocol Poolable {
    init()
}

class Pool<T: Hashable>: CustomStringConvertible where T: Poolable {
    private var _free = [T]()
    private var _busy = [T]()
    
    var maxSize = 2
    
    init() {
        // empty init
    }
    
    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    func getItem() -> T {
        if _free.isEmpty {
            if _busy.count >= maxSize {
                return T()
            }
            
            _busy.append(T())
        }
        else {
            _busy.append(_free.removeFirst())
        }
        
        return _busy.last!
    }
    
    func releaseItem(_ value: T) -> Bool {
        guard let index = _busy.index(where: { $0 == value }) else {
            return false
        }
        
        _free.append(_busy.remove(at: index))
        
        return true
    }
    
    // PROTOCOL
    // * CustomStringConvertible
    var description: String {
        return "\(type(of: self)) busy: \(_busy.count) free: \(maxSize - _busy.count)"
    }
}

struct Snowflake: Poolable, Hashable {
    private let _hash: Int
    
    init() {
        _hash = Int(arc4random())
    }
    
    // PROTOCOL
    // * Hashable
    var hashValue: Int { return _hash }
    
    // * Equatable
    static func ==(lhs: Snowflake, rhs: Snowflake) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

let pool = Pool<Snowflake>()

print("0.0 \(pool)")
let a = pool.getItem() // allocate item
let b = pool.getItem() // allocate item
let c = pool.getItem() // try to allocate item that won't added to pool
print("+ a: \(a)")
print("+ b: \(b)")
print("+ c: \(c)")

print("\n0.1 \(pool)")
print("- c: \(c) \(pool.releaseItem(c))") // try release not handled item
print("- b: \(b) \(pool.releaseItem(b))") // release item
print("0.2 \(pool)")

print("\n1.0 \(pool)")
let d = pool.getItem() // allocate new item
print("+ d: \(d)")
print("1.1 \(pool)")

print("\n- b: \(a) \(pool.releaseItem(a))") // release item
print("- b: \(d) \(pool.releaseItem(d))") // release item
print("1.2 \(pool)")
