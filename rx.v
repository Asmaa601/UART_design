// reciever module for UART

module rx_uart(
input clk, rst, enable ,clk_handle,
output reg [7:0] rx_data_o,
input  rx_bit,
output  Ready,bit 
);


//reg rx_bit;
reg [1:0]state, next_state;
parameter IDLE = 2'b00, START = 2'b01, DATA =2'b10, STOP = 2'b11; 
reg [2:0] index = 3'b0;
reg [7:0] rx_data;

//assign rx_data_o = rx_data;
assign Ready = (state == IDLE);
assign bit = rx_data[1]; 

always @(posedge clk, negedge rst)
begin
if (!rst) state <= IDLE;
else begin state <= next_state; if (state == STOP) rx_data_o <= rx_data; end 
end

always @ (posedge clk)
begin
case (state)
IDLE: begin 
     if (enable) begin next_state <= START;  index <= 3'b0;
     end 
      end
START: begin
     if (clk_handle) begin rx_data <= 8'b0; next_state <= DATA; end 
     end
DATA: begin 
    if (clk_handle) begin rx_data[index] <= rx_bit ; 
                        if (index == 3'h7) begin   next_state <= STOP; end 
                        else  begin index <= index + 3'b1;  next_state <= DATA; end 
                    end 
     end
STOP: begin 
    if (clk_handle)begin rx_data <= rx_data; next_state <= IDLE; end 
    end
default: begin 
    rx_data = 8'b0; next_state = IDLE; 
    end
endcase 
end 
endmodule
