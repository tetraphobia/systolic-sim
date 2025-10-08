const std = @import("std");
const Topology = @import("topology.zig").Topology;

pub fn main() !void {
    const topology = try Topology.init(4);
    _ = topology; // autofix
}
