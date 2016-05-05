import Foundation

/// A reference type that provides a better default representation than the class name
public protocol DefaultReflectable: CustomStringConvertible {}

/// A default implementation that enables class members to display their values
extension DefaultReflectable {
	
	/// Constructs a better representation using reflection
	internal func defaultDescription<T>(instance: T) -> String {
		let mirror = Mirror(reflecting: instance)
		let chunks = mirror.children.map({
			(label: String?, value: Any) -> String in
			if let label = label {
				if value is String {
					return "\(label): \"\(value)\""
				}
				return "\(label): \(value)"
			} else {
				return "\(value)"
			}
		})
		if chunks.count > 0 {
			let chunksString = chunks.joinWithSeparator(", ")
			return "\(mirror.subjectType)(\(chunksString))"
		} else {
			return "\(instance)"
		}
	}
	
	/// Conforms to CustomStringConvertible
	public var description: String {
		return defaultDescription(self)
	}
}

class C: DefaultReflectable {
	var a = "123"
	var b = "456"
}

String(C())

let mirror = Mirror(reflecting: C())
String(mirror.subjectType)


/// The Swift Reflection API and what you can do with it
import Foundation.NSURL

public class Store {
	let storesToDisk: Bool = true
}

public class BookmarkStore: Store {
	let itemCount: Int = 10
}

public struct Bookmark {
	enum Group {
		case Tech
		case News
	}
	
	private let store = {
		return BookmarkStore()
	}()
	
	let title: String?
	let url: NSURL
	let keywords: [String]
	let group: Group
}

let aBookmark = Bookmark(title: "Appventure", url: NSURL(string: "appventure.me")!, keywords: ["Swift", "iOS", "OSX"], group: .Tech)

let aMirror = Mirror(reflecting: aBookmark)
print(aMirror)
// prints : Mirror for Bookmark

print(aMirror.children)
print(aMirror.displayStyle == .Some(.Struct))
print(aMirror.subjectType)
print(aMirror.superclassMirror())

