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
  wire [63:0] out_e;
  wire        load_e, busy_e;

  assign load_e = !reset && load_data;

  gost89_ecb_encrypt
    ecb_encrypt(clk, load_e, load_e, sbox, key, gamma, out_e, busy_e);

  always @(posedge clk) begin
    if (reset && !load_data) begin
      gamma <= in;
      busy  <= 0;
    end

    if (!reset & load_data)
      busy <= 1;

    if (!reset && !load_data && !busy_e && busy) begin
      gamma <= out_e ^ in;
      out   <= out_e ^ in;
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
  wire [63:0] out_e;
  wire        load_e, busy_e;

  assign load_e = !reset && load_data;

  gost89_ecb_encrypt
    ecb_encrypt(clk, load_e, load_e, sbox, key, gamma, out_e, busy_e);

  always @(posedge clk) begin
    if (reset && !load_data) begin
      gamma <= in;
      busy  <= 0;
    end

    if (!reset & load_data)
      busy <= 1;

    if (!reset && !load_data && !busy_e && busy) begin
      gamma <= in;
      out   <= out_e ^ in;
      busy  <= 0;
    end
  end
endmodule
