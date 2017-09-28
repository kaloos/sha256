require 'TBAddress'

RSpec.describe 'An address' do
    
    before :each do
        @str_original = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
        @tb_address = TBAddress.new(@str_original)
        @str_hashed = @tb_address.hash_compute()
    end
    it 'should have a 64 bit length' do
        expect(@str_hashed.length).to eq(64)
    end
    it 'should provide the same result if computed twice' do
        str_hashed_twice = @tb_address.hash_compute()
        expect(@str_hashed).to eq(str_hashed_twice)
    end
    it 'should provide the offical expected result' do
        expect(@str_hashed).to eq("248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")
    end
    
end

    [
    %w(abc ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad),
    %w(abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq 248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1),
    %w(+ñíol?;.*á¨Ç fa265081917c72f9e554dad73a493f90824bfdf42e87de40b41539687e740b57),
    %w(klnaclkanscvlkaCSLNwlcvkLKVNdvlkVlwkvldFKVELK e6ce888a128e8e603ffb39e0434f2df4b81a7e9e23589f8fb238a9b8da51a908),
    %w(+ñíol?;.*á¨Çmmmmmlkjljljoiu"·$·"$"%wdvcbnmjkuy8o96586rrº11 9ddf3edeab5d1fce0e5c437fb21b577c467d7336bfbae74994c70f1aac33f217)
    ].each do |a,b|
      describe "Given input #{a}, check its SHA256 hash matches #{b}" do
        it "check they generate the same" do
            tb_address = TBAddress.new(a)
            str_hashed = tb_address.hash_compute()
            expect(str_hashed).to eq(b)
        end
      end
    end
