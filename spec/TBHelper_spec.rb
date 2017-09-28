=begin
require 'TBHelper'

RSpec.describe 'A short helper address' do
    before :each do
        @tb_helper = TBHelper.new("abc")
        @tb_helper.do_the_preprocessing()
    end
    it 'first append should have a length of 1' do
        expect(@tb_helper.str_first_append.length).to eq(1)
    end
    it 'second append should have a length of 447 or less' do
        expect(@tb_helper.str_second_append.length).to be<=INTERMEDIATE_LENGTH-1
    end
    it 'third append should have a length of 8' do
        expect(@tb_helper.str_third_append.length).to eq(8)
    end
    it 'should have a length of a multiple of 512 bits' do
        n_number = @tb_helper.str_hashed.length%(THIRD_INTERMEDIATE_LENGTH)
        expect(n_number).to eq(0)
   end
    it 'should have a single block' do
        expect(@tb_helper.first_block.length!=0 && @tb_helper.remaining_blocks.length==0)
    end
    it 'should have the string length in its first 64 bytes' do
        expect(convert_bin_to_i(@tb_helper.str_third_append) == @tb_helper.str_to_hash.length)
    end
    
end

RSpec.describe 'A long helper address' do
    before :each do
        @tb_helper = TBHelper.new("a"*54+"b")
        @tb_helper.do_the_preprocessing()
    end    
    it 'should have a length of a multiple of 512 bits' do
        n_number = @tb_helper.str_hashed.length%(THIRD_INTERMEDIATE_LENGTH)
        expect(n_number).to eq(0)
   end
    it 'should have more than a single block' do
        @tb_helper.do_the_preprocessing()
        expect(@tb_helper.first_block.length!=0 && @tb_helper.remaining_blocks.length!=0)
    end
    it 'should have the string length in its first 64 bytes' do
        expect(convert_bin_to_i(@tb_helper.str_third_append) == @tb_helper.str_to_hash.length*8)
    end
end

RSpec.describe 'A long helper address (2)' do
    before :each do
        @tb_helper = TBHelper.new("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
        @tb_helper.do_the_preprocessing()
    end    
    it 'should have a length of a multiple of 512 bits' do
        n_number = @tb_helper.str_hashed.length%(THIRD_INTERMEDIATE_LENGTH)
        expect(n_number).to eq(0)
   end
end
=end

   