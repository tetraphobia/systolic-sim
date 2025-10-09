const GlobalRegisters = struct {
    num_cores: u8,
    num_rows: u8,
};

pub const globals: GlobalRegisters = GlobalRegisters{
    .num_cores = 16,
    .num_rows = 4,
};
