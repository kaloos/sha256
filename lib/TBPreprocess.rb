




class TBPreprocess
    attr_reader     :str_to_hash
    attr_reader     :str_hashed
    attr_reader     :pos_first_append
    attr_reader     :num_blocks
    
    def initialize (input_string)
        @str_to_hash = input_string
        @str_hashed = nil
        @pos_first_append = @num_blocks = -1
    end
    

    def do_the_preprocessing()
        @str_hashed = @str_to_hash
        #do: @str_hashed = @str_to_hash.unpack('H*')
        self.first_append()
        self.second_append()
        self.third_append()
        @num_blocks = (@str_hashed.length * 8)/512
        @str_hashed
    end
    
    def first_append()
        #str.unpack("H*").first+"8"    
        #append one bit with a value of "1"
        #@str_hashed = str.unpack("H*").first+"8"
        bin_aux = (@str_to_hash.unpack("B*")[0].to_i(2)<<1)|1
        @str_hashed = ["0" + bin_aux.to_s(2)].pack("B*")
        end
    
    def second_append()
        #append k zero bits
        k=(448-1-@str_to_hash.length*8)%512
        @str_hashed = @str_hashed + [(2**k).to_s(2)[1..-1]].pack('B*')
    end
    
    def third_append()
        val_64=2**64
        fin=@str_to_hash.length*8+val_64
        fin2=fin.to_s(16)
        @str_hashed = @str_hashed +fin2[10..-1]
    end
    def get_a_32_bit_block(i)
        #let's be careful, we are dealing with bits and not with bytes
        @str_hashed[i*4..3+i*4]
    end
    
    
end
