library verilog;
use verilog.vl_types.all;
entity arbiter_vlg_check_tst is
    port(
        GNT0out         : in     vl_logic;
        GNT1out         : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end arbiter_vlg_check_tst;
