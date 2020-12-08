library verilog;
use verilog.vl_types.all;
entity moore_state_machine_vlg_check_tst is
    port(
        L1              : in     vl_logic;
        L2              : in     vl_logic;
        L3              : in     vl_logic;
        L4              : in     vl_logic;
        M1              : in     vl_logic;
        M2              : in     vl_logic;
        M3              : in     vl_logic;
        M4              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end moore_state_machine_vlg_check_tst;
