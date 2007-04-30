
class DatePaginator
  attr_reader :items
  attr_reader :beginning
  
  def initialize(items, date_field, next_child=:months, beginning=nil, duration=nil)
      @items = items
      @date_field = date_field
      @next_child = next_child
      if beginning.nil? && items.length > 0
        @beginning = items[0].send(@date_field)
      else
        @beginning = beginning
      end
      @duration = duration
  end
  
  def ==(other)
    items == other.items
  end
  
  
  def children
    if !@next_child.nil?
      return self.send(@next_child)
   else
      return nil
   end
  end
  
  def months
    days_in_month = Proc.new {|m|  (Time.gm(m.year, m.month + 1) - Time.gm(m.year, m.month)) }
    @months = self.partition days_in_month, @beginning, :weeks
  end
  
  def weeks
    @weeks = self.partition 1.weeks, @beginning, :days 
  end #weeks
  
  def days
    @days = self.partition 1.days, @beginning
  end #days   

  def partition duration, beginning = nil, next_child = nil
    
    partition = Array.new
    
    if beginning.nil? then beginning = @beginning end
    if next_child.nil? then next_child = @next_child end
    
    
    if @items.length > 0
      if duration.kind_of? Proc
        d = duration.call(beginning)
        unit = DatePaginator.new Array.new, @date_field, next_child, beginning, d
        beginning -= d
      else
        unit = DatePaginator.new Array.new, @date_field, next_child, beginning, duration
        beginning -= duration
      end
      
      partition << unit
      i = 0  
      while i< @items.length 
      
        item = @items[i]           
        
        item_date = item.send @date_field
        if item_date >= beginning
          unit.items << item
          i+=1
        else
         if duration.kind_of? Proc
            d = duration.call(beginning)
            unit = DatePaginator.new Array.new, @date_field, next_child, beginning, d
            beginning -= d
          else
            unit = DatePaginator.new Array.new, @date_field, next_child, beginning, duration
            beginning -= duration
          end 
          partition << unit
        end #if
      end #while
    end
      #pad end if required
      if !@beginning.nil? && !@duration.nil? && beginning > @beginning - @duration
        if duration.kind_of? Proc
          d = duration.call(beginning)
          pad = ((beginning - (@beginning - @duration)).to_i / (d*1.0)).ceil
        else
          pad = ((beginning - (@beginning - @duration)).to_i / (duration*1.0)).ceil
        end 
        partition = partition.concat Array.new(pad) { |i| DatePaginator.new Array.new, @date_field, next_child, beginning-=duration, duration }
      end
    return partition
  end
end
  
