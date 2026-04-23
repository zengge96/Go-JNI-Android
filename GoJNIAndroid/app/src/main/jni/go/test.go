package main

import "C"

//export goHelloWorld
func goHelloWorld() *C.char {
    return C.CString("Hello from Go! 😊")
}

//export goInteger
func goInteger() C.int {
    return 24
}

func main() {}
