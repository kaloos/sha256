require 'TBPadding'

STR_OUTPUT_LENGTH = 256
ARR_H = [ "6a09e667" , "bb67ae85" , "3c6ef372" , "a54ff53a", "510e527f", "9b05688c", "1f83d9ab", "5be0cd19"]
ARR_K = ["428a2f98","71374491", "b5c0fbcf", "e9b5dba5", "3956c25b", "59f111f1", "923f82a4", "ab1c5ed5",
        "d807aa98", "12835b01", "243185be", "550c7dc3", "72be5d74", "80deb1fe", "9bdc06a7", "c19bf174",
        "e49b69c1", "efbe4786", "0fc19dc6", "240ca1cc", "2de92c6f", "4a7484aa", "5cb0a9dc", "76f988da",
        "983e5152", "a831c66d", "b00327c8", "bf597fc7", "c6e00bf3", "d5a79147", "06ca6351", "14292967",
        "27b70a85", "2e1b2138", "4d2c6dfc", "53380d13", "650a7354", "766a0abb", "81c2c92e", "92722c85",
        "a2bfe8a1", "a81a664b", "c24b8b70", "c76c51a3", "d192e819", "d6990624", "f40e3585", "106aa070",
        "19a4c116", "1e376c08", "2748774c", "34b0bcb5", "391c0cb3", "4ed8aa4a", "5b9cca4f", "682e6ff3",
        "748f82ee", "78a5636f", "84c87814", "8cc70208", "90befffa", "a4506ceb", "bef9a3f7", "c67178f2"]

class TBAddress
    attr_reader     :a
    attr_reader     :b
    attr_reader     :c
    attr_reader     :d
    attr_reader     :e
    attr_reader     :f
    attr_reader     :g
    attr_reader     :h
    attr_reader     :int_hash_value
    attr_reader     :tb_pad
    attr_reader     :arr_w

    def initialize(input_string)
        if input_string != nil then
            @int_hash_value = []
            @arr_w = []
            @tb_pad = TBPadding.new(input_string)
            @tb_pad.compute()
        end
    end
    def compute_sum1(x)
        compute_sshift_by_n(x,6) ^ compute_sshift_by_n(x,11) ^ compute_sshift_by_n(x,25)
    end
    def compute_sum0(x)
       compute_sshift_by_n(x,2) ^ compute_sshift_by_n(x,13) ^ compute_sshift_by_n(x,22)
    end
    def compute_ch(x,y,z)
        (x & y) ^ (~x & z)
    end
    def compute_maj(x,y,z)
        (x & y) ^ (x & z) ^ (y & z)
    end
    def compute_w(j,n)
        #puts "j=#{j} n=#{n} last_block=#{last_block}"
        if j<=15 then
            @arr_w[j] = @tb_pad.get_a_64_bit_block(j,n).to_i(16)
        else
            wj_2 = @arr_w[j-2]
            wj_7 = @arr_w[j-7]
            wj_15 = @arr_w[j-15]
            wj_16 = @arr_w[j-16]
            @arr_w[j] = sum32(sum32(sum32(compute_sigma1(wj_2),wj_7),compute_sigma0(wj_15)),wj_16)
        end
        @arr_w[j]
    end
    def compute_rshift_by_n(x,n)
        (x >> n)
    end
    def compute_sshift_by_n(x,n)
        (x >> n) | (x << (32 - n)) & 0xFFFFFFFF
    end
    def compute_sigma0(x)
        compute_sshift_by_n(x,7) ^ compute_sshift_by_n(x,18) ^ compute_rshift_by_n(x,3)
    end
    def compute_sigma1(x)
        compute_sshift_by_n(x,17) ^ compute_sshift_by_n(x,19) ^ compute_rshift_by_n(x,10)
    end
    def calc_T1(j,n)
        #puts "calc_T1:     intH=#{@h.to_s(16)} intE=#{@e.to_s(16)} intF=#{@f.to_s(16)} intG=#{@g.to_s(16)} ARR_K[j].to_i(16)=#{ARR_K[j].to_i(16)} intW[i]=#{compute_w(j,n)}"
        #puts "calc_T1:     SigmaA1(intE)=#{compute_sum1(@e).to_s(16)} SCh(intE, intF, intG)=#{compute_ch(@e,@f,@g).to_s(16)}"
        sum32(sum32(sum32(sum32(@h,compute_sum1(@e)),compute_ch(@e,@f,@g)),ARR_K[j].to_i(16)),compute_w(j,n))
    end
    def calc_T2()
        sum32(compute_sum0(@a),compute_maj(@a,@b,@c))
    end
    def sum32(a,b)
        (a+b)%(2**32)
    end

    def hash()
        if @int_hash_value==[] then
            for i in 0..7
                @int_hash_value << ARR_H[i].to_i(16)
            end
            n = @tb_pad.num_blocks
            for i in 1..n
                #puts "Starting a block compute ..."
                #puts "--------------------------------------------------------"
                #Initialize registers a; b; c; d; e; f ; g; h with the (i-1)st intermediate hash value
                @a = @int_hash_value[0]
                @b = @int_hash_value[1]
                @c = @int_hash_value[2]
                @d = @int_hash_value[3]
                @e = @int_hash_value[4]
                @f = @int_hash_value[5]
                @g = @int_hash_value[6]
                @h = @int_hash_value[7]
                #puts "init: a: #{@a.to_s(16)} b: #{@b.to_s(16)} c: #{@c.to_s(16)} d: #{@d.to_s(16)} e: #{@e.to_s(16)} f: #{@f.to_s(16)} g: #{@g.to_s(16)} h: #{@h.to_s(16)}"
                for j in 0..63
                    #Apply the SHA-256 compression function to update registers a; b; : : : ; h
                    t1=calc_T1(j,i)
                    t2=calc_T2()
                    @h=@g
                    @g=@f
                    @f=@e
                    @e=sum32(@d,t1)
                    @d=@c
                    @c=@b
                    @b=@a
                    @a=sum32(t1,t2)
                    #puts "t1=#{t1.to_s(16)} t2=#{t2.to_s(16)}"
                    #puts "t=#{j}   a: #{@a.to_s(16)} b: #{@b.to_s(16)} c: #{@c.to_s(16)} d: #{@d.to_s(16)} e: #{@e.to_s(16)} f: #{@f.to_s(16)} g: #{@g.to_s(16)} h: #{@h.to_s(16)}"
                end
                #Compute the ith intermediate hash value H(i)
                @int_hash_value[0] = sum32(@a,@int_hash_value[0])
                @int_hash_value[1] = sum32(@b,@int_hash_value[1])
                @int_hash_value[2] = sum32(@c,@int_hash_value[2])
                @int_hash_value[3] = sum32(@d,@int_hash_value[3])
                @int_hash_value[4] = sum32(@e,@int_hash_value[4])
                @int_hash_value[5] = sum32(@f,@int_hash_value[5])
                @int_hash_value[6] = sum32(@g,@int_hash_value[6])
                @int_hash_value[7] = sum32(@h,@int_hash_value[7])
            end
        end
        # let's compute the final hash
        map_hashed = []
        map_hashed << (@int_hash_value[0]).to_s(16)
        map_hashed << (@int_hash_value[1]).to_s(16)
        map_hashed << (@int_hash_value[2]).to_s(16)
        map_hashed << (@int_hash_value[3]).to_s(16)
        map_hashed << (@int_hash_value[4]).to_s(16)
        map_hashed << (@int_hash_value[5]).to_s(16)
        map_hashed << (@int_hash_value[6]).to_s(16)
        map_hashed << (@int_hash_value[7]).to_s(16)
        map_hashed.map { |e| e.to_s.rjust(8,'0')[-8..-1]}.join
    end
end
