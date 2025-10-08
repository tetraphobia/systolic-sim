const Sender = @import("sender.zig").Sender;
const Receiver = @import("receiver.zig").Receiver;
const std = @import("std");

pub const Core = struct {
    id: u64,
    registers: [32]u8,
    sender: ?*Sender,
    receiver: ?*Receiver,
    pub fn create(id: u64) *Core {
        var core = Core{
            .id = id,
            .registers = [_]u8{0} ** 32,
            .sender = null,
            .receiver = null,
        };

        const sender = Sender.create(&core);
        const receiver = Receiver.create(sender);
        core.sender = sender;
        core.receiver = receiver;

        return &core;
    }
};
