// Playing with hash tables (map keyword, one of the 25s) A map holds a set of
// key/value pairs and provides constant time operations to store, retrive, or
// test for an item in the set https://blog.golang.org/go-maps-in-action
package main

import (
	"fmt"
	"os"
)

func main() {
	// KeyType may be any type that is comparable (more on this later), and
	// ValueType may be any type at all, including another map!
	var m1, m2 map[string]int

	// Map types are reference types, like pointers or slices, and so the value
	// of m above is nil; it doesn't point to an initialized map. To initialize
	// a map, use the built in make function. The make function allocates and
	// initializes a hash map data structure and returns a map value that
	// points to it.
	m1 = make(map[string]int)

	m1["uno"] = 1
	m1["dos"] = 2
	m1["tres"] = 3

	// an identical effect is the following initialization
	m2 = map[string]int{}

	m2["uno"] = 11
	m2["dos"] = 22
	m2["tres"] = 33

	// or even with initial values
	m3 := map[string]int{
		"uno":    111,
		"dos":    222,
		"tres":   333,
		"cuatro": 444,
	}

	fmt.Println("len of map1: ", len(m1))
	fmt.Printf("len of map2: %d items\n", len(m2))
	fmt.Fprintf(os.Stdout, "len of map3: %d\n", len(m3))

	// A two-value assignment tests for the existence of a key: In this
	// statement, the first value (v) is assigned the value stored under the
	// key "uno". If that key doesn't exist, i is the value type's zero value
	// (0). The second value (ok) is a bool that is true if the key exists in
	// the map, and false if not.
	v, ok := m1["uno"]
	if ok {
		fmt.Printf("The value: %d is present\n", v)
	}

	// To test for a key without retrieving the value, use the blank identifier
	_, exists := m1["uno"]
	if exists {
		fmt.Println("The value is present")
	}

	// The built in delete function removes an entry from the map:
	delete(m3, "cuatro")

	// To iterate over the contents of a map, use the range keyword: When
	// iterating over a map with a range loop, the iteration order is not
	// specified and is not guaranteed to be the same from one iteration to the
	// next.
	for key, value := range m3 {
		fmt.Println("Key:", key, "Value:", value)

	}

	// Note: Maps are not safe for concurrent use: it's not defined what
	// happens when you read and write to them simultaneously. If you need to
	// read from and write to a map from concurrently executing goroutines, the
	// accesses must be mediated by some kind of synchronization mechanism.
	// Take a look to hash-table-thread-safe.go example.
}
