#![no_std]

use core::panic::PanicInfo;

mod module;

#[no_mangle]
pub extern "C" fn kmain() -> () {
   module::lol(); 
}

#[panic_handler]
fn abort(_info: &PanicInfo) -> ! {
    loop {}
}
