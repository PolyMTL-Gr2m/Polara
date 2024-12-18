// ========== Copyright Header Begin ============================================
// Copyright (c) 2020 Princeton University
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ========== Copyright Header End ============================================
// Edited by Kaifeng Xu
// Map the R/W request to the PLIC registers
module plic_regs #(
  parameter int N_SOURCE    = 128,
  parameter int N_TARGET    = 60,
  parameter int MAX_PRIO    = 7,
  parameter int SRCW        = $clog2(N_SOURCE+1),
  parameter int PRIOW       = $clog2(MAX_PRIO+1)
) (
  input  logic                              clk_i,    // Clock
  input  logic                              rst_ni,   // Asynchronous reset active low
  output logic [N_SOURCE-1:0][PRIOW-1:0]    prio_q,   // priority register
  output logic [N_SOURCE:0]                 prio_re_o,
  input  logic [N_SOURCE:0]                 ip_i,
  output logic                              ip_re_o,
  output logic [N_TARGET-1:0][N_SOURCE-1:0] ie_q,     // enabling register
  output logic [N_TARGET-1:0]               ie_re_o,
  output logic [N_TARGET-1:0][PRIOW-1:0]    threshold_q,  // threshold register
  output logic [N_TARGET-1:0]               threshold_re_o,
  input  logic [N_TARGET-1:0][SRCW-1:0]     cc_i,
  output logic [N_TARGET-1:0][SRCW-1:0]     cc_o,
  output logic [N_TARGET-1:0]               cc_we_o,
  output logic [N_TARGET-1:0]               cc_re_o,
  // Bus Interface
  input  reg_intf::reg_intf_req_a32_d32     req_i,
  output reg_intf::reg_intf_resp_d32        resp_o
);

  localparam N_SOURCE_R = N_SOURCE%32;
	localparam EN_BASE = 32'h2000;
	localparam TH_BASE = 32'h200000;

	// local wires
  logic [N_TARGET-1:0] threshold_we;
	logic [PRIOW-1:0]    threshold_new;      // the new value for writing threshold register

  logic [N_SOURCE:0][PRIOW-1:0] prio_all;  // include reserved source 0
  logic [N_SOURCE:0] prio_we;              // include reserved source 0
	logic [PRIOW-1:0]  prio_new;             // the new value for writing priority register

  logic [N_TARGET-1:0][N_SOURCE:0] ie_all; // include reserved source 0
  logic [N_TARGET-1:0] ie_we;
	logic [N_SOURCE:0]   ie_new;             // the new value for writing enabling register

  // souce 0 is reserved
  assign prio_all[0] = '0;

  for (genvar i = 0; i < N_TARGET; i++) begin
    assign ie_all[i] = {ie_q[i][N_SOURCE-1:0], 1'b0};
  end

  for (genvar i = 1; i < N_SOURCE + 1; i++) begin
    assign prio_all[i] = prio_q[i - 1];
  end


  // registers
  always_ff @(posedge clk_i) begin
    if (~rst_ni) begin
      prio_q <= '0;
      ie_q <= '0;
      threshold_q <= '0;
    end else begin
      // source zero is 0
      for (int i = 0; i < N_SOURCE; i++) begin
        prio_q[i] <= prio_we[i + 1] ? prio_new : prio_q[i];
      end
      for (int i = 0; i < N_TARGET; i++) begin
        threshold_q[i] <= threshold_we[i] ? threshold_new : threshold_q[i];
        ie_q[i] <= ie_we[i] ? ie_new[N_SOURCE:1] : ie_q[i];
      end

    end
  end


// Change address
  logic [31:0] addr;           // R/W address
  logic [31:0] addr_enabling;  // Enabling bits adddress
  logic [13:0] en_ctxt_idx;    // Enabling bits context index
  logic [31:0] addr_threshold; // Threshold address
  logic [19:0] th_ctxt_idx;    // Threshold context index
  logic [9:0] addr_offset;     // 10 bits address for 32 bits register offset
  logic [4:0] en_src_offset;   // 5 bits address for 32 bits register offset
always_comb begin
  addr = req_i.addr;
  addr_enabling = addr - EN_BASE;
  en_ctxt_idx  = addr_enabling[20:7];
  addr_threshold = addr - TH_BASE;
  th_ctxt_idx = addr_threshold[31:12];
  addr_offset = addr[11:2];
  en_src_offset = addr[6:2];
end

// constant ports
always_comb begin
  resp_o.ready = 1'b1;
  resp_o.rdata = '0;
  resp_o.error = '0;
  prio_new = '0;
  prio_we = '0;
  prio_re_o = '0;
  ie_new = '0;
  ie_we = '0;
  ie_re_o = '0;
  ip_re_o = '0;
  threshold_new = '0;
  threshold_we = '0;
  threshold_re_o = '0;
  cc_o = '0;
  cc_we_o = '0;
  cc_re_o = '0;
  if (req_i.valid) begin
    // Write 
    if (req_i.write) begin
      // Invalid address
      if (addr & 32'h3) begin
        resp_o.error = 1'b1;
      end
      // Interrupt Source Priority
      else if ( addr[31:12] == 20'h0 ) begin
        if (addr_offset <= N_SOURCE) begin
          prio_new = req_i.wdata[PRIOW-1:0];
          prio_we[addr_offset] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end 
      // Enabling Bits
      else if ( addr[31:21] == 11'h0 && en_ctxt_idx < N_TARGET) begin
        if (en_src_offset * 32 + 31 <= N_SOURCE) begin
					ie_new = {ie_q[en_ctxt_idx], 1'b0};
          ie_new[en_src_offset * 32 +: 32] = req_i.wdata[31:0];
          ie_we[en_ctxt_idx] = 1'b1;
        end 
        else if (en_src_offset * 32 <= N_SOURCE) begin
					ie_new = {ie_q[en_ctxt_idx], 1'b0};
          ie_new[en_src_offset * 32 +: (N_SOURCE_R + 1)] = req_i.wdata[0 +: (N_SOURCE_R + 1)];
          ie_we[en_ctxt_idx] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end
      // Priority Threshold
      else if ( addr[31:26] == 6'h0 && addr_offset == 10'h0) begin
        if ( th_ctxt_idx < N_TARGET ) begin
          threshold_new = req_i.wdata[PRIOW-1:0];
          threshold_we[th_ctxt_idx] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end 
      end
      // Claim/Complete
      else if ( addr[31:26] == 6'h0 && addr_offset == 10'h1) begin
        if ( th_ctxt_idx < N_TARGET ) begin
          cc_o[th_ctxt_idx][SRCW-1:0] = req_i.wdata[SRCW-1:0];
          cc_we_o[th_ctxt_idx] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end
    end // write

    // Read
    else begin
      // Invalid address
      if (addr & 32'h3) begin
        resp_o.error = 1'b1;
      end
      // Interrupt Source Priority 
      else if ( addr[31:12] == 20'h0 ) begin
        if (addr_offset <= N_SOURCE) begin
          resp_o.rdata[PRIOW-1:0] = prio_all[addr_offset][PRIOW-1:0];
          prio_re_o[addr_offset] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end
      // Pending
      else if ( addr[31:13] == 19'h0 ) begin
        if (addr_offset * 32 + 31 <= N_SOURCE) begin
          resp_o.rdata[31:0] = ip_i[addr_offset * 32 +: 32];
          ip_re_o = 1'b1;
        end 
        else if (addr_offset * 32 <= N_SOURCE) begin
          resp_o.rdata[0 +: (N_SOURCE_R + 1)] = ip_i[addr_offset * 32 +: (N_SOURCE_R + 1)];
          ip_re_o = 1'b1;
        end
        else begin
          resp_o.error = 1'b1;
        end
      end
      // Enabling
      else if ( addr[31:21] == 11'h0 && en_ctxt_idx < N_TARGET) begin
        if (en_src_offset * 32 + 31 <= N_SOURCE) begin
          resp_o.rdata[31:0] = ie_all[en_ctxt_idx][en_src_offset * 32 +: 32];
          ie_re_o[en_ctxt_idx] = 1'b1;
        end
        else if (en_src_offset * 32 <= N_SOURCE) begin
          resp_o.rdata[0 +: (N_SOURCE_R + 1)] = ie_all[en_ctxt_idx][en_src_offset * 32 +: (N_SOURCE_R + 1)];
          ie_re_o[en_ctxt_idx] = 1'b1;
        end
        else begin
          resp_o.error = 1'b1;
        end
      end
      // Priority threshold
      else if ( addr[31:26] == 6'h0 && addr_offset == 10'h0) begin
        if ( th_ctxt_idx < N_TARGET ) begin
          resp_o.rdata[PRIOW-1:0] = threshold_q[th_ctxt_idx][PRIOW-1:0];
          threshold_re_o[th_ctxt_idx] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end
      // Claim/Complete
      else if ( addr[31:26] == 6'h0 && addr_offset == 10'h1) begin
        if ( th_ctxt_idx < N_TARGET ) begin
          resp_o.rdata[SRCW-1:0] = cc_i[th_ctxt_idx][SRCW-1:0];
          cc_re_o[th_ctxt_idx] = 1'b1;
        end else begin
          resp_o.error = 1'b1;
        end
      end
      else begin
        resp_o.error = 1'b1;
      end
    end // Read
  end // valid

end // comb

endmodule

