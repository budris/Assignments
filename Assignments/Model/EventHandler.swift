//
//  File.swift
//  Intraboom
//
//  Created by Sak, Andrey2 on 3/10/17.
//  Copyright © 2017 Intraboom, LLC. All rights reserved.
//

import Foundation

public protocol Disposable {
    func dispose()
}

public class EventHandler<T> {

    public typealias EventHandler = (T) -> ()

    fileprivate var eventHandlers = [Invocable]()

    public func raise(_ data: T) {
        for handler in self.eventHandlers {
            handler.invoke(data)
        }
    }

    public func addHandler<U: AnyObject>(target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let wrapper = EventHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }
}

private protocol Invocable: class {
    func invoke(_ data: Any)
}

private class EventHandlerWrapper<T: AnyObject, U>: Invocable, Disposable {
    weak var target: T?
    let handler: (T) -> (U) -> ()
    let event: EventHandler<U>

    init(target: T?, handler: @escaping (T) -> (U) -> (), event: EventHandler<U>) {
        self.target = target
        self.handler = handler
        self.event = event;
    }

    func invoke(_ data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }

    func dispose() {
        event.eventHandlers =
            event.eventHandlers.filter { $0 !== self }
    }
}
