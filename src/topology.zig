const std = @import("std");
const Core = @import("components/core.zig").Core;

pub const Topology = struct {
    cores: []*Core,
    num_cores: u32,
    allocator: std.mem.Allocator,

    pub fn init(num_rows: u32) !*Topology {
        const num_cores = num_rows * num_rows;
        const allocator = std.heap.page_allocator;

        var topology = Topology{
            .num_cores = num_cores,
            .allocator = allocator,
            .cores = try allocator.alloc(*Core, num_cores),
        };

        for (0..num_rows) |i| {
            topology.cores[i] = Core.create(i);
        }

        return &topology;
    }

    pub fn deinit(self: *const Topology) !void {
        self.allocator.free(self.cores);
    }

    pub fn get_core(self: *const Topology, i: u32) ?*Core {
        if (i >= self.cores.len) return null;
        return self.cores[i];
    }
};
