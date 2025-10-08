const std = @import("std");
const Core = @import("core.zig").Core;
const Receiver = @import("receiver.zig").Receiver;
const alloc = std.heap.page_allocator;
const expect = std.testing.expect;

pub const Sender = struct {
    /// Core that the Sender belongs to
    core: *Core,
    /// When set to true, sends the value in `rs1` to the core with id `rs2` in register `rd` (Not currently implemented)
    send: bool,
    /// `rd` - target register
    rd: u5,
    /// `rs1` - value
    rs1: u32,
    /// `rs2` - hwid
    rs2: u5,

    neighbors: [4]?*Receiver,

    pub fn create(allocator: std.mem.Allocator, core: *Core) !*Sender {
        const sender = try allocator.create(Sender);
        sender.* = Sender{
            .core = core,
            .send = false,
            .rd = 0,
            .rs1 = 0,
            .rs2 = 0,
            .neighbors = [4]?*Receiver{ null, null, null, null },
        };

        return sender;
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

    /// Calculates the next jump given the target cpu and neighbors
    pub fn next_hop(self: *const Sender) u8 {
        _ = self;

        // The next hop is the shortest path to column alignment.

        // If we're on the same column, the next hop is the shortest path to row alignment.

        return 0;
    }

    /// Gets the hwid of the Core
    pub fn get_hwid(self: *const Sender) u64 {
        return self.core.id;
    }
};

/// Initializes a core with four neighbors for testing.
fn init_test_core(id: u64) !*Core {
    const core: *Core = try Core.create(alloc, id);

    // Init four neighbors
    for (core.sender.neighbors, 1..) |_, i| {
        const n_core: *Core = try Core.create(alloc, i);
        core.sender.neighbors[i - 1] = n_core.receiver;
    }

    return core;
}

/// Test helper function to set the hwids of core neighbors
fn set_neighbor_ids(core: *Core, ids: [4]u64) void {
    for (ids, 0..) |id, i| {
        core.sender.neighbors[i].?.sender.core.id = id;
    }
}

test "next_hop (neighbors: [12, 1, 4, 3], target: 7)" {
    const core: *Core = try init_test_core(0);
    set_neighbor_ids(core, [4]u64{ 12, 1, 4, 3 });

    // Set args for next hop
    var sender: *Sender = core.sender;
    sender.rd = 0;
    sender.rs1 = 1; // Value
    sender.rs2 = 7; // CPU target
    const expected: u16 = 3;
    const actual = sender.next_hop();
    try expect(expected == actual);
}

test "next_hop (neighbors: [15, 0, 7, 2], target: 7)" {
    const core: *Core = try init_test_core(3);
    set_neighbor_ids(core, [4]u64{ 15, 0, 7, 2 });

    // Set args for next hop
    var sender: *Sender = core.sender;
    sender.rd = 0;
    sender.rs1 = 1; // Value
    sender.rs2 = 7; // CPU target
    const expected: u16 = 7;
    const actual = sender.next_hop();
    try expect(expected == actual);
}

test "next_hop (neighbors: [8, 13, 0, 15], target: 7)" {
    const core: *Core = try init_test_core(12);
    set_neighbor_ids(core, [4]u64{ 8, 13, 0, 15 });

    // Set args for next hop
    var sender: *Sender = core.sender;
    sender.rd = 0;
    sender.rs1 = 1; // Value
    sender.rs2 = 7; // CPU target
    const expected: u16 = 15;
    const actual = sender.next_hop();
    try expect(expected == actual);
}

test "next_hop (neighbors: [11, 12, 3, 14], target: 7)" {
    const core: *Core = try init_test_core(15);
    set_neighbor_ids(core, [4]u64{ 11, 12, 3, 14 });

    // Set args for next hop
    var sender: *Sender = core.sender;
    sender.rd = 0;
    sender.rs1 = 1; // Value
    sender.rs2 = 7; // CPU target
    const expected: u16 = 11;
    const actual = sender.next_hop();
    try expect(expected == actual);
}

test "next_hop (neighbors: [6, 11, 14, 9], target: 7)" {
    const core: *Core = try init_test_core(10);
    set_neighbor_ids(core, [4]u64{ 6, 11, 14, 9 });

    // Set args for next hop
    var sender: *Sender = core.sender;
    sender.rd = 0;
    sender.rs1 = 1; // Value
    sender.rs2 = 7; // CPU target
    const expected: u16 = 11;
    const actual = sender.next_hop();
    try expect(expected == actual);
}
