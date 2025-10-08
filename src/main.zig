const std = @import("std");
const Topology = @import("topology.zig").Topology;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const topology = try Topology.init(allocator, 4);
    defer topology.display();
}
