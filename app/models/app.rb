class App
  attr_accessor :user

  def self.new_session()
    app = self.new()
    app.main_sequence
  end

  def view_general_options
    choices=["Edit Account Info", "View My Chat Rooms", "Join a Chat Room", "Create New Chat Room", "Log Out"]
    response=App.display_menu_and_get_input(choices)
  end

  def main_sequence
    #display menu (login or create account)
    choices = ["Log In", "Create Account", "Quit"]
    response = App.display_menu_and_get_input(choices, "Welcome to BashIt! Select an option below to get started!")
    case response
    when 0
      self.login_sequence
    when 1
      self.create_account_sequence
    else
      return
    end
  end
  
  def login_sequence
    puts "Logging in...."
    login_count=0
    while(login_count < 3)    
        print("Enter your username:")
        username=$stdin.gets.chomp
        print("Enter your password:")
        password=$stdin.gets.chomp
        self.user=User.check_login(username:username, password:password)
        if(self.user) #user was found
            break
        else
            puts "Username or password incorrect."
        end
        login_count+=1
    end
    if(login_count==3)
        #return to main menu, failed 3 times
        puts "Login failed 3 times, returning to main menu..."
        self.main_sequence
    else
        self.view_general_options
    end
  end

  def create_account_sequence
    puts "Creating account...."
    print("First Name:")
    first_name = $stdin.gets.chomp
    print("Last Name:")
    last_name = $stdin.gets.chomp

    validated = false
    while (!validated)
      print "Enter your new username: "
      new_username = $stdin.gets.chomp
      if (!self.validate_alphaNum(new_username))
        puts "Please enter an alphanumeric username (a-z, A-Z, 0-9):"
      elsif (User.username_taken(new_username))
        puts "Username already taken!"
      else
        puts "Username Confirmed!"
        validated = true
      end
    end

    validated = false
    while (!validated)
      print "Enter your new password: "
      password = $stdin.gets.chomp

      print "Retype password to confirm: "
      second_entry = $stdin.gets.chomp

      if (password == second_entry)
        puts "Password Confirmed!"
        validated = true
      else
        puts "Passwords did not match, try again."
      end
    end

    User.create(username: new_username, password: password, first_name: first_name, last_name: last_name)

    puts "Account Created, returning to main page...."
    self.main_sequence
  end

  def validate_alphaNum(str)
    chars = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a
    str.chars.detect { |ch| !chars.include?(ch) }.nil?
  end

  def self.get_non_empty_input()
    input = ""
    while ((input = $stdin.gets.chomp) == "")
      puts "Please provide a non-empty input!"
    end
    return input
  end

  def self.display_menu_and_get_input(output, message = "Select a following option (type the number):")
    puts '#############################'
    puts message
    output.each_with_index { |item, index| puts "#{index + 1}. #{item}" }
    validated = false
    while (!validated)
      print "Selection: "
      input = $stdin.gets.chomp.strip
      begin
        input = input.to_i
        if (input > 0 && input <= output.length)
          validated = true
        else
          puts "Please enter an integer in the range. (1-#{output.length + 1})"
        end
      rescue => exception
        puts "Invalid input, please enter an integer in the range."
      end
    end
    #takes in array and outputs numerical selection (index of the array)
    return input - 1
  end
end