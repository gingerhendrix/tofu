
  module DatePagination
    class WeekPaginator
      attr_reader :items
      attr_reader :beginning
      
      def initialize(items, date_field)
          @items = items
          @date_field = date_field
      end
      
      def weeks
        if @weeks 
          return @weeks
        end
        item_counter = 0
        @weeks = Array.new
        
        if @items.length > 0
          week_beginning = (items[0].send @date_field).beginning_of_week
          week = Week.new week_beginning, @date_field
          @weeks << week
          
          @items.each do |item|
            item_date = item.send @date_field
            if item_date >= week_beginning
              week.items << item
            else
              week_beginning -= 1.week 
              week = Week.new week_beginning, @date_field
              @weeks << week
              week.items << item
            end #if
          end #each
        end

        return @weeks
      end #weeks
      
      alias children weeks 
      
      class Week
        attr_accessor :items
        attr_accessor :beginning
        def initialize(beginning, date_field)
          @date_field = date_field
          @beginning = beginning
          @items = []
        end
        
        def days
          if @days 
            return @days
          end
        item_counter = 0
        @days = Array.new(7) do |i|
          day_beginning = (@beginning + (6-i).days)
          day = Day.new day_beginning
          skip = false
          while (!skip && item_counter < @items.length)
            item = items[item_counter]
            item_date = item.send @date_field
            if item_date >= day_beginning
              day.items << item
              item_counter+=1
            else
              skip = true
            end #if
          end #while
          day
        end #Array.new
        @days
        end #days
      
        alias children days
      end #Week
      
      class Day
        attr_accessor :items
        attr_accessor :beginning
        def initialize(beginning)
           @items = []
           @beginning = beginning
        end
      end
    end #WeekPaginator
  end #DatePagination
