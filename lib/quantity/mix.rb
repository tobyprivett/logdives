class Mix
  attr_reader :mix_type, :o2, :n2, :he

   def initialize(mix_type='Air', o2=21, he=0, n2=79)
    @mix_type, @o2, @n2, @he = mix_type, o2.to_i, n2.to_i, he.to_i
   end

   def to_s
      return "#{mix_type} #{o2}/#{he}" if @n2 == 0 &&  @he > 0
      return "#{mix_type} #{o2}/#{he}" if @he > 0
      return "#{mix_type} #{o2}" if @o2 > 21
      mix_type
   end
end
