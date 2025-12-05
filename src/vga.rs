// VGA文本模式输出模块

// VGA缓冲区地址
const VGA_BUFFER: usize = 0xb8000;

// 写入字符串到VGA缓冲区
pub fn write_string(string: &str) {
    let vga_buffer = VGA_BUFFER as *mut u8;
    
    for (i, &byte) in string.as_bytes().iter().enumerate() {
        unsafe {
            // 写入字符
            *vga_buffer.add(i * 2) = byte;
            // 写入属性（颜色等），这里使用默认的白色字符
            *vga_buffer.add(i * 2 + 1) = 0x07;
        }
    }
}

// 简单的printf实现，仅支持字符串输出
pub fn printf(fmt: &str) {
    write_string(fmt);
}