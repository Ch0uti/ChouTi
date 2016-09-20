One way to call async task in sync way:

```swift
func syncTask() -> Int {
	var result: Int?
  
	asyncTask(completion: { num in
		result = num
	})
	
	while result == nil {
		continue
	}

	return result!
}

func asyncTask(completion: @escaping (Int) -> Void) {
	DispatchQueue(label: "com.honghaoz.async").async {
		sleep(5)
		completion(10)
	}
}
```
