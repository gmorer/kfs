#![no_std]

#![feature(lang_items)]
use core::panic::PanicInfo;

mod vga_buffer;

#[no_mangle]
pub extern "C" fn kmain() -> () {
    vga_buffer::print_something();
   loop {}
}

#[panic_handler]
fn abort(_info: &PanicInfo) -> ! {
    loop {}
}

#[lang = "eh_personality"]
extern fn eh_personality() {}
