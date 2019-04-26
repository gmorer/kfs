#![no_std]

use core::panic::PanicInfo;

mod vga_buffer;

#[no_mangle]
pub extern "C" fn kmain() -> () {
    vga_buffer::print_something();
   loop {}
}

#[panic_handler]
fn panic_fmt(_info: &PanicInfo) -> ! {
    loop {}
}
