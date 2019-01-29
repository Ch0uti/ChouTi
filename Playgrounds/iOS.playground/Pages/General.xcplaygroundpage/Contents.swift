// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

// FlatMap
struct FlatMapExample {
    init() {
        print("FlapMap:")
        // Use case 1
        struct Object {
            var optionalInt: Int?
        }

        let object1 = Object(optionalInt: 1)
        let object2 = Object(optionalInt: nil)
        let object3 = Object(optionalInt: 3)

        let objectArray = [object1, object2, object3]
        let result1 = objectArray.flatMap { $0.optionalInt }

        print(result1)

        // Use case 2
        let arrayOfArray: [[Int?]] = [[1, 2, nil, 4], [nil, 6], [7, nil, 8], [9]]
        let result2 = arrayOfArray.flatMap { $0.flatMap { $0 } }
        print(result2)
    }
}

FlatMapExample()

// Zip
print("\nZip:")
for (a, b) in zip([1, 2, 3], ["a", "b", "c", "d"]) {
    print("\(a), \(b)")
}

//
let URLComponents = NSURLComponents(string: "http://api.com/resource/1?key1=v1&key2=v2")
let pathComponents = (URLComponents?.path as NSString?)?.pathComponents

URLComponents?.queryItems?.forEach({ item in
    print(item.name)
})

// Drop first
let a = "abvc".characters.dropFirst()
String(a)

// All combinations
let suits = ["♠", "♥", "♣", "♦"]
let ranks = ["J", "Q", "K", "A"]
let allCombinations = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}

print(allCombinations)

// Set up request parameters
let item1 = NSURLQueryItem(name: "language[]", value: "en")
let item2 = NSURLQueryItem(name: "language[]", value: "ko")

let components = NSURLComponents()
components.queryItems = [item1, item2]

print(components.URL!.query?.stringByRemovingPercentEncoding?.substringFromIndex("language[]=".endIndex) ?? "")

//
[1, 2, 3, 4, 5].forEach {
    guard $0 % 2 == 0 else { return }
    print($0)
}

// Combine rounds
struct Round {
    var ordinal: Int
}

struct RoundsSet {
    var rounds: [Round]
}

let set1 = RoundsSet(rounds: [Round(ordinal: 1), Round(ordinal: 2), Round(ordinal: 3), Round(ordinal: 4)])
let set2 = RoundsSet(rounds: [Round(ordinal: 1), Round(ordinal: 2), Round(ordinal: 3)])
let sets = [set1, set2]

let rounds = sets.reduce([]) { (totalRounds, set) -> [Round] in
    totalRounds + set.rounds.map { round in
        Round(ordinal: round.ordinal + (totalRounds.last?.ordinal ?? 0))
    }
}

print(rounds)

// FlatMap
[1, 2, 3, 4].flatMap { num -> Int? in
    if num % 2 == 0 { return nil }
    return num
}
