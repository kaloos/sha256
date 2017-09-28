=begin
require 'TBPreprocess'

RSpec.describe 'A preprocessed address' do
    before :each do
        @str_original = "abc"
        @tb_preprocess = TBPreprocess.new(@str_original)
        @str_hashed = @tb_preprocess.do_the_preprocessing()
    end
    it '1- first append should add a bit; the bit value should be 1' do
        str = @str_hashed[@str_original.length..@str_original.length+1]
        expect(str[0].force_encoding('UTF-8')).to eq("\x80".force_encoding('UTF-8'))
    end
    it '2- 0s are appended' do
    end
    it '3- the length of the original string is appended' do
        original_length = @str_original.length
        hashed_length = @str_hashed.length
        calc_length = @str_hashed[-7..-1].to_i(16)
        expect(original_length*8).to eq(calc_length)
    end
    it '4- the end result is a multiple of 512 bits' do
        hashed_length = @str_hashed.length
        multiple_length = hashed_length %64
        expect(multiple_length).to eq(0)
    end
    it '5- Hashing twice should provide the same result' do
        str_hashed_twice = @tb_preprocess.do_the_preprocessing()
        expect(@str_hashed).to eq(str_hashed_twice)
    end
    it 'should provide the offical expected result' do
        expect(@str_hashed).to eq("")
    end
end
=end

