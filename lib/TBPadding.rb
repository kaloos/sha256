class TBPadding
    attr_reader     :str_in
    attr_reader     :bytes_out
    attr_reader     :num_blocks
    
    def initialize (str_in)
        if str_in != nil then
            @str_in = str_in
            @bytes_out = []
            @num_blocks = -1
        end
    end
    def get_a_64_bit_block(i,in_num_block)
        #let's be careful, we are dealing with bits and not with bytes
        pos_start = (in_num_block-1)*128+(i*8)
        @bytes_out.join[pos_start..7+pos_start]
    end
    def compute()
        if str_in == nil then
            return nil
        end
        if @bytes_out != [] then
            return @bytes_out
        end
        @str_in.bytes.each {|bb| @bytes_out << bb.to_s(16)}
        original_length = (@str_in.bytes.length * 8).to_s(16).to_i(16)
        # rules to follow:
        # k=(447-str_in.length*8)%512
        # n=(k+1)/8-1
        # final=8*str_in.length+(1+n)*8+64
        k=(447-original_length)%512
        n=(k+1)/8-1
        #puts "k is #{k} and n is #{n}"
        @num_blocks = (original_length +1 +k + 64)/512
        @bytes_out.push('80')
        n.times {@bytes_out <<'00'}
        num_zeros_to_append = 16-original_length.to_s(16).length
        @bytes_out << "0"*num_zeros_to_append + original_length.to_s(16)
    end
end
