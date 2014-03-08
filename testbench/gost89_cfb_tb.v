`timescale 1ns / 1ps

module gost89_cfb_tb;
  reg clk;
  always
    #1 clk = ~clk;

  reg  [511:0] sbox = 512'h 4a92d80e6b1c7f53eb4c6dfa23810759581da342efc7609b7da1089fe46cb2536c715fd84a9e03b24ba0721d36859cfedb413f590ae7682c1fd057a4923e6b8c;
  reg  [255:0] key  = 256'h 0475f6e05038fbfad2c7c390edb3ca3d1547124291ae1e8a2f79cd9ed2bcefbd;
  reg  reset_e, reset_d;
  reg  load_data_e, load_data_d;
  reg  [63:0] in_e, in_d;
  wire [63:0] out_e, out_d;
  wire busy_e, busy_d;

  gost89_cfb_encrypt
    cfb_encrypt1(clk, reset_e, load_data_e, sbox, key, in_e, out_e, busy_e);
  gost89_cfb_decrypt
    cfb_decrypt1(clk, reset_d, load_data_d, sbox, key, in_d, out_d, busy_d);

/*
CFB mode (gamma: 6aa0379517bb57af):
8d437364581af0da 12911df3eddcc0fb b73369c4b5cf3e7d 
54826055ab718bc7 585ddacf1a45e472 a3ec5a4eb4359095

CFB mode (gamma: fa5679a45f118aed):
419677a6eff07f2f 4f40b75be8e64341 cd02e6ef903d27da 
27d3e781cc4fcf43 9c7480fb9ea9df69 458ff5081b0fd688
*/

  initial begin
    $dumpfile("gost89_cfb_tb.vcd");
    $dumpvars(0, gost89_cfb_tb);

    clk = 0;
    reset_e = 0;
    reset_d = 0;
    load_data_e = 0;
    load_data_d = 0;

// Normal usage
    #1;
    in_e = 64'h 6aa0379517bb57af; in_d = 64'h 6aa0379517bb57af;
    reset_e = 1; reset_d = 1;
    #2;
    reset_e = 0; reset_d = 0;
    in_e = 64'h 8d437364581af0da; in_d = 64'h 54826055ab718bc7;
    load_data_e = 1; load_data_d = 1;
    #2;
    load_data_e = 0; load_data_d = 0;
    #68;
    if (out_e !== 64'h 54826055ab718bc7 && out_d !== 64'h 8d437364581af0da)
      begin $display("E"); $finish; end
    $display("OK");
    in_e = 64'h 12911df3eddcc0fb; in_d = 64'h 585ddacf1a45e472;
    load_data_e = 1; load_data_d = 1;
    #2;
    load_data_e = 0; load_data_d = 0;
    #68;
    if (out_e !== 64'h 585ddacf1a45e472 && out_d !== 64'h 12911df3eddcc0fb)
      begin $display("E"); $finish; end
    $display("OK");

// Change gamma
    #2;
    in_e = 64'h fa5679a45f118aed; in_d = 64'h fa5679a45f118aed;
    reset_e = 1; reset_d = 1;
    #2;
    reset_e = 0; reset_d = 0;
    in_e = 64'h 419677a6eff07f2f; in_d = 64'h 27d3e781cc4fcf43;
    load_data_e = 1; load_data_d = 1;
    #2;
    load_data_e = 0; load_data_d = 0;
    #68;
    if (out_e !== 64'h 27d3e781cc4fcf43 && out_d !== 64'h 419677a6eff07f2f)
      begin $display("E"); $finish; end
    $display("OK");

// Reset in processing
    #2;
    in_e = 64'h 6aa0379517bb57af; in_d = 64'h 6aa0379517bb57af;
    reset_e = 1; reset_d = 1;
    #2;
    reset_e = 0; reset_d = 0;
    in_e = 64'h 8d437364581af0da; in_d = 64'h 54826055ab718bc7;
    load_data_e = 1; load_data_d = 1;
    #2;
    load_data_e = 0; load_data_d = 0;
    #10;
    in_e = 64'h fa5679a45f118aed; in_d = 64'h fa5679a45f118aed;
    reset_e = 1; reset_d = 1;
    #2;
    reset_e = 0; reset_d = 0;
    in_e = 64'h 419677a6eff07f2f; in_d = 64'h 27d3e781cc4fcf43;
    load_data_e = 1; load_data_d = 1;
    #2;
    load_data_e = 0; load_data_d = 0;
    #68;
    if (out_e !== 64'h 27d3e781cc4fcf43 && out_d !== 64'h 419677a6eff07f2f)
      begin $display("E"); $finish; end
    $display("OK");

    #10;
    $display("All passed");
    $finish;
  end
endmodule
