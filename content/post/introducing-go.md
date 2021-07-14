---
title: "WIP: Introducing Go"
date: 2019-05-18T21:19:38+08:00
lastmod: 2019-05-18T21:19:38+08:00
draft: true
keywords: []
description: ""
tags: ["Go", "Book", "O'Reilly", "Caleb Doxsey"]
categories: ["读书笔记"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

这两天在看 ***Modern Vim***，发现这本书很适合跟着做，书看完了，你也有一个基本可用的 Vim 了。然而昨天连续看了一下午，到吃晚饭的时候感觉有点恶心，就顺手打开别的书，就是这本 ***Introducing Go***。本意是想随便找本书来换换脑子缓解不舒服的感觉，然而这本书写得极简单，而我又有一些 Go 的经验，所以看得极快。等晚饭的空隙看了前半本，睡前继续看，从23点多上床看到凌晨1点不到，就把剩下的部分都看完了。我自问是个看书极慢的人，总是害怕错过一点信息和知识，想不到我也有三四个小时读完一本124页的书的一日，只恨是在深夜读完，不然仰天大笑出门去。

我能读得这么快，一方面是因为我有足够的背景知识——无论是计算机基础知识，还是 Go 相关的知识；另一方面，则说明这本书适合用来入门。我总觉得写入门的书是件吃力不讨好的事情，你既不能假设读者什么都不懂——难道要从数字逻辑电路开始讲起吗；又不能假设读者什么都懂——那还要这本书做什么，直接读文档不好吗？在懂和不懂的 trade off 中，目标读者的数量就变得极有限。另外，step 的设置也要极好地拿捏——太小了，读者觉得太啰嗦；太大了，读者觉得看不懂，就像那个经典的计算机教材的笑话——书上刚讲了1+1=2，后面的习题就是一道特别复杂的微积分。至于术语的介绍、例子的多寡，其实也在 step 的范畴。

我本来想着这本书看完就过了，但是转念一想，其实这本书的笔记也可以作为 Go 入门的提纲。我不知道实际效果如何，但是不妨一写，看是否有人能从中获益。

这本书的结构还是很清晰的，就按照标题来好了。

哦，还有件事情，由于我用的是 macOS，所以假设你用的也是。虽然 OS 并没有太大的影响，不过一些细节也很烦人。遇到问题的话，请自行 Google 咯。

## 1. Getting Started

### Machine Setup

开始学习 Go 之前，需要做些准备。

1. 编辑器：爱用啥用啥。没啥想法的话，试试 Atom[^1]？
2. 终端：Go 是编译语言[^2]，所以需要先把源代码[^4]编译成机器码[^3]才能执行，而这些操作需要在终端中进行（或者由 IDE[^5] 代劳，但是现在先死了这条心吧）
3. 环境：Go 需要一个环境变量[^6]——`GOPATH`。我们一般设置为`~/go`（`home` 目录下的 `go` 目录，不知道为什么书里推荐的是 `home` 目录，不过你开心就好）。
4. Go: 还需要安装这货，就在终端里执行 `brew install go`（需要先装好 homebrew[^7]）

[^1]: [Atom](https://atom.io/)
[^2]: [编译语言](https://www.wikiwand.com/zh-cn/%E7%B7%A8%E8%AD%AF%E8%AA%9E%E8%A8%80)
[^3]: [机器语言](https://www.wikiwand.com/zh-cn/%E6%9C%BA%E5%99%A8%E8%AF%AD%E8%A8%80)
[^4]: [源代码](https://www.wikiwand.com/zh-cn/%E6%BA%90%E4%BB%A3%E7%A0%81)
[^5]: [集成开发环境](https://www.wikiwand.com/zh-cn/%E9%9B%86%E6%88%90%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83)
[^6]: [环境变量](https://www.wikiwand.com/zh-cn/%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F)
[^7]: [Homebrew](https://brew.sh/)

### Your First Program

做好了上述准备，接下来就是传统节目——写 Hello World[^8]。代码我就不贴了，有用的就5行。将代码保存到 `$GOPATH/src/` 下的某个目录中，命名为 `main.go`，然后在终端中（处于该目录下）执行 `go run main.go`，你就可以在屏幕中看到 **Hello, World** 了。如果没有看到的话，从头开始检查吧：Go 是否安装好、代码是否抄错了、路径对不对……反正记住一句话：机器永远是对的。

前面说到 Go 是编译语言，那为什么输入 `go run` 就能执行呢？因为它其实完成了这一系列的操作：它先接收一系列文件作为参数（这些文件用逗号`,`分隔），然后把它们编译成可执行文件（这个文件存放在某个临时目录中，而非当前的目录），再执行这个文件。

[^8]: [Hello World](https://www.wikiwand.com/zh-cn/Hello_World)

### How to Read a Go Program

我觉得这部分对于新手来说特别重要，就像是小时候学习加减乘除一样，虽然很基础，却也不可或缺。

第一行是**包的声明**，指明当前文件归属于哪个包。Go 中包分两类，一类是库，一类是可执行的，后者的包名都是 `main`。

接下来是**导入**需要用到的包，这些包都是库。这些包的名称用双引号包裹（用双引号包裹的有个专有的名称，叫 string literal）。

Go 中**注释**有两种格式，和 C/C++ 一样，一种是以 `//` 开始，从此到行末都是注释；另一种则是用 `/*` 和 `*/` 包裹，里面的内容都是注释，可以包括多行。

再下面是**函数的声明**。函数有输入、输出和函数体，其中输入和输出为可选。函数以关键词 `func` 开始，后面是函数的名称，再跟上0个或多个参数（这些参数作为函数的输入，以小括号包裹），后面是返回值的类型，最后是用大括号包裹的函数体。`main` 这个函数比较特殊，因为执行的时候，这个函数会被调用。使用库函数的方式是包名和函数名以 `<package>.<Function>` 的方式组合，然后传入所需的参数。库函数的文档，可以通过 `go doc <package> <Function>` 的方式查阅（`godoc` 已经废弃了）。

### Exercises

1. **空白符**有空格、新行和 Tab 等字符。
2. **注释**会被编译器忽略，作用是提高代码的可读性。注释的两种方式就不再赘述了。
3. 库的包名就是我们导入时用双引号包裹的字符串，所以 `fmt` 这个包的第一行就会是 `package fmt`。
4. 对于任意的库函数，我们总是以 `<package>.<Function>` 的形式调用，其中函数的首字母要大写，以及别忘了在函数名后面加上小括号，哪怕没有传入的参数。
5. 把示例的代码中 `Hello, World` 改成 `Hello, my name is XXX` 就好。

## 2. Types

数据的类型有几个用途，不外乎是：

* 分类
* 描述可以进行的操作
* 定义存储的方式

类型（type）和标识（token）有些不同。以小狗举例。有只小狗叫阿花，那么“阿花”就是标识（一个具体的实例），而小狗是类型（通用的概念）。小狗作为类型，描述了一系列狗都会有的属性，比如4条腿、会叫等。

Go 是静态类型语言，所以变量都会有类型而且不可更改。Go 有一些内建的类型，比如数值、字符串、布尔等。

### Numbers

Go 中的数值分为整数和浮点数两类，简单来说，前者没有小数点，后者有。

整数都有大小，比如一个4位的整数最大是15（`1111`）。整数可以分为无符号整数（`uint`）和有符号整数（`int`），前者只能表示正整数（还有0），后者还能表示负整数。大小相同的情况下，无符号整数能表示的最大值要大一些。说到大小，两种整数都有8、16、32、64这4种大小，即一个整数使用多少位来表示。除此之外，还有两个别名：`byte` 和 `rune`，其中 `byte` 和 `uint8` 一样，而 `rune` 和 `int32` 一样。另外，还有3个和机器有关的类型：`uint`、`int` 和 `uintptr`。这三个类型都没有明确指定大小，依赖于机器的架构来确定，比如32位的机器中 `int` 为 `int32`，再64位的机器中则是 `int64`。我们在实际使用中，一般就用 `int` 而非 `int32` 或 `int64`。

浮点数也有大小的区分：`float32` 和 `float64`，有时候也称为单精度和双精度，我们一般使用后者。学过《计算机组成与系统结构》的话，大概就知道浮点数是如何表示的，因此也就知道，浮点数是不精确的，所以在涉及浮点数的数值计算的部分不要使用相等来判断；此外，大小越大，浮点数就越精确。

除了整数和浮点数，还有一些和数值有关的内容，比如非数 `NaN`、正负无穷、复数等。复数有两类，分别是 `complex64` 和 `complex128`。

数值可以进行的算术操作有5种，分别是：加、减、乘、除、取余。除此以外，`math` 这个包提供了更多的操作。

### Strings

在 C/C++ 中，一般用字符的数组来表示字符串。逻辑上是这样，但是使用有诸多不便。Go 把字符串作为一种内建的类型，就方便了许多。在 Go 中，字符串是一些 bytes，对于 ASCII 码，一个字符对应了一个 byte；但是对于像中文这样的字符，一个字符对应多个 bytes（对应一个 rune）。

字符串有两种构建 string literal 的方式，一种是用双引号，一种是用反引号，两者并无太多分别，只是有些限制。双引号只能包裹最多一行的内容，但是支持转义；反引号可以包裹多行，但是不支持转义。

字符串常见的操作有：计算长度、取某位的字符、拼接等。内建的 `len()` 函数可以返回一个字符串的长度。可以像数组一样，直接在 string literal 的后面加上 `[n]` 来取出它的第 n-1 位的字符（类型是 byte）。另外，Go 中的字符串不可修改，所以和数组不同的是，只能读取，不能写入。拼接使用的是数值中的加这个操作符，毕竟对于字符串而言，加并没有意义。

### Booleans

布尔值是一种特殊的1位整数类型，用来表示真或假，就像电路开关的开与闭。布尔值支持3种逻辑运算，分别是：与、或、非，对应的符号则是：`&&`、`||`、`!`。非是单目运算符，即只需要一个操作数。在 Go 中，布尔类型的两个关键词都是小写，一个是 `true`，一个是 `false`。我们一般会用真值表[^9]来判断与或非的结果。

[^9]: [真值表](https://www.wikiwand.com/zh/%E7%9C%9F%E5%80%BC%E8%A1%A8)

### Exercises

1. 我们一般用的是十进制来表示一个数，而计算机则是用二进制。
2. 最大的8位二进制数是`11111111`，转换成十进制则是255。
3. 直接把这两个 number literals 相乘就好了
4. 字符串是字符的序列，长度的计算使用内建的 `len()` 函数。
5. 画个真值表就很清楚了。根据两个或把这个表达式拆分成3部分，其中第一部分的结果为假，第二部分的结果为假，第三部分的结果为真，所以整个表达式的最终结果为真。

## 3. Variables

## 4. Control Structures

## 5. Arrays, Slices, and Maps

## 6. Functions

## 7. Structs and Interfaces

## 8. Packages

## 9. Testing

## 10. Concurrency

## 11. Next Steps
