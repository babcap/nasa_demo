//
//  AsynchronousOperation.swift
//  NasaDemo
//
//  Created by Arthur on 25.08.2023.
//

import Foundation

class AsynchronousOperation: Operation {

    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }

    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)

    private var rawState: OperationState = .ready

    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }

    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }

    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }

    public final override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        state = .executing
        main()
    }

    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }

    public final func finish() {
        if !isFinished { state = .finished }
    }
}
