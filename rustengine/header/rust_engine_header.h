#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct RustByteSlice {
  uint8_t *bytes;
  size_t len;
} RustByteSlice;

void rust_destroy_byte_slice(struct RustByteSlice *slice);

struct RustByteSlice *rust_parse_simple_status_json(const uint8_t *bytes, size_t len);
