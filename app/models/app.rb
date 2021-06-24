class App
    attr_accessor :user_id, :password, :student_id
    def initialize()

    end

    def self.new_session()
        login
    end

    def login

    end
    def self.display_menu_and_get_input(output, message="Select a following option (type the number):")
        puts message
        output.each_with_index {|item, index| puts "#{index+1}. #{item}"}
        validated=false
        while(!validated)
            print 'Selection: '
            input=$stdin.gets.chomp.strip
            begin
                input=input.to_i
                if(input >0 && input <= output.length)
                    validated=true
                else
                    puts "Please enter an integer in the range. (1-#{output.length+1})"
                end
            rescue => exception
                puts "Invalid input, please enter an integer in the range."           
            end
        end
        #takes in array and outputs numerical selection (index of the array)
        return input-1
    end
end