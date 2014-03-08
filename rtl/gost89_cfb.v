module gost89_cfb_encrypt(
  input              clk,
  input              reset,
  input              load_data,
  input      [511:0] sbox,
  input      [255:0] key,
  input      [63:0]  in,
  output reg [63:0]  out,
  output reg         busy
);
  reg  [63:0] gamma;
  reg  [63:0] in_value;
  wire [63:0] out_e;
  wire        load_e, busy_e;

  assign load_e = !reset && load_data;

  gost89_ecb_encrypt
    ecb_encrypt(clk, load_e, load_e, sbox, key, gamma, out_e, busy_e);

  always @(posedge clk) begin
    if (reset && !load_data) begin
      gamma <= in;
      out  <= 64'h xxxxxxxxxxxxxxxx;
      busy <= 0;
    end

    if (!reset & load_data) begin
      in_value <= in;
      out  <= 64'h xxxxxxxxxxxxxxxx;
      busy <= 1;
    end

    if (!reset && !load_data && !busy_e && busy) begin
      gamma <= out_e ^ in_value;
      out   <= out_e ^ in_value;
      busy  <= 0;
    end
  end
endmodule

module gost89_cfb_decrypt(
  input              clk,
  input              reset,
  input              load_data,
  input      [511:0] sbox,
  input      [255:0] key,
  input      [63:0]  in,
  output reg [63:0]  out,
  output reg         busy
);
  reg  [63:0] gamma;
  reg  [63:0] in_value;
  wire [63:0] out_e;
  wire        load_e, busy_e;

  assign load_e = !reset && load_data;

  gost89_ecb_encrypt
    ecb_encrypt(clk, load_e, load_e, sbox, key, gamma, out_e, busy_e);

  always @(posedge clk) begin
    if (reset && !load_data) begin
      gamma <= in;
      out  <= 64'h xxxxxxxxxxxxxxxx;
      busy <= 0;
    end

    if (!reset & load_data) begin
      in_value <= in;
      out  <= 64'h xxxxxxxxxxxxxxxx;
      busy <= 1;
    end

    if (!reset && !load_data && !busy_e && busy) begin
      gamma <= in_value;
      out   <= out_e ^ in_value;
      busy  <= 0;
    end
  end
endmodule
