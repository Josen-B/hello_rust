#![no_std] // 不链接Rust标准库

pub mod vga;

/// 这个函数在panic时被调用
#[cfg(not(test))]
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    vga::_strwrite("Kernel panic!");
    loop {}
}

/// 内核入口点
#[no_mangle] // 不修改函数名
pub extern "C" fn rust_main() -> ! {
    // 初始化VGA Writer
    vga::init_writer();
    
    // 使用简单的VGA输出函数
    vga::_strwrite("Hello OS from Rust!");
    
    // 使用更高级的println宏
    println!("\nHello from Rust x86_64 OS kernel!");
    println!("This is a 64-bit operating system written in Rust.");
    
    // 挂起系统
    loop {
        x86_64::instructions::hlt();
    }
}