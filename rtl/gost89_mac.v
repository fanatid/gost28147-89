module gost89_mac(
  input          clk,
  input          reset,
  input          load_data,
  input  [511:0] sbox,
  input  [255:0] key,
  input  [63:0]  in,
  output [31:0]  out,
  output         busy
);
  reg  [4:0]  round_num;
  reg  [31:0] round_key;
  reg         need_xor;
  reg  [31:0] n1, n2;
  wire [31:0] out1, out2;

  initial begin
    round_num = 16;
    need_xor  = 0;
  end

  gost89_round
    rnd(clk, sbox, round_key, n1, n2, out1, out2);

  assign out  = out2;
  assign busy = !(round_num == 16);

  always @(posedge clk) begin
    if (reset && !load_data) begin
      round_num <= 16;
      need_xor  <= 0;
    end

    if (!reset && load_data) begin
      if (need_xor) begin
        n1 <= in[63:32] ^ out2;
        n2 <= in[31:0]  ^ out1;
      end else begin
        n1 <= in[63:32];
        n2 <= in[31:0];
        need_xor <= 1;
      end
      round_num <= 0;
    end

    if (reset && load_data) begin
      n1 <= in[63:32];
      n2 <= in[31:0];
      round_num <= 0;
      need_xor  <= 1;
    end

    if (!reset && !load_data) begin
      if (round_num < 16)
        round_num <= round_num + 1;
      if (round_num > 0 && round_num < 16) begin
        n1 <= out1;
        n2 <= out2;
      end
    end
  end

  always @(posedge clk)
    case (round_num)
      0:  round_key <= key[255:224];
      1:  round_key <= key[223:192];
      2:  round_key <= key[191:160];
      3:  round_key <= key[159:128];
      4:  round_key <= key[127:96];
      5:  round_key <= key[95:64];
      6:  round_key <= key[63:32];
      7:  round_key <= key[31:0];
      8:  round_key <= key[255:224];
      9:  round_key <= key[223:192];
      10: round_key <= key[191:160];
      11: round_key <= key[159:128];
      12: round_key <= key[127:96];
      13: round_key <= key[95:64];
      14: round_key <= key[63:32];
      15: round_key <= key[31:0];
      default: round_key <= 32'h xxxxxxxx;
    endcase
endmodule
