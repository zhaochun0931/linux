package main

import "fmt"

func main() {
	fmt.Printf("hello, world\n")
}





// ✅ Full explanation
// package main


// Every Go file begins with a package declaration.

// main is a special package:
// A Go program starts execution from main.main().


// ✅
// import "fmt"


// This imports Go’s standard fmt package.

// fmt provides formatted I/O functions like Println, Printf, etc.


// ✅
// func main() {


// Defines the main function, the entry point of the Go program.

// When you run go run file.go, Go looks for this function to start execution.

//     fmt.Printf("hello, world\n")
// }


// Calls fmt.Printf to print formatted text to the screen.

// "hello, world\n" prints hello, world followed by a newline (\n).
