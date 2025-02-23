
## 获取命令行参数

目前`moonbitlang/x`库已经提供了获取命令行参数的API`@moonbitlang/x/sys.get_cli_args`,它的返回值是一个装有所有命令行参数的数组，不过在不同后端下其行为会有些许变化，此处暂时选用native后端。在native后端下，命令行参数数组的第一个元素是MoonBit程序编译出的可执行文件的路径，后续元素都是用户自己传递的命令行参数。


一般来说，处理命令行参数用一些专门的解析库会比较方便(MoonBit现在也有这样的库)，但对于我们这个比较简单的diff程序，使用MoonBit最近新增的is运算符和guard语句结合就可以轻松处理了。

```rust
guard args is [executable, oldfile, newfile] else {
  println("wrong arguments: \{args}")
}
```

## 读取文件

`moonbitlang/x`下的`fs`包提供了一些常见的文件IO函数，在这里直接使用`read_file_to_string`即可，它的文件编码参数`encoding`的默认值是**utf8**。

`read_file_to_string`在读取文件失败的情况下(很常见的一种情况是参数里的文件名不小心打错了，或者没有文件的读权限)会抛出`Error`, 为简化错误处理，此处直接将读取失败的文件名打印出来然后调用`panic()`。

```rust
  let old = 
    try {
      (@diff.lines(@fs.read_file_to_string!(oldfile)))[:]
    } catch {
      _ => {
        println("\{executable}: failed to load file \{oldfile}")
        panic()
      }
    }
  let new = 
    try {
      (@diff.lines(@fs.read_file_to_string!(newfile)))[:]
    } catch {
      _ => {
        println("\{executable}: failed to load file \{newfile}")
        panic()
      }
    }
```

## 渲染

在终端中使用一些特定的控制字符可以让输出的文本带有颜色，尝试运行这段MoonBit代码

```rust
test {
  println("\u001B[35m Hello MoonBit \u001B[39m")
}
```

它会输出紫色的`Hello MoonBit`.

虽然不使用其他外部依赖也能达到输出彩色文本的效果，但是手动拼接字符串比较乏味，而且很容易出错，好在MoonBit社区已经有可用的终端渲染库：

在输出diff时，常见的渲染选项是将插入渲染为绿色，删除渲染为红色，让我们分别新建两个名叫`ins`和`del`的chalk对象,并分别设置颜色

```rust
  let ins = @chalk.chalk().color(Green)
  let del = @chalk.chalk().color(Red)
```

在输出diff之前，最好也提醒一下用户所比较的是哪两个文件，文件名为达到醒目的效果应该加粗输出。

```rust
  let title = @chalk.chalk().modifier(Bold) // 加粗
  println("") // 留空一行
  println(title.render("--- \{oldfile}"))
  println(title.render("+++ \{newfile}"))
```

然后遍历diff算法计算出的编辑序列

```rust
  for edit in result.iter() {
    match edit {
      Insert(_) => println(ins.render(@diff.pprint_edit(edit)))
      Delete(_) => println(del.render(@diff.pprint_edit(edit)))
      Equal(_) => println(@diff.pprint_edit(edit))
    }
  }
```

## 试试看

在项目根目录下执行: `moon run src/main --target native tests/old1.txt tests/new1.txt`

```diff
--- tests/old1.txt
+++ tests/new1.txt
     1    1    aaaaaa
     2    2    bbb
     3    3    cccccccccc
+         4    dddddd
```