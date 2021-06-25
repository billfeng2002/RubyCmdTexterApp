class App
  attr_accessor :user_id, :current_room

  def user
    User.find_by(id: @user_id)
  end

  def self.new_session()
    app = self.new()
    app.main_sequence
  end

  def view_general_options
    choices = ["Edit Account Info", "View My Chat Rooms", "Join a Chat Room by Code", "Create New Chat Room", "Log Out"]
    response = App.display_menu_and_get_input(choices, show_name: "Hi #{self.user.first_name}!")
    case response
    when 0
      puts "Editing account info..."
      self.edit_account_info
    when 1
      puts "Listing chatrooms...."
      self.chatroom_listing
    when 2
      self.join_chatroom
    when 3
      self.create_chatroom
    when 4
      self.clear_data
      self.main_sequence
    end
  end

  def chatroom_listing
    rooms = self.user.chatrooms
    display_rooms = rooms.map do |room|
      "#{room.name} (#{room.room_code})"
    end

    display_rooms << "Go back"

    response = App.display_menu_and_get_input(display_rooms, "Choose a room to inspect, or go back:")

    if response == rooms.size
      self.view_general_options
    else
      self.current_room = rooms[response]
      # next screen
      self.room_menu
    end
  end

  def room_menu
    is_owner = self.current_room.owner_id = self.user.id
    if (is_owner)
      choices = ["View Room Details", "Enter Chatroom", "Manage Room (Owner)", "Leave Room", "Back"]
    else
      choices = ["View Room Details", "Enter Chatroom", "Leave Room", "Back"]
    end

    response = App.display_menu_and_get_input(choices, "Choose a room to inspect, or go back:")

    if (is_owner)
      case response
      when 0
        self.view_room_details
      when 1
        self.chatroom_view
      when 2
        self.manage_room
      when 3
        self.leave_room
      when 4
        self.current_room = nil
        self.chatroom_listing
      end
    else
      case response
      when 0
        self.view_room_details
      when 1
        self.chatroom_view
      when 2
        self.leave_room
      when 3
        self.current_room = nil
        self.chatroom_listing
      end
    end
  end

  def leave_room
    #have confirmation, if owner, must reassign
    if (self.current_room.owner_id == self.user_id)
      puts "Sorry, please assign the new owner in Manage Users before leaving."
      sleep(1)
      self.room_menu
    else
      print "Are you sure you want to leave this room? (Y for yes):"
      input = $stdin.gets.chomp
      if (input == "Y")
        Userchatroom.find_by(user_id: self.user.id, chatroom_id: self.current_room.id).destroy
        puts "Successfully left room \"#{self.current_room.name}\". Returning to room selection..."
        sleep(1)
        self.current_room = nil
        self.chatroom_listing
      else
        puts "Operation cancelled..."
        sleep(1)
        self.room_menu
      end
    end
  end

  def manage_room
    #option to kick members, add members, change password, change name
    choices = []
  end

  def chatroom_view
    #view past messages, enter to refresh, type and enter to send a message, type "quit" to return

    self.print_past_messages
    n=50 #default messages to display
    puts "Type a message and enter to send, Enter to refresh, type '.config <num>' to display the last <num> messages, or type 'quit' to exit."
    input = $stdin.gets.chomp
    while (input != "quit")
      error=false
      if((input.length > '.config '.length) && input[0...8]=='.config ')
        rest=input[8..]
        begin
            if(rest.to_i>0)
                n=rest.to_i
            else
                error=true
            end
        rescue => exception
            error=true
        end
      elsif (input != "")
        self.sendMessage(input)
      end
      self.print_past_messages(n)
      puts "Previous invalid usage of .config, use as such: '.config 100' to display 100 previous messages." if error
      puts "Type a message and enter to send, Enter to refresh, type '.config <num>' to display the last <num> messages, or type 'quit' to exit."
      input = $stdin.gets.chomp
    end
    puts "Exiting...."
    sleep(1)
    self.room_menu
  end

  def sendMessage(input)
    Message.create(user_id: self.user.id, chatroom_id: self.current_room.id, value: input)
  end

  def clear_screen
    puts "\n" * 200
  end

  def print_past_messages(n = 50)
    self.clear_screen
    puts "-----Displaying Last #{n} Messages-----"
    if(n==0)
        puts "------------End of Messages------------"
        return
    end
    messages = self.current_room.last_n_messages(n)
    max_prefix_length = messages.max_by{ |message| message[0].length }[0].size
    #binding.pry
    messages.each {
      |message|
      print(message[0])
      print(" " * (max_prefix_length - message[0].length))
      puts(">> " + message[1])
    }
    puts "------------End of Messages------------"
  end

  def view_room_details
    #shows users sorted by most active, shows room name and code, shows owner
    users = Chatroom.user_activity.map { |each_user| each_user.name }
    
    display_arr = users.map { |each_user| "#{each_user} #{self.current_room} #{self.current_room.code} #{User.find_by(id: self.current_room.owner_id.name)}" 
    #implement

    print ("Press enter to continue...")
    $stdin.gets
    self.room_menu # return
  end

  def create_chatroom
    puts "Creating new chatroom..."
    print "Enter Room Name:"
    room_name = App.get_non_empty_input("Enter Room Name:")
    print "Enter Room Code:"
    room_code = App.get_non_empty_input("Enter Room Code:")
    while (Chatroom.find_by(room_code: room_code) != nil)
      puts "Room code already taken! Try again."
      print "Enter Room Code:"
      room_code = $stdin.gets.chomp
    end
    print "Enter Room Password(Press enter if none):"
    room_password = $stdin.gets.chomp
    chatroom = Chatroom.create(name: room_name, password: room_password, room_code: room_code, owner_id: self.user.id)
    Userchatroom.create(user_id: self.user.id, chatroom_id: chatroom.id)
    puts "Chatroom #{room_name} (code: #{room_code}) created!"
    sleep(1)
    self.view_general_options
  end

  def join_chatroom
    print "Enter room code:"
    room_code = $stdin.gets.chomp
    print "Enter room password(Enter if none):"
    password = $stdin.gets.chomp

    result = Chatroom.find_chatroom(code: room_code, password: password)

    if (!result)
      puts "Room not found."
    elsif (self.user.chatrooms.include?(result))
      puts "Already in this room!"
    else
      Userchatroom.create(user_id: self.user.id, chatroom_id: result.id)
      puts "Room #{result.name} (code: #{room_code}) successfully joined!"
    end
    sleep(1)
    self.view_general_options
  end

  def edit_account_info
    choices = ["Change password", "Change first name", "Change last name", "Done"]
    response = App.display_menu_and_get_input(choices, show_name: "Name: #{self.user.full_name}  Username: #{self.user.username}  Password: ********")
    case response
    when 0
      print "Old password:"
      password = $stdin.gets.chomp
      if (password == self.user.password)
        puts "Password Verified!"
        puts "Enter new password:"
        self.user.password = App.get_non_empty_input("Enter new password:")
        self.user.save
        puts "Password saved!"
      else
        puts "Password incorrect"
      end
      self.edit_account_info
    when 1
      print "New First Name:"
      first_name = $stdin.gets.chomp
      print "Are you sure you want to change your name to #{first_name}? (type Y for yes)"
      confirmation = $stdin.gets.chomp
      if (confirmation == "Y")
        self.user.first_name = first_name
        self.user.save
        puts "First name changed..."
      else
        puts "Operation cancelled..."
      end
      self.edit_account_info
    when 2
      print "New Last Name:"
      last_name = $stdin.gets.chomp
      print "Are you sure you want to change your name to #{last_name}? (type Y for yes)"
      confirmation = $stdin.gets.chomp
      if (confirmation == "Y")
        self.user.last_name = last_name
        self.user.save
        puts "First name changed..."
      else
        puts "Operation cancelled..."
      end
      self.edit_account_info
    when 3
      self.view_general_options
    end
  end

  def clear_data
    self.user = nil
    self.current_room = nil
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
    login_count = 0
    while (login_count < 3)
      print("Enter your username:")
      username = $stdin.gets.chomp
      print("Enter your password:")
      password = $stdin.gets.chomp
      user = User.check_login(username: username, password: password)
      if (user) #user was found
        self.user_id=user.id
        break
      else
        puts "Username or password incorrect."
      end
      login_count += 1
    end
    if (login_count == 3)
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

  def self.get_non_empty_input(prompt = "")
    input = ""
    input = $stdin.gets.chomp
    while (input == "")
      puts "Please provide a non-empty input!"
      print prompt
      input = $stdin.gets.chomp
    end
    return input
  end

  def self.display_menu_and_get_input(output, message = "Please select one of the following options (type the number):", show_name: nil)
    puts "#############################"
    if (show_name)
      puts "#{show_name}"
    end
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
