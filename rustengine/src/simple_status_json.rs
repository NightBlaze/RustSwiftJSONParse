use crate::RustByteSlice;
use serde::Deserialize;
use protobuf::Message;
include!(concat!(env!("OUT_DIR"), "/protos/mod.rs"));

use simple_status::SimpleStatus;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct SimpleStatusDTO {
    status: String,
}

#[no_mangle]
pub unsafe extern "C" fn rust_parse_simple_status_json(bytes: *const u8, len: libc::size_t) -> *mut RustByteSlice {
    if bytes.is_null() {
        return std::ptr::null_mut();
    }
    let slice = unsafe { std::slice::from_raw_parts(bytes, len) };
    let result: Result<SimpleStatusDTO, serde_json::Error> = serde_json::from_slice(slice);
    match result {
        Ok(dto) => {
            let mut out_dto = SimpleStatus::new();
            out_dto.status = dto.status;
            match out_dto.write_to_bytes() {
                Ok(out_bytes) => {
                    let result = Box::new(RustByteSlice::new(out_bytes));
                    Box::into_raw(result)
                },
                Err(e) => {
                    println!("error marshal into protobuf: {e}");
                    std::ptr::null_mut()
                }
            }
        },
        Err(e) => {
            println!("error parse json: {e}");
            std::ptr::null_mut()
        },
    }
}