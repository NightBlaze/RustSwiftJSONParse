mod simple_status_json;
mod big_json;

#[repr(C)]
#[derive(Debug)]
pub struct RustByteSlice {
    pub bytes: *mut u8,
    pub len: libc::size_t,
}

impl RustByteSlice {
    pub fn empty() -> RustByteSlice {
        RustByteSlice { bytes: std::ptr::null_mut(), len: 0 }
    }

    pub fn new(data: Vec<u8>) -> RustByteSlice {
        let mut data = data;
        let result = RustByteSlice {
            bytes: data.as_mut_ptr(),
            len: data.len()
        };
        std::mem::forget(data);
        result
    }
}

#[no_mangle]
pub unsafe extern "C" fn rust_destroy_byte_slice(slice: *mut RustByteSlice) {
    if slice.is_null() {
        println!("got null bytes. do nothing.");
        return
    }
    unsafe {
        let slice = Box::from_raw(slice);
        let data = Box::from_raw(slice.bytes);
        drop(data);
        drop(slice);
    }
}
