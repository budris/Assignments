//
//  Observer.swift
//  Intraboom
//
//  Created by Sak, Andrey2 on 3/10/17.
//  Copyright © 2017 Intraboom, LLC. All rights reserved.
//

import Foundation
import UIKit

class Observable<T> {
    let didChange = EventHandler<T>()
    private var value: T

    init(_ initialValue: T) {
        value = initialValue
    }

    public func set(newValue: T) {
        value = newValue
        didChange.raise(newValue)
    }

    public func get() -> T {
        return value
    }
}
