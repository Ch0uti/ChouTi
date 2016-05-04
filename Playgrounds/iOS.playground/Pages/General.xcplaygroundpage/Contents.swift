import Foundation

// FlatMap
struct FlatMapExample {
	init() {
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
