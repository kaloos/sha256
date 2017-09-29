require 'TBPadding'

RSpec.describe 'A padded address' do
    before :each do
        @str_original = "abc"
        @original_bytes_length = (@str_original.bytes.length).to_s(16).to_i(16)
        @tb_pad = TBPadding.new(@str_original)
        @bytes_out = @tb_pad.compute()
        @str_padded = @bytes_out.join
        @num_blocks = @tb_pad.num_blocks
    end
    it 'should have appended a byte with value 1' do
        #str = @str_padded[2*@str_original.length..2*@str_original.length+1]
        str = @str_padded[2*@original_bytes_length..2*@original_bytes_length+1]
        expect(str).to eq("80")
    end
    it 'should have 0s are appended' do
        str = @str_padded[2*@original_bytes_length+2..-8]
        inum = str.to_i
        expect(inum).to eq(0)
    end
    it 'should have the length of the original string in its 64 bits' do
        original_length = @original_bytes_length*8
        calc_length = @str_padded[-7..-1].to_i(16)
        expect(original_length).to eq(calc_length)
    end
    it 'should have as end result a multiple of 512 bits' do
        padded_length = @str_padded.length
        multiple_length = padded_length %64
        expect(multiple_length).to eq(0)
    end
    it 'hashed twice should provide the same result' do
        bytes_hashed_twice = @tb_pad.compute()
        expect(@str_padded).to eq(bytes_hashed_twice.join)
    end
    it 'should have a positive number of blocks' do
        expect(@num_blocks).to be>=0
    end
    it 'should be able loop through its contents' do
        str_reconstructed = ""
        for i in 1..@num_blocks
            for j in 0..15
                str_reconstructed = str_reconstructed + @tb_pad.get_a_64_bit_block(j,i)
            end
        end
        expect(@str_padded).to eq(str_reconstructed)
    end
end
    [
    %w(abc 61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018),
    %w(abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq 6162636462636465636465666465666765666768666768696768696a68696a6b696a6b6c6a6b6c6d6b6c6d6e6c6d6e6f6d6e6f706e6f70718000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c0)
    ].each do |a,b|
      describe "Given input #{a}, check its padded string matches #{b}" do
        it "check they generate the same" do
            tb_pad = TBPadding.new(a)
            bytes_out = tb_pad.compute()
            str_padded = bytes_out.join
            expect(str_padded).to eq(b)
        end
      end
    end
