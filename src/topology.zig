const std = @import("std");
const Core = @import("components/core.zig").Core;

pub const Topology = struct {
    cores: []*Core,
    num_rows: u64,
    num_cores: u64,

    pub fn init(allocator: std.mem.Allocator, num_rows: u64) !*Topology {
        const num_cores = num_rows * num_rows;

        var cores = try allocator.alloc(*Core, num_cores);

        for (0..num_cores) |i| {
            cores[i] = try Core.create(allocator, i);
        }

        const topology = try allocator.create(Topology);

        topology.* = Topology{
            .num_cores = num_cores,
            .num_rows = num_rows,
            .cores = cores,
        };

        return topology;
    }

    pub fn get_core(self: *const Topology, i: u64) ?*Core {
        if (i >= self.cores.len) return null;
        return self.cores[i];
    }

    pub fn display(self: *const Topology) void {
        for (0..self.num_cores) |i| {
            const core: *Core = self.cores[i];
            std.debug.print("Core: {}\n", .{core.id});
        }
    }

    pub fn deinit(self: *const Topology, allocator: std.mem.Allocator) void {
        allocator.free(self.cores);
        allocator.destroy(self);
    }
};
