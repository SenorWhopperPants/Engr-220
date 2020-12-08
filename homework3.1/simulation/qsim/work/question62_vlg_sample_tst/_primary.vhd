library verilog;
use verilog.vl_types.all;
entity question62_vlg_sample_tst is
    port(
        Clock           : in     vl_logic;
        ResetLow        : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end question62_vlg_sample_tst;
