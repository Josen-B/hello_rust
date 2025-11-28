# Rust x86_64 Hello OS

这是一个基于Rust语言的x86_64架构Hello World操作系统内核，基于原始的C语言版本改写。

## 项目结构

```
HelloOS_Rust/
├── Cargo.toml          # Rust项目配置文件
├── Makefile            # 构建脚本
├── README.md           # 项目说明
├── linker.ld           # x86_64链接器脚本
└── src/
    ├── main.rs         # 内核主函数
    ├── entry.asm       # 汇编入口点
    └── vga.rs          # VGA文本模式输出模块
```

## 功能特性

- x86_64架构支持
- GRUB/GRUB2多引导协议兼容
- 64位长模式切换
- VGA文本模式输出
- Rust语言实现，内存安全
- 无标准库环境(no_std)

## 构建方法

确保已安装以下工具：
- Rust nightly工具链
- NASM汇编器
- GNU ld链接器
- GNU make

构建步骤：

```bash
# 安装Rust nightly工具链和目标平台
rustup default nightly
rustup target add x86_64-unknown-none

# 构建内核
make all
```

## 运行方法

1. 使用QEMU测试：
```bash
qemu-system-x86_64 -drive format=raw,file=HelloOS_Rust.bin
```

2. 或者使用GRUB引导：
```bash
# 将HelloOS_Rust.bin复制到启动设备
make install
```

## 代码说明

### 汇编入口点(entry.asm)
- 设置GRUB多引导头
- 检测CPU长模式支持
- 配置页表和启用分页
- 切换到64位模式
- 调用Rust主函数

### Rust主函数(main.rs)
- 禁用标准库(no_std)
- 实现panic处理
- 调用VGA输出函数
- 进入无限循环

### VGA输出模块(vga.rs)
- 实现VGA文本模式输出
- 提供print!和println!宏
- 支持颜色输出
- 线程安全的全局Writer

## 与原C版本的差异

1. **架构**: 从32位(x86)升级到64位(x86_64)
2. **语言**: 从C语言改为Rust语言
3. **内存安全**: Rust提供编译时内存安全保证
4. **模块化**: 更好的代码组织和模块化设计
5. **错误处理**: Rust的Result和Option类型提供更好的错误处理

## 作者

彭东 @ 2025.11.28 - Rust版本