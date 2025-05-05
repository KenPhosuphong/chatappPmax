require 'rails_helper'

RSpec.describe 'Room user list display', type: :system do
  before do

    puts "set up before testing"

    driven_by(:rack_test)

    @room = Room.create!(name: 'Test Room')

    @user1 = User.create!(username: 'Alice', email: 'alice@example.com', password: 'password')
    @user2 = User.create!(username: 'Bob', email: 'bob@example.com', password: 'password')

    @room.users << [@user1, @user2]

    Message.create!(content: "Welcome to the room!", user: @user1, room: @room)

    @room2 = Room.create!(name: 'Exclusive Room')

    @user3 = User.create!(username: 'Charlie', email: 'charlie@example.com', password: 'password')
    @user4 = User.create!(username: 'Dana', email: 'dana@example.com', password: 'password')

    @outsider = User.create!(username: 'Eve', email: 'eve@example.com', password: 'password')
    @room2.users << [@user3, @user4]

    Message.create!(content: "Room2 create!!", user: @user3, room: @room2)

    puts "create users and rooms completed"
    puts "start testing"
  end

  it 'Checks shows users in the room' do
    puts "Start testing to find display name if in room"
    visit "/messages?room_id=#{@room.id}"
    
    within('.room-Users') do
      expect(page).to have_content('Users :')
      expect(page).to have_content('Alice')
      expect(page).to have_content('Bob')

      puts "✅ Found both Alice and Bob!"

    end
    
  end
  
  it 'Does not show users not in the room' do
    puts "Start testing to find other display name if not in room" 
    visit "/messages?room_id=#{@room2.id}"

    within('.room-Users') do
      expect(page).to have_content('Charlie')
      expect(page).to have_content('Dana')
      expect(page).not_to have_content('Eve')
      
      puts "✅ Found Both peope but not found Eve! "

    end
  end
end
