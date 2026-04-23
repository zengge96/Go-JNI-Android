package main

import "C"
import (
	"fmt"
	"runtime"
	"time"
)

//export goHelloWorld
func goHelloWorld() *C.char {
	info := fmt.Sprintf(`Android Go JNI Demo 🎉

系统信息:
- Go 版本: %s
- Go 架构: %s
- 操作系统: %s
- 运行时: %s
- 时间: %s

编译时间: %s`,
		runtime.Version(),
		runtime.GOARCH,
		runtime.GOOS,
		runtime.Compiler,
		time.Now().Format("2006-01-02 15:04:05"),
		time.Now().Format("2006-01-02 15:04:05"),
	)
	return C.CString(info)
}

//export goInteger
func goInteger() C.int {
	return 42
}

//export goGetSystemInfo
func goGetSystemInfo() *C.char {
	info := fmt.Sprintf(`CPU 核心数: %d
Go 线程数: %d
内存状态: %s
调度器数量: %d`,
		runtime.NumCPU(),
		runtime.GOMAXPROCS(0),
		runtime.MemProfileRate,
		1,
	)
	return C.CString(info)
}

func main() {}
