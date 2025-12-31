---
title: "Go Code Review Comments"
date: 2019-06-05T22:16:36+08:00
draft: false
description: ""
tags: ["Go", "Code Review"]
categories: ["Go"]
---

Go 写了这么久，却一直没有把 [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments) 完整地看一遍。今天看了一篇 Go 的文章，里面提到了它，索性就仔细一读。

一开头就声明，这只是一份常见错误的列表，而非综合的风格指南，亦可作为 [Effective Go](https://golang.org/doc/effective_go.html) 的一份补充。

## Gofmt

建议使用 `gofmt` 来修复一些风格上的问题。像 vs code 之类的编辑器在安装 Go 的插件后，设置中会让你选择何时格式化代码，一般在保存时就够了。我使用的是 `goimports`，它除了能胜任 `gofmt` 的工作之外，还能自动添加和删除导入的包，并分类排序。

## Comment Sentences

注释应当是完整的句子，以被注释的对象名开始，以句号结束。

## Contexts

Go 一般显式地在整个函数调用链中传递 Contexts，并作为第一个参数。除此之外，不要在结构体（struct）中添加 Context 类型的元素，而是给该结构体的每一个方法添加 `ctx` 参数。

## Copying

从其他包中复制结构体的时候，要小心避免预期外的别名。如果某个类型的方法其 receiver 为该类型的指针，就不要复制该类型的值。

## Declaring Empty Slices

声明空的 slice 时，更推荐使用 `var` 而非 `:=` 的方式，例子如下：

```go
// prefer
var t []string
// not prefer
t := []string{}
```

两种方式得到的 slice 功能相同，有相同的长度和容量，并且都为0，区别在于：第一种方式得到的是 nil slice，而第二种方式得到的是长度为0的非 nil slice。nil slice 是更推荐的风格。这个问题之前叶古和我说过几次，说不要写第二种方式这样的代码，会让人觉得 Go 没学好。

## Crypto Rand

不要用 `math/rand` 这个包来生成 keys，即使是用完就丢的那种，因为 unseeded 会使得生成器完全可预测。应该使用 `crypto/rand` 这个包。

## Doc Comments

所有顶层的导出名称（常量、变量、函数、方法、结构体等）都应该有文档注释，甚至非显然的未导出类型和函数也应该有。

## Don't Panic

对于普通错误的处理，不要使用 panic，而是使用 error 和多返回值。（我在写一些脚本的时候，倒是蛮喜欢直接 panic 的）

## Error Strings

错误信息不应该大写或以标点符号结束，除非如 URL 这种名词或者 ID 这样的缩写。错误信息一般不单独打印，而是放在上下文中，比如：

```go
err := fmt.Errorf("something bad")
log.Printf("Reading %s: %v", filename, err)
```

如果把 `something` 的首字母大写，那么 log 的输出就会显得奇怪。

## Examples

添加新包的时候，在包中添加例子，比如一个可运行的示例，或者一个简单的测试，用来演示完整的调用序列。

## Goroutine Lifetimes

使用 goroutine 的时候，明确它们何时或是否退出。阻塞 channel 的接收或发送会导致 goroutine 泄漏，即使 channels 不可达，GC 也不会终止一个 goroutine。除了泄漏，还有其他一些难以诊断的问题。向已关闭的 channels 发送会导致 panic，修改仍在使用的输入会导致数据竞争……

建议就是，尽量保持并发的代码简洁——goroutine 的生命周期是明显的。实在做不到的话，说明何时以及为何 goroutines 退出。

## Handle Errors

不要抛弃错误。假如函数返回了一个错误，那就检查那个错误，看函数是否正常运行了。总的来说，要么处理错误，要么把错误返回给上一层，要么 panic。

## Imports

除非导入的包名冲突，否则不要重命名导入，而好的包名应该不需要重命名导入。假如不得不重命名的话，选择 the most local or project-specific 的导入进行重命名。

导入信息按组分类，不同的组之间有空行分隔，标准库在第一组。我有 `goimports` 帮我搞定 import 相关的事情，所以并不太关心这些。

## ImportBlank

有些包导入，却并不使用任何导出的内容，只是为了其副作用，比如 `import _ "pkg"`。这种操作只在 `main` 包或测试中进行。

## Import Dot

不要使用 `import . "foo"` 这种方式，因为这会混淆一个结构或函数究竟是当前包的还是导入包的。例外的情况是避免循环导入。

## In-Band Errors

在 C/C++ 中，函数返回像 -1 或 null 这样的特殊值来表示错误。Go 就不用这么节省了，在返回结果的时候返回额外的一个值来表示返回结果是否有效，而这个额外的返回值可以是错误类型，也可以是布尔类型，并且应该是最后一个返回值。

```go
// Lookup returns the value for key or ok=false if there is no mapping for key.
func Lookup(key string) (value string, ok bool)
```

假如没有最后的返回值，有可能会出现编译错误。现在有了它，代码变得更健壮，可读性也更高。当然，无论导出还是未导出，都推荐这么做。

## Indent Error Flow

简单来说，为了使代码更简洁易读，先处理错误，同时避免使用 `else`。举个例子：

```go
// handle error first
if err != nil {
  // error handling
  return // or continue, etc.
}
// normal code
```

另外，假如 `if` 里面有声明语句的话，就单独放一行。

## Initialisms

Initialisms 和缩写的名称一般全大写，比如 URL 和 ID。生成的代码会无视这条规则，手写的代码要有更高的要求。

## Interfaces

Go 中的接口一般归属于使用它的包，而非实现它的包。实现接口的包应该返回具体的类型，比如指针或结构体，如此，给实现添加新方法的时候就无需重构了。

不要在API的实现侧定义接口，而是设计API使得它能够使用公共API的实现来测试（并不是很懂这句话）。

在使用之前不要定义接口，因为在没有实际例子的情况下很难判断一个接口是否是必须的，更别说这个接口应该包含哪些方法了。

## Line Length

Go 中没有严格的单行长度限制，但是应该避免过长。但也不要为了断行而断行，尤其是牺牲了可读性时。一行如果过长，一般变量名会比较长，所以把这些长变量名改短就好了。

同样的道理，一个函数不应该超过几行，这也没有定论。

我在 Vim 中设置了80个字符的提示，也尽量避免超过它，不过还是偶尔会有例外。

## Mixed Caps

这个就看例子吧。未导出的常量应该叫 `maxLength` 而非 `MaxLength` 或 `MAX_LENGTH`。

## Named Result Parameters

对返回值进行命名，推荐的场景为：

* 如果函数返回两三个同类型的变量；或
* 如果某个返回值的意义从上下文中并不够明确

假如只是为了避免在函数内部声明一个变量，那就不划算了，以不必要的冗余为代价换来了丁点儿的简略。

如果一个函数有些规模，最好显式地返回变量。对返回值进行命名后，可以直接返回，但还是那句话，仅仅为了可以直接返回而命名返回值是不划算的。

在某些情形中，你需要通过命名一个返回值来在延迟的闭包中将其改变，这倒是不错。

## Naked Returns

直接一个 `return`。假如函数的返回值被命名了，那么可以不用显式地返回它们。

## Package Comments

包的注释必须在包的声明的附近，且没有空行与之分隔。

```go
// Package math provides basic constants and mathematical functions.
package math
/*
Package template implements data-driven templates for generating textual
output such as HTML.
....
*/
package template
```

以上是两种包注释的方式， 和普通的注释一样。对于 `main` 这个包，你还可以用其他的注释风格。另外，小写字母开头还是不行。

## Package Names

由于在其他包中使用某个包的函数或变量，都会在前面加上这个包的包名，所以就不需要在这些函数或变量上再写上包名以示区别了。比如 `chubby.File` 就够了，不需要声明成 `chubby.ChubbyFile`。

另外，尽量避免一些无意义的包名，比如 `util`、`common`等（我倒是蛮常创建这样的包）。

## Pass Values

不要只为了节省几个比特就在函数中传递指针作为参数（太小家子气了）。常见的例子有传递一个字符串的指针和接口的指针，它们的值有固定的大小，直接传值就好了。推荐的用法是对于大的结构体，或者是可能会变大的。

## Receiver Names

方法的接收者的名称应该能反映出它的身份，一般是它的类型的前一两个字母缩写。不要用类似 `me`、`this` 这种宽泛的名称。需要注意的是，同类型的方法的接收者应该同名，不要一个方法的接收者叫 `c`，另一个方法中接收者叫 `cl`。

## Receiver Type

方法的接收者是值还是指针是个好问题，我之前也困扰了很久。简单的做法是，如果不确定，那就用指针。下面是一些 guidelines:

* 如果接收者是 map、func、chan，不要用指针
* 如果接收者是 slice 并且方法不改变它的长度或对它重新分配，也不要用指针
* 如果方法需要修改接收者，必须用指针
* 如果接收者是结构体，其包含了同步的 fields，必须用指针来避免复制
* 如果接收者是一个大的结构体或数组，指针会更高效
* 方法是否会在被调用时并发地修改接收者？如果变化需要反映在原始的接收者上，那么必须用指针
* 如果接收者是结构体、数组、slice 或任何可能被改变的指针，倾向于使用指针
* 如果接收者是小的数组或结构体（只有一个 element），并且没有可变的 fields 或指针，甚至是基本类型，那么推荐用值
* 最后，困惑的时候，无脑用指针

## Synchronous Functions

比起异步函数，更倾向于使用同步函数。所谓同步函数，就是那些在返回之前先返回结果或结束调用等的函数。

同步函数限制 goroutine 于一个调用中，使得更容易推断其生命周期以及避免泄漏和数据竞争等。测试也更简单，调用者可以传递输入然后检查输出，不需要投票或同步。

## Useful Test Failures

测试失败的时候，应该给出有帮助的消息，指明到底是哪里错了，失败的输入是什么，实际输出和预期输出又是什么。

```go
if got != tt.want {
    t.Errorf("Foo(%q) = %d; want %d", tt.in, got, tt.want) // or Fatalf, if test can't test anything more past this point
}
```

一个典型的 Go 的测试失败的写法如上所示，同时注意顺序是实际输出不同于预期输出。

另一种常用来消除测试失败歧义的方式是将其用不同的测试函数包裹。

```go
func TestSingleValue(t *testing.T) { testHelper(t, []int{80}) }
func TestNoValues(t *testing.T)    { testHelper(t, []int{}) }
```

## Variable Names

Go 中变量名宜短不宜长，尤其是对于局部变量，比如用 `i` 胜过用 `sliceIndex`。

基本的规则是：一个名称从声明到使用的距离越远，这个名称就必须越有内涵。因此，对于一个方法的接收者，一两个字母也就够了，常见的变量如循环的下标和值可以是单个字母，而全局变量则需要更多的字母。

我之前看一些文章说变量名的命名要有意义，想着是不是应该把 for loop 中的下标也改成长而自描述的写法，然而刷题的时候总是偷懒继续用 `i`、`j` 等，看到这个，觉得轻松不少。
