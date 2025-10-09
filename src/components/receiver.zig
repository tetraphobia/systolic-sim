const std = @import("std");
const Sender = @import("sender.zig").Sender;

pub const Receiver = struct {
    full: bool,
    passthrough: bool,
    // inbox: AQueueThatIWillWriteLater

    rd_in: u5,
    rs1_in: u8,

    rd_out: u5,
    rs1_out: u8,

    sender: *Sender,
    pub fn create(allocator: std.mem.Allocator, sender: *Sender) !*Receiver {
        const receiver = try allocator.create(Receiver);

        receiver.* = Receiver{
            .full = false,
            .passthrough = false,
            .sender = sender,
            .rd_in = 0,
            .rs1_in = 0,
            .rd_out = 0,
            .rs1_out = 0,
        };

        return receiver;
    }

    pub fn get_hwid(self: *const Receiver) u8 {
        return self.sender.core.id;
    }
};
