const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .riscv64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    const klib_mod = b.createModule(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    const example_kernel_mod = b.createModule(.{
        .root_source_file = b.path("src/example/main.zig"),
        .target = target,
        .optimize = optimize,
        .code_model = .medium,
    });
    example_kernel_mod.addImport("klib", klib_mod);

    const example_kernel_exe = b.addExecutable(.{
        .name = "example",
        .root_module = example_kernel_mod,
    });
    example_kernel_exe.entry = .disabled;
    example_kernel_exe.addAssemblyFile(b.path("src/example/entry.S"));
    example_kernel_exe.setLinkerScript(b.path("src/example/linker.ld"));

    b.installArtifact(example_kernel_exe);

    const qemu_cmd = b.addSystemCommand(&.{"qemu-system-riscv64"});
    qemu_cmd.addArgs(&.{
        "-machine", "virt",
        "-bios",    "none",
        "-kernel",  "zig-out/bin/example",
        "-serial",  "mon:stdio",
        "-device",  "VGA",
    });

    qemu_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&qemu_cmd.step);
}
