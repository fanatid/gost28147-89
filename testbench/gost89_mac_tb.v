`timescale 1ns / 1ps

module gost89_mac_tb;
  reg clk;
  always
    #1 clk = ~clk;

  reg  [511:0] sbox = 512'h 4a92d80e6b1c7f53eb4c6dfa23810759581da342efc7609b7da1089fe46cb2536c715fd84a9e03b24ba0721d36859cfedb413f590ae7682c1fd057a4923e6b8c;
  reg  [255:0] key  = 256'h 0475f6e05038fbfad2c7c390edb3ca3d1547124291ae1e8a2f79cd9ed2bcefbd;
  reg          reset, load_data;
  reg  [63:0]  in;
  wire [31:0]  out;
  wire         busy;
  wire [19:0]  result = out[19:0];

  gost89_mac mac1(clk, reset, load_data, sbox, key, in, out, busy);

  initial begin
    $dumpfile("gost89_mac_tb.vcd");
    $dumpvars(0, gost89_mac_tb);

    clk       = 0;
    reset     = 0;
    load_data = 0;

/* Without reset
cb36401ec6d36482 727b1e7d9ef80d3d 19dfe6249374c677 
a5ff400000000000
*/
    #1;
    in = 64'h cb36401ec6d36482;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 727b1e7d9ef80d3d;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 19dfe6249374c677;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    if (result !== 20'h a5ff4)
      begin $display("E"); $finish; end
    $display("OK");

/* After reset
3bdb7810add20e66 7692fe7c9374aa9f 28f6d24f9e7e18c0 
df47800000000000
*/
    reset = 1;
    #2
    reset = 0;
    #2
    in = 64'h 3bdb7810add20e66;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 7692fe7c9374aa9f;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 28f6d24f9e7e18c0;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    if (result !== 20'h df478)
      begin $display("E"); $finish; end
    $display("OK");

/* Reset in processing
d58566f102366cc5 63ff8538f154f330 33dca4cce64866ba 
5e5ca00000000000
*/
    reset = 1;
    #2
    reset = 0;
    #2
    in = 64'h 0123456789abcdef;
    load_data = 1;
    #2;
    load_data = 0;

    #10
    reset = 1;
    #2
    reset = 0;
    #4
    in = 64'h d58566f102366cc5;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 63ff8538f154f330;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h 33dca4cce64866ba;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    if (result !== 20'h 5e5ca)
      begin $display("E"); $finish; end
    $display("OK");

/* Start with reset
8d437364581af0da 12911df3eddcc0fb b73369c4b5cf3e7d 
4cb8300000000000
*/
    reset = 1;
    #2
    reset = 0;
    #2
    in = 64'h 0123456789abcdef;
    load_data = 1;
    #2;
    load_data = 0;

    #6;
    in = 64'h 8d437364581af0da;
    reset = 1;
    load_data = 1;
    #2;
    reset = 0;
    load_data = 0;

    #32;
    in = 64'h 12911df3eddcc0fb;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    in = 64'h b73369c4b5cf3e7d;
    load_data = 1;
    #2;
    load_data = 0;

    #32;
    if (result !== 20'h 4cb83)
      begin $display("E"); $finish; end
    $display("OK");

    #10;
    $display("All passed");
    $finish;
  end
endmodule
