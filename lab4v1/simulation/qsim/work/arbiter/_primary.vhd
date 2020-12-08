library verilog;
use verilog.vl_types.all;
entity arbiter is
    port(
        GNT1out         : out    vl_logic;
        Reset           : in     vl_logic;
        Clock           : in     vl_logic;
        REQ0            : in     vl_logic;
        REQ1            : in     vl_logic;
        GNT0out         : out    vl_logic
    );
end arbiter;
