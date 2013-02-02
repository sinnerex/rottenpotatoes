class Movie < ActiveRecord::Base

 def self.getAvailableRatings(selected)
  #hash_selected=Hash[selected.collect{|sel| [sel, sel]}]
  selected != nil ? [['G',selected['G']!=nil],['PG',selected['PG']!=nil],['PG-13', selected['PG-13']!=nil],['R', selected['R']!=nil]] : [['G',true],['PG',true],['PG-13', true],['R', true]]
 end

end
