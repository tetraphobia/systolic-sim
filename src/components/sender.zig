const Core = @import("core.zig").Core;
const Receiver = @import("receiver.zig").Receiver;

pub const Sender = struct {
    core: *Core,

    send: bool,

    rd_in: u5,
    rs1_in: u32,
    rs2_in: u5,

    rd_out: u5,
    rs1_out: u32,

    neighbors: [4]?*Receiver,

    pub fn create(core: *Core) *Sender {
        var sender = Sender{
            .core = core,
            .send = false,
            .rd_in = 0,
            .rs1_in = 0,
            .rs2_in = 0,
            .rd_out = 0,
            .rs1_out = 0,
            .neighbors = [4]?*Receiver{ null, null, null, null },
        };

        return &sender;
    }

    pub fn set_neighbor(self: *const Sender, i: u32, receiver: *Receiver) !void {
        self.neighbors[i] = receiver;
    }

    pub fn get_neighbor(self: *const Sender, i: u32) ?*Receiver {
        if (i >= self.neighbors.len) return null;
        return self.neighbors[i];
    }

    pub fn get_neighbor_by_id(self: *const Sender, id: u32) ?*Receiver {
        for (0..self.neighbors.len) |i| {
            const r: *Receiver = self.neighbors[i];
            if (r.sender.core.id == id) {
                return r;
            }
        }

        return null;
    }
};
