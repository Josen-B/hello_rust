#![no_std]
#![no_main]
#![feature(lang_items)]
#![feature(core_intrinsics)]

use core::panic::PanicInfo;
use core::intrinsics;

mod vga;

#[no_mangle]
pub extern "C" fn main() -> ! {
    vga::printf("Hello OS from Rust!");
    
    // 无限循环，防止函数返回
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern "C" fn eh_personality() {
    loop {}
}