
module Bridge_Top(Hclk,Hresetn,Hwrite,Hreadyin,Hwdata,Haddr,Prdata,Htrans,Hresp,Pwrite,Penable,Hreadyout,Pselx,Paddr,Pwdata,Hrdata);

input Hclk,Hresetn,Hwrite,Hreadyin;
input [1:0] Htrans;
input [31:0] Haddr, Hwdata, Prdata;
output Pwrite,Penable, Hreadyout;
output [2:0] Pselx;
output  [31:0] Pwdata, Paddr, Hrdata;
output [1:0] Hresp;

wire valid, Hwritereg;
wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
wire [2:0] tempselx;

//instantiation
AHB_slave ahb( Hclk, Hresetn, Hwrite, Hreadyin, Htrans,Haddr,Hwdata,Hresp,Hrdata, valid, Hwritereg,Haddr1,Haddr2,Hwdata1,Hwdata2, tempselx);

APB_Controller apb(Hclk, Hresetn, valid,Hwrite,Hwdata,Haddr, Haddr1, Haddr2, Hwdata1, Hwdata2, Hwritereg, tempselx, Hreadyout, Pwrite, Penable, Pselx, Pwdata, Paddr, Prdata, /*Hrdata*/);

endmodule
