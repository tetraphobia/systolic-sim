const Sender = @import("sender.zig").Sender;
const Receiver = @import("receiver.zig").Receiver;
const std = @import("std");

pub const Core = struct {
    id: u64,
    registers: [32]u8,
    sender: *Sender,
    receiver: *Receiver,

    pub fn create(allocator: std.mem.Allocator, id: u64) !*Core {
        const core = try allocator.create(Core);
        const sender = try Sender.create(allocator, core);
        const receiver = try Receiver.create(allocator, sender);

        core.* = Core{
            .id = id,
            .registers = [_]u8{0} ** 32,
            .sender = sender,
            .receiver = receiver,
        };

        return core;
    }
};
