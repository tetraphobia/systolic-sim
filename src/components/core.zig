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

    pub fn get_hwid(self: *const Core) u64 {
        return self.id;
    }

    pub fn to_string(self: *const Core) []const u8 {
        return "[hwid:" + self.id + ", val:" + self.sender.rs1 + "]";
    }
};
