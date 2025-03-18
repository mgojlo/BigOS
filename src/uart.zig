const uart: *volatile u8 = @ptrFromInt(0x10000000);

pub fn putc(c: u8) void {
    uart.* = c;
}

pub fn puts(s: []const u8) void {
    for (s) |c| {
        putc(c);
    }
}
