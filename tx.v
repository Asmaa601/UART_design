// transmitter module for UART

module tx_uart(
input clk, rst, enable ,clk_handle,
input [7:0] tx_data_i,
output  tx_bit_o,
output  Ready 
);


reg tx_bit;
reg [1:0]state, next_state;
parameter IDLE = 2'b00, START = 2'b01, DATA =2'b10, STOP = 2'b11; 
reg [2:0] index = 3'b0;
reg [7:0] tx_data;

assign tx_bit_o = tx_bit;
assign Ready = (state == IDLE);

initial begin tx_bit <= 1'b1; end
always @(posedge clk, negedge rst)
begin
if (!rst) state <= IDLE;
else state <= next_state; 
end

always @(posedge clk)
begin
case (state)
IDLE: begin 
     if (enable) begin next_state <= START; tx_data <= tx_data_i; index <= 3'b0;end 
      end
START: begin
     if (clk_handle) begin tx_bit <= 1'b0;  next_state <= DATA; end 
     end
DATA: begin 
    if (clk_handle) begin tx_bit <= tx_data[index]; 
                        if (index == 3'h7) begin   next_state <= STOP; end 
                        else  index <= index + 3'b1; 
                    end 
     end
STOP: begin 
    if (clk_handle)begin tx_bit <= 1'b1; next_state <= IDLE; end 
    end
default: begin 
    tx_bit <= 1'b1; next_state <= IDLE; 
    end
endcase 
end 
endmodule
