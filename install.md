# HelloOS Rust版本安装说明

## 编译

```bash
make all
```

## 运行

使用QEMU运行：

```bash
qemu-system-i386 -drive format=raw,file=HelloOS_Rust.bin -m 512M
```

## 与C版本的区别

1. 使用Rust语言重写，采用`no_std`环境
2. 使用Rust的内存安全特性
3. 模块化设计，将VGA输出功能分离到独立模块
4. 使用Rust的错误处理机制（panic handler）
5. 保持与原C版本相同的功能和输出效果