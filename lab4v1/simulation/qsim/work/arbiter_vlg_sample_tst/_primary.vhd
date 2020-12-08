library verilog;
use verilog.vl_types.all;
entity arbiter_vlg_sample_tst is
    port(
        Clock           : in     vl_logic;
        REQ0            : in     vl_logic;
        REQ1            : in     vl_logic;
        Reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end arbiter_vlg_sample_tst;
