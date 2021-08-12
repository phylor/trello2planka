module Trello2planka
  module Converters
    class Label
      def initialize(trello_label)
        @trello_label = trello_label
      end

      def name
        return color if !@trello_label.name || @trello_label.name == ''

        @trello_label.name
      end

      def color
        case @trello_label.color
        when 'green' then 'wet-moss'
        when 'yellow' then 'egg-yellow'
        when 'orange' then 'pumpkin-orange'
        when 'red' then 'berry-red'
        when 'purple' then 'red-burgundy'
        when 'blue' then 'navy-blue'
        when 'sky' then 'morning-sky'
        when 'lime' then 'sunny-grass'
        when 'pink' then 'pink-tulip'
        when 'black' then 'gun-metal'
        when 'null' then 'light-concrete'
        end
      end
    end
  end
end
