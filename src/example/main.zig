const uart = @import("klib").uart;

pub export fn example_main() noreturn {
    uart.puts("Hello, OS!\n");

    while (true) {}
}
