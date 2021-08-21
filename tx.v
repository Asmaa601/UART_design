// transmitter module for UART

module tx_uart(
input clk, rst, enable ,
input [7:0] tx_data,
output reg tx_bit 
);

reg state, next_state;
parameter IDLE = 1'b0, SEND = 1'b1; 
integer count=0 ,start_bit = 0;   

// sequential logic
always @(posedge clk or negedge rst)
begin
    if (!rst) state <= 1'b0;
    else state <= next_state;
end

// set states of the UART transmitter
always @(*)
begin
    case (state)
    IDLE: begin 
        if (enable) next_state = SEND ;
        else next_state = IDLE;
         end
    SEND: begin if (count == 8) next_state = IDLE; 
         else next_state = SEND;
          end
    endcase
end

// define each state job
always @(*)
begin
    case (state)
    IDLE: begin tx_bit = 1'b0; end
    SEND: begin 
        if (count && start_bit ==0 ) begin tx_bit =1'b1; start_bit = 1;end 
        else begin tx_bit = tx_data[count]; count = count + 1; end
        end
    endcase
end
endmodule