// -------------------------------------------------------------------------------
// Project:       core-v-polara-apu
// File:          gen2_polara_top.sv
// Author:        Raphael Rowley
// Creation Date: 2024/06/12
//                                                                                
// Description:
// Memory controller top level for chipset on the genesys2 to communicate with
// the Polara ASIC.
//                                                                                
// -------------------------------------------------------------------------------

`include "mc_define.h"
`include "noc_axi4_bridge_define.vh"

module gen2_polara_top(

        // DDR3 Physical Interface
        output logic [`DDR3_ADDR_WIDTH-1:0] ddr3_sdram_addr, 
        output logic [`DDR3_BA_WIDTH-1:0]   ddr3_sdram_ba,
        output logic                        ddr3_sdram_cas_n,
        output logic [`DDR3_CK_WIDTH-1:0]   ddr3_sdram_ck_n,
        output logic [`DDR3_CK_WIDTH-1:0]   ddr3_sdram_ck_p,
        output logic [`DDR3_CKE_WIDTH-1:0]  ddr3_sdram_cke,
        output logic [`DDR3_CS_WIDTH-1:0]   ddr3_sdram_cs_n,
        inout logic [`DDR3_DM_WIDTH-1:0]    ddr3_sdram_dm,
        inout logic [`DDR3_DQ_WIDTH-1:0]    ddr3_sdram_dq,
        inout logic [`DDR3_DQS_WIDTH-1:0]   ddr3_sdram_dqs_n,
        inout logic [`DDR3_DQS_WIDTH-1:0]   ddr3_sdram_dqs_p,
        output logic [`DDR3_ODT_WIDTH-1:0]  ddr3_sdram_odt,
        output logic                        ddr3_sdram_ras_n,
        output logic                        ddr3_sdram_reset_n,
        output logic                        ddr3_sdram_we_n,

        // Clocks and reset
        input logic                         chipset_clk,
        input logic                         sys_rst_n,
`ifndef POLARA_GEN2_CHIPSETSE
        input logic                         mig_ddr3_sys_diff_clock_clk_n,
        input logic                         mig_ddr3_sys_diff_clock_clk_p,
`else
        input logic                         mig_ddr3_sys_se_clock_clk,

        // Polara ASIC Control Signals
        output logic                        chip_async_mux,
        output logic                        chip_clk_en,
        output logic                        chip_clk_mux_sel,
        output logic                        chip_rst_n,
        output logic                        fll_rst_n,
        output logic                        fll_bypass,
        input  logic                        fll_clkdiv,
        input  logic                        fll_lock,
        output logic                        fll_cfg_req,
        output logic                        fll_opmode,
        output logic [3:0]                  fll_range,
`endif
                       

        // NOC
	    input logic [`NOC_DATA_WIDTH-1:0]   mem_flit_in_data ,
        input logic                         mem_flit_in_val ,
        output logic                        mem_flit_in_rdy ,

        output logic [`NOC_DATA_WIDTH-1:0]  mem_flit_out_data ,
        output logic                        mem_flit_out_val ,
        input logic                         mem_flit_out_rdy ,

        // Others
        output logic                        init_calib_complete_out,
        output logic                        mem_ui_clk_sync_rst,
                       
        // UART
        input logic                         uart_boot_en
                       
);
   // -------------------------------------------------------------------------------
   // Signal declarations
   // -------------------------------------------------------------------------------
   logic                                 trans_fifo_val;
   logic [`NOC_DATA_WIDTH-1:0]           trans_fifo_data;
   logic                                 trans_fifo_rdy;
   
   

   logic                                 fifo_trans_val;
   logic [`NOC_DATA_WIDTH-1:0]           fifo_trans_data;
   logic                                 fifo_trans_rdy;
   
   logic                                 ui_clk;
   logic                                 noc_axi4_bridge_rst;
   logic                                 noc_axi4_bridge_init_done;
   

   logic [`AXI4_ID_WIDTH     -1:0]       ddr3_axi_arid;
   logic [`AXI4_ADDR_WIDTH   -1:0]       ddr3_axi_araddr;
   logic [`AXI4_BURST_WIDTH  -1:0]       ddr3_axi_arburst;
   logic [`AXI4_CACHE_WIDTH  -1:0]       ddr3_axi_arcache;
   logic [`AXI4_LEN_WIDTH    -1:0]       ddr3_axi_arlen;
   logic                                 ddr3_axi_arlock;
   logic [`AXI4_PROT_WIDTH   -1:0]       ddr3_axi_arprot;
   logic [`AXI4_QOS_WIDTH    -1:0]       ddr3_axi_arqos;
   logic                                 ddr3_axi_arready;
   logic [`AXI4_SIZE_WIDTH   -1:0]       ddr3_axi_arsize;
   logic                                 ddr3_axi_arvalid;
   logic [`AXI4_REGION_WIDTH -1:0]       m_axi_arregion; // not used
   logic [`AXI4_USER_WIDTH   -1:0]       m_axi_aruser; // not used
   
   
   
   logic [`AXI4_ADDR_WIDTH   -1:0]       ddr3_axi_awaddr;
   logic [`AXI4_BURST_WIDTH  -1:0]       ddr3_axi_awburst;
   logic [`AXI4_CACHE_WIDTH  -1:0]       ddr3_axi_awcache;
   logic [`AXI4_ID_WIDTH     -1:0]       ddr3_axi_awid;
   logic [`AXI4_LEN_WIDTH    -1:0]       ddr3_axi_awlen;
   logic                                 ddr3_axi_awlock;
   logic [`AXI4_PROT_WIDTH   -1:0]       ddr3_axi_awprot;
   logic [`AXI4_QOS_WIDTH    -1:0]       ddr3_axi_awqos;
   logic                                 ddr3_axi_awready;
   logic [`AXI4_SIZE_WIDTH   -1:0]       ddr3_axi_awsize;
   logic                                 ddr3_axi_awvalid;
   logic [`AXI4_REGION_WIDTH -1:0]       m_axi_awregion; // not used
   logic [`AXI4_USER_WIDTH   -1:0]       m_axi_awuser; // not used
   
   
   
   logic [`AXI4_ID_WIDTH     -1:0]       ddr3_axi_bid;
   logic                                 ddr3_axi_bready;
   logic [`AXI4_RESP_WIDTH   -1:0]       ddr3_axi_bresp;
   logic                                 ddr3_axi_bvalid;
   logic [`AXI4_USER_WIDTH   -1:0]       m_axi_buser; // not used
   

   logic [`AXI4_DATA_WIDTH   -1:0]       ddr3_axi_rdata;
   logic [`AXI4_ID_WIDTH     -1:0]       ddr3_axi_rid;
   logic                                 ddr3_axi_rlast;
   logic                                 ddr3_axi_rready;
   logic [`AXI4_RESP_WIDTH   -1:0]       ddr3_axi_rresp;
   logic                                 ddr3_axi_rvalid;
   logic [`AXI4_USER_WIDTH   -1:0]       m_axi_ruser; // not used
   

   logic [`AXI4_DATA_WIDTH   -1:0]       ddr3_axi_wdata;
   logic                                 ddr3_axi_wlast;
   logic                                 ddr3_axi_wready;
   logic [`AXI4_STRB_WIDTH   -1:0]       ddr3_axi_wstrb;
   logic                                 ddr3_axi_wvalid;
   logic [`AXI4_ID_WIDTH     -1:0]       m_axi_wid; // not used
   logic [`AXI4_USER_WIDTH   -1:0]       m_axi_wuser; // not used

   logic                                 mig_ddr3_ui_clk;

   logic                                 ui_clk_sync_rst_r;
   logic                                 ui_clk_sync_rst_r_r;
   logic [31:0]                          delay_cnt;
   logic                                 core_ref_clk;
   logic                                 ui_clk_syn_rst_delayed;
   
   logic                                 afifo_rst_1;
   logic                                 afifo_ui_rst_r;
   logic                                 afifo_ui_rst_r_r;
   logic                                 ui_clk_sync_rst;
   logic                                 afifo_rst_2;
                               
   logic                                 init_calib_complete;

   logic [1:0]                           polara_gen2chipset_bus_i;
   logic [11:0]                          polara_gen2chipset_bus_o;

   // -------------------------------------------------------------------------------
   // Behavioral
   // -------------------------------------------------------------------------------

   // from mc_top.v
   assign init_calib_complete = noc_axi4_bridge_init_done;
   assign init_calib_complete_out = init_calib_complete & ~ui_clk_syn_rst_delayed;
   
   // -------------------------------------------------------------------------------
   // rst logic taken from mc_top.v
   // -------------------------------------------------------------------------------
   
   // needed for correct rst of async fifo

   always @(posedge core_ref_clk) begin
      ui_clk_sync_rst_r   <= ui_clk_sync_rst;
      ui_clk_sync_rst_r_r <= ui_clk_sync_rst_r;
   end
   
   always @(posedge core_ref_clk) begin
      if (~sys_rst_n)
        delay_cnt <= 32'h1ff;
      else begin
         delay_cnt <= (delay_cnt != 0) & ~ui_clk_sync_rst_r_r ? delay_cnt - 1 : delay_cnt;
      end
   end
   
   assign core_ref_clk = chipset_clk;
   always @(posedge core_ref_clk) begin
      if (ui_clk_sync_rst)
        ui_clk_syn_rst_delayed <= 1'b1;
      else begin
        ui_clk_syn_rst_delayed <= delay_cnt != 0;
      end
   end
   
   assign afifo_rst_1 = ui_clk_syn_rst_delayed;
   assign mem_ui_clk_sync_rst = ui_clk_syn_rst_delayed;

   assign ui_clk = mig_ddr3_ui_clk;
   always @(posedge ui_clk) begin
      afifo_ui_rst_r <= afifo_rst_1;
      afifo_ui_rst_r_r <= afifo_ui_rst_r;
   end

   assign ui_clk_sync_rst = noc_axi4_bridge_rst;
   assign afifo_rst_2 = afifo_ui_rst_r_r | ui_clk_sync_rst;
   
   // -------------------------------------------------------------------------------
   // Instances
   // -------------------------------------------------------------------------------
    noc_bidir_afifo  mig_afifo  (
        .clk_1           (chipset_clk),
        .rst_1           (afifo_rst_1), 

        .clk_2           (mig_ddr3_ui_clk), 
        .rst_2           (afifo_rst_2), 

        // CPU --> MIG
        .flit_in_val_1   (mem_flit_in_val),
        .flit_in_data_1  (mem_flit_in_data),
        .flit_in_rdy_1   (mem_flit_in_rdy),

        .flit_out_val_2  (fifo_trans_val), 
        .flit_out_data_2 (fifo_trans_data), 
        .flit_out_rdy_2  (fifo_trans_rdy),

        // MIG --> CPU
        .flit_in_val_2   (trans_fifo_val),
        .flit_in_data_2  (trans_fifo_data),
        .flit_in_rdy_2   (trans_fifo_rdy),

        .flit_out_val_1  (mem_flit_out_val),
        .flit_out_data_1 (mem_flit_out_data),
        .flit_out_rdy_1  (mem_flit_out_rdy)
    );

    noc_axi4_bridge noc_axi4_bridge  (
		.clk                (mig_ddr3_ui_clk),  
		.rst_n              (~noc_axi4_bridge_rst), 
		.uart_boot_en       (uart_boot_en),
		.phy_init_done      (noc_axi4_bridge_init_done), 

		.src_bridge_vr_noc2_val (fifo_trans_val),
		.src_bridge_vr_noc2_dat (fifo_trans_data),
		.src_bridge_vr_noc2_rdy (fifo_trans_rdy),

		.bridge_dst_vr_noc3_val (trans_fifo_val),
		.bridge_dst_vr_noc3_dat (trans_fifo_data),
		.bridge_dst_vr_noc3_rdy (trans_fifo_rdy),

		.m_axi_awid    			(ddr3_axi_awid),
		.m_axi_awaddr    		(ddr3_axi_awaddr),
		.m_axi_awlen    		(ddr3_axi_awlen),
		.m_axi_awsize    		(ddr3_axi_awsize),
		.m_axi_awburst    		(ddr3_axi_awburst),
		.m_axi_awlock    		(ddr3_axi_awlock),
		.m_axi_awcache    		(ddr3_axi_awcache),
		.m_axi_awprot    		(ddr3_axi_awprot),
		.m_axi_awqos    		(ddr3_axi_awqos),
		.m_axi_awregion    		(m_axi_awregion), // not used
		.m_axi_awuser    		(m_axi_awuser), // not used
		.m_axi_awvalid    		(ddr3_axi_awvalid),
		.m_axi_awready    		(ddr3_axi_awready),

		.m_axi_wid    			(m_axi_wid), // not used
		.m_axi_wdata    		(ddr3_axi_wdata),
		.m_axi_wstrb    		(ddr3_axi_wstrb),
		.m_axi_wlast    		(ddr3_axi_wlast),
		.m_axi_wuser    		(m_axi_wuser), // not used
		.m_axi_wvalid    		(ddr3_axi_wvalid),
		.m_axi_wready    		(ddr3_axi_wready),

		.m_axi_bid    			(ddr3_axi_bid),
		.m_axi_bresp    		(ddr3_axi_bresp),
		.m_axi_buser    		(m_axi_buser),  // not used
		.m_axi_bvalid    		(ddr3_axi_bvalid),
		.m_axi_bready    		(ddr3_axi_bready),

		.m_axi_arid    		(ddr3_axi_arid),
		.m_axi_araddr    		(ddr3_axi_araddr),
		.m_axi_arlen    		(ddr3_axi_arlen),
		.m_axi_arsize    		(ddr3_axi_arsize),
		.m_axi_arburst    	(ddr3_axi_arburst),
		.m_axi_arlock    		(ddr3_axi_arlock),
		.m_axi_arcache    	(ddr3_axi_arcache),
		.m_axi_arprot    		(ddr3_axi_arprot),
		.m_axi_arqos    		(ddr3_axi_arqos),
		.m_axi_arregion    		(m_axi_arregion), // not used
		.m_axi_aruser    		(m_axi_aruser), // not used
		.m_axi_arvalid    		(ddr3_axi_arvalid),
		.m_axi_arready    		(ddr3_axi_arready),

		.m_axi_rid    			(ddr3_axi_rid),
		.m_axi_rdata    		(ddr3_axi_rdata),
		.m_axi_rresp    		(ddr3_axi_rresp),
		.m_axi_rlast    		(ddr3_axi_rlast),
		.m_axi_ruser    		(m_axi_ruser), // not used
		.m_axi_rvalid    		(ddr3_axi_rvalid),
		.m_axi_rready    		(ddr3_axi_rready)		
		
	);

    `ifndef POLARA_GEN2_CHIPSETSE
    gen2_polara_fpga gen2_polara_fpga_i(
        // AXI Interface for NOC/Master
        .ddr3_axi_araddr(ddr3_axi_araddr),
        .ddr3_axi_arburst(ddr3_axi_arburst),
        .ddr3_axi_arcache(ddr3_axi_arcache),
        .ddr3_axi_arid(ddr3_axi_arid),
        .ddr3_axi_arlen(ddr3_axi_arlen),
        .ddr3_axi_arlock(ddr3_axi_arlock),
        .ddr3_axi_arprot(ddr3_axi_arprot),
        .ddr3_axi_arqos(ddr3_axi_arqos),
        .ddr3_axi_arready(ddr3_axi_arready),
        .ddr3_axi_arsize(ddr3_axi_arsize),
        .ddr3_axi_arvalid(ddr3_axi_arvalid),
        .ddr3_axi_awaddr(ddr3_axi_awaddr),
        .ddr3_axi_awburst(ddr3_axi_awburst),
        .ddr3_axi_awcache(ddr3_axi_awcache),
        .ddr3_axi_awid(ddr3_axi_awid),
        .ddr3_axi_awlen(ddr3_axi_awlen),
        .ddr3_axi_awlock(ddr3_axi_awlock),
        .ddr3_axi_awprot(ddr3_axi_awprot),
        .ddr3_axi_awqos(ddr3_axi_awqos),
        .ddr3_axi_awready(ddr3_axi_awready),
        .ddr3_axi_awsize(ddr3_axi_awsize),
        .ddr3_axi_awvalid(ddr3_axi_awvalid),
        .ddr3_axi_bid(ddr3_axi_bid),
        .ddr3_axi_bready(ddr3_axi_bready),
        .ddr3_axi_bresp(ddr3_axi_bresp),
        .ddr3_axi_bvalid(ddr3_axi_bvalid),
        .ddr3_axi_rdata(ddr3_axi_rdata),
        .ddr3_axi_rid(ddr3_axi_rid),
        .ddr3_axi_rlast(ddr3_axi_rlast),
        .ddr3_axi_rready(ddr3_axi_rready),
        .ddr3_axi_rresp(ddr3_axi_rresp),
        .ddr3_axi_rvalid(ddr3_axi_rvalid),
        .ddr3_axi_wdata(ddr3_axi_wdata),
        .ddr3_axi_wlast(ddr3_axi_wlast),
        .ddr3_axi_wready(ddr3_axi_wready),
        .ddr3_axi_wstrb(ddr3_axi_wstrb),
        .ddr3_axi_wvalid(ddr3_axi_wvalid),
        // DDR3 Physical Interface
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        // DDR3 memory ready
        .mig_ddr3_init_calib_complete(noc_axi4_bridge_init_done),
        // Input Clock for MIG
        // Xilinx recommends an external clock as the input clock (low jitter)
        .mig_ddr3_sys_diff_clock_clk_n(mig_ddr3_sys_diff_clock_clk_n),
        .mig_ddr3_sys_diff_clock_clk_p(mig_ddr3_sys_diff_clock_clk_p),
        // Asynchronous reset for the MIG's sys_rst_n
        // also used as reset for the AXI bus (synced with ui_clk)
        .mig_ddr3_sys_rst_n(sys_rst_n),
        // MIG generated ui_clk and synchronized reset
        .mig_ddr3_ui_clk(mig_ddr3_ui_clk),
        .mig_ddr3_ui_clk_sync_rst(noc_axi4_bridge_rst)
    );
    `else // !`ifndef POLARA_GEN2_CHIPSETSE
    gen2_polara_fpga_se_clk gen2_polara_fpga_se_clk_i
       (.ddr3_axi_araddr(ddr3_axi_araddr),
        .ddr3_axi_arburst(ddr3_axi_arburst),
        .ddr3_axi_arcache(ddr3_axi_arcache),
        .ddr3_axi_arid(ddr3_axi_arid),
        .ddr3_axi_arlen(ddr3_axi_arlen),
        .ddr3_axi_arlock(ddr3_axi_arlock),
        .ddr3_axi_arprot(ddr3_axi_arprot),
        .ddr3_axi_arqos(ddr3_axi_arqos),
        .ddr3_axi_arready(ddr3_axi_arready),
        .ddr3_axi_arsize(ddr3_axi_arsize),
        .ddr3_axi_arvalid(ddr3_axi_arvalid),
        .ddr3_axi_awaddr(ddr3_axi_awaddr),
        .ddr3_axi_awburst(ddr3_axi_awburst),
        .ddr3_axi_awcache(ddr3_axi_awcache),
        .ddr3_axi_awid(ddr3_axi_awid),
        .ddr3_axi_awlen(ddr3_axi_awlen),
        .ddr3_axi_awlock(ddr3_axi_awlock),
        .ddr3_axi_awprot(ddr3_axi_awprot),
        .ddr3_axi_awqos(ddr3_axi_awqos),
        .ddr3_axi_awready(ddr3_axi_awready),
        .ddr3_axi_awsize(ddr3_axi_awsize),
        .ddr3_axi_awvalid(ddr3_axi_awvalid),
        .ddr3_axi_bid(ddr3_axi_bid),
        .ddr3_axi_bready(ddr3_axi_bready),
        .ddr3_axi_bresp(ddr3_axi_bresp),
        .ddr3_axi_bvalid(ddr3_axi_bvalid),
        .ddr3_axi_rdata(ddr3_axi_rdata),
        .ddr3_axi_rid(ddr3_axi_rid),
        .ddr3_axi_rlast(ddr3_axi_rlast),
        .ddr3_axi_rready(ddr3_axi_rready),
        .ddr3_axi_rresp(ddr3_axi_rresp),
        .ddr3_axi_rvalid(ddr3_axi_rvalid),
        .ddr3_axi_wdata(ddr3_axi_wdata),
        .ddr3_axi_wlast(ddr3_axi_wlast),
        .ddr3_axi_wready(ddr3_axi_wready),
        .ddr3_axi_wstrb(ddr3_axi_wstrb),
        .ddr3_axi_wvalid(ddr3_axi_wvalid),
        .ddr3_sdram_addr(ddr3_sdram_addr),
        .ddr3_sdram_ba(ddr3_sdram_ba),
        .ddr3_sdram_cas_n(ddr3_sdram_cas_n),
        .ddr3_sdram_ck_n(ddr3_sdram_ck_n),
        .ddr3_sdram_ck_p(ddr3_sdram_ck_p),
        .ddr3_sdram_cke(ddr3_sdram_cke),
        .ddr3_sdram_cs_n(ddr3_sdram_cs_n),
        .ddr3_sdram_dm(ddr3_sdram_dm),
        .ddr3_sdram_dq(ddr3_sdram_dq),
        .ddr3_sdram_dqs_n(ddr3_sdram_dqs_n),
        .ddr3_sdram_dqs_p(ddr3_sdram_dqs_p),
        .ddr3_sdram_odt(ddr3_sdram_odt),
        .ddr3_sdram_ras_n(ddr3_sdram_ras_n),
        .ddr3_sdram_reset_n(ddr3_sdram_reset_n),
        .ddr3_sdram_we_n(ddr3_sdram_we_n),
        .mig_ddr3_init_calib_complete(noc_axi4_bridge_init_done),
        .mig_ddr3_sys_rst_n(sys_rst_n),
        .mig_ddr3_sys_se_clock_clk(mig_ddr3_sys_se_clock_clk),
        .mig_ddr3_ui_clk(mig_ddr3_ui_clk),
        .mig_ddr3_ui_clk_sync_rst(noc_axi4_bridge_rst),
        .polara_gen2chipset_bus_i_tri_i(polara_gen2chipset_bus_i),
        .polara_gen2chipset_bus_o_tri_o(polara_gen2chipset_bus_o)
        );

   // Route polara_gen2chipset_bus signals
   assign chip_rst_n = polara_gen2chipset_bus_o[0];
   assign chip_async_mux = polara_gen2chipset_bus_o[1];
   assign chip_clk_en = polara_gen2chipset_bus_o[2];
   assign chip_clk_mux_sel = polara_gen2chipset_bus_o[3];

   assign fll_rst_n = polara_gen2chipset_bus_o[4];
   assign fll_bypass = polara_gen2chipset_bus_o[5];
   assign fll_opmode = polara_gen2chipset_bus_o[6];
   assign fll_cfg_req = polara_gen2chipset_bus_o[7];

   assign fll_range[3:0] = polara_gen2chipset_bus_o[11:8];
   
   assign polara_gen2chipset_bus_i[0] = fll_lock;
   assign polara_gen2chipset_bus_i[1] = fll_clkdiv;
   

   
 `endif // !`ifndef POLARA_GEN2_CHIPSETSE

   
   
endmodule
