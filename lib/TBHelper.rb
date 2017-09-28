
STR_TO_FIRST_APPEND                 = "\x80"
STR_TO_SECOND_APPEND               =  "\x00"
THIRD_INTERMEDIATE_LENGTH           = 64    #this is expressed in bits
INTERMEDIATE_LENGTH                 = 448
BYTE_LENGTH                         = 8
MAX_LENGTH_TO_HAVE_SEVERAL_BLOCKS   = 446   #this is expressed in bits
BLOCK_SIZE                          = 512   #this is expressed in bits

def convert_i_to_bin (input_number)
    str_in = input_number.to_s(2)
    #add enough 0s to str_in to be a muiltiple of 8
    str_in = "0"*(8-str_in.length%8) + str_in
    str_out = ""
    i=0
    j=0
    while j<(str_in.length/8) do
        #we iterate from byte to byte
      str_aux = str_in [i..i+7]
      i = i +8
      j = j+1
      str_out << str_aux.to_i(2).chr
    end
    str_out
end

def convert_bin_to_i (str_input_number)
    str_aux=str_input_number.unpack('B*')[0].to_i(2)
end


#class TBHelper<String
class TBHelper
    attr_reader     :str_to_hash
    attr_reader     :num_blocks
    attr_reader     :first_block
    #attr_reader     :remaining_blocks
    #attr_reader     :str_first_append
    attr_reader     :str_second_append
    attr_reader     :str_third_append
    attr_reader     :str_hashed
    
    def initialize (input_string)
        @str_to_hash = input_string
        @num_blocks = 0
        @first_block = @str_second_append = @str_third_append = ""
        @str_hashed = nil
    end

    def number_to_s(in_number)
        str_out=""
        
        in_number.to_s(2).each_byte do |a_byte|
            str_out = str_out<<
            if a_byte == "\x80" then
                str_out=(str_out | ("\x00"*7+"\x01"))
            end
        end
    
        return str_out
    end
    
    def do_the_preprocessing()
        #all the following is calculated in BIT size and NOT IN BYTES
    i_1=1
    k=(448-1-@str_to_hash.length*8)%512
    i_2=k
    i_3=64
    #is i_1 in the first block?
    if i_1+i_2+i_3>=512 then
        i_0=0
    else
        i_0=512-i_1-i_2-i_3
    end
    i_prev=str_in.length*8-i_0
    total_size=i_prev+i_0+i_1+i_2+i_3
    @num_blocks=total_size/512
        
        
        length_str0=@str_to_hash.length*8
        str_aux=""
        num_aux=0
        length_str0.to_s(16).each_byte do |c|
            str_aux=str_aux+STR_TO_SECOND_APPEND+c.chr
        end
        @str_third_append=STR_TO_SECOND_APPEND*(64-@first_block.length-k-2)+(convert_i_to_bin(@str_to_hash.length*8))
        @str_hashed=@remaining_blocks+@first_block+@str_first_append+@str_second_append+@str_third_append
        
        
    end
    
    def show_the_internals()
        puts "The string to preprocess is: #{self.str_to_hash}"
        puts "The first block is: #{self.first_block} and its length is #{self.first_block.length}"
        puts "The first append is: " + self.str_first_append + " and its length is #{self.str_first_append.length}"
        puts "The second append is: #{self.str_second_append} and its length is #{self.str_second_append.length}"
        puts "The third append is: #{self.str_third_append} and its length is #{self.str_third_append.length}"
        puts "The remaining block is: #{self.remaining_blocks} and its length is #{self.remaining_blocks.length}"
        puts "The processed string is: #{self.str_hashed} and its length is #{self.str_hashed.length}"
        self.str_hashed
    end
    
end



def calculate_lengths_new (str_in)
    #all the following is calculated in BIT size and NOT IN BYTES
    i_1=1
    k=(448-1-str_in.length*8)%512
    i_2=k
    i_3=64
    #is i_1 in the first block?
    if i_1+i_2+i_3>=512 then
        i_0=0
    else
        i_0=512-i_1-i_2-i_3
    end
    i_prev=str_in.length*8-i_0
    total_size=i_prev+i_0+i_1+i_2+i_3
    num_blocks=total_size/512
    
    puts "The string preprocessed has prev:#{i_prev} 0:#{i_0} 1:#{i_1} 2:#{i_2} 3:#{i_3} for a total of #{total_size} bits"
    puts "There are #{num_blocks} blocks exact #{total_size%512}"
    return i_prev+i_0+i_1+i_2+i_3
end

calculate_lengths_new("")
calculate_lengths_new("abc")
calculate_lengths_new("a"*254)
calculate_lengths_new("a"*255)
calculate_lengths_new("a"*256)
calculate_lengths_new("a"*1000)
  