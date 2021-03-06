require 'test_helper'

class CallsTest < ActionController::IntegrationTest
  fixtures :all

  test "should log the call if signed in" do
    # sign in
    user = User.new(:email => "test@test.com", :password => "abcdef", :password_confirmation => "abcdef")
    assert_difference('User.count') do
      user.save!
    end
    post_via_redirect 'users/sign_in'#, "email" => "test@test.com", "password" => "abcdef"

    assert_difference('Log.count') do
      post "calls/1/make_request"
    end
  end
  
  test "should not log the call if not signed in" do
    get_via_redirect 'users/sign_out'
    assert_no_difference('Log.count') do
      get 'calls/1/make_request'
    end
  end


##  Test recent_group_id
#  test "should show recent group if signed in and recent_group_id set, no tab selected" do
#    sign_in users(:one)
#    @tab = Group.find(users(:one).recent_group_id).name
#    get :index
#    assert_tag(:tag => 'li', :content => "#{@tab}", :attributes => {:class => 'active_tab'})
#    sign_out users(:one)
#  end

#  test "should show selected tab if signed in and recent_group_id set, but tab IS selected" do
#    sign_in users(:one)
#    @tab = "MyString" # this must *not* be users(:one)'s recent_group_id
#    get :index, :tab => @tab
#    assert_tag(:tag => 'li', :content => "#{@tab}", :attributes => {:class => 'active_tab'})
#    sign_out users(:one)
#  end

#  test "should show all tab if signed in and recent_group_id NOT set, no tab selected" do
#    sign_in users(:two)
#    # recent_group_id should not be assigned for user :two in the fixture, therefore nil
#    get :index
#    assert_tag(:tag => 'li', :content => 'all', :attributes => {:class => 'active_tab'})
#    sign_out users(:two)
#  end

#  test "should show the all tab if user not signed in" do
#    get :index
#    assert_tag(:tag => 'li', :content => 'all', :attributes => {:class => 'active_tab'})
#  end
#  
#  test "should show the selected tab if user not signed in, but tab IS selected" do
#    @tab = "MyString"
#    get :index, :tab => "#{@tab}"
#    assert_tag(:tag => 'li', :content => "#{@tab}", :attributes => {:class => 'active_tab'})
#  end

#  test "should show all tab if signed in and recent_group_id set, all tab selected" do
#    sign_in users(:one)
#    @tab = "all"
#    get :index, :tab => "#{@tab}"
#    assert_tag(:tag => 'li', :content => "#{@tab}", :attributes => {:class => 'active_tab'})
#    sign_out users(:one)
#  end

#  test 'should update user.recent_group_id when new tab selected' do
#    @user = users(:one)
#    sign_in @user
#    @current_tab = Group.find(@user.recent_group_id).name
#    
#    puts "current_tab = #{@current_tab}, id #{@user.recent_group_id}"
#    
#    get :index, :tab => "all" # this should set the new recent_group_id
#    
#    puts "\nnow getting index without the tab".yellow
#    
#    get :index
#    
#    puts "index with :tab => all called, @user.recent_group_id: #{@user.recent_group_id}"
#    
#    assert(@current_tab != Group.find(@user.recent_group_id).name)
#  end
# 
#  test 'should show the right tab when new tab selected' do
#    @user = users(:one)
#    sign_in @user
#    @current_tab = Group.find(@user.recent_group_id).name
#    
#    puts "current_tab = #{@current_tab}, id #{@user.recent_group_id}"
#    
#    get :index, :tab => groups(:one).to_param # this should set the new recent_group_id
#    get :index
#    
#    puts "index with :tab => #{groups(:one).name} called, @user.recent_group_id: #{@user.recent_group_id}"
#    
#    assert_no_tag(:tag => 'li', :content => "#{@current_tab}", :attributes => {:class => 'active_tab'})
#  end

  test 'search.present, tab.present, tab == all, recent_group_id.present' do
    # sign in
    @user = User.new(:email => "test@test.com", :password => "abcdef", :password_confirmation => "abcdef", :recent_group_id => 2)
    @user.save!
    post_via_redirect 'users/sign_in', "email" => "test@test.com", "password" => "abcdef"
    
#    puts "TEST: recent_group_id before: #{@user.recent_group_id}".red
    get '/calls', :tab => 'all', :search => 'uno'
    
    # assert that the all tab is active
    assert_tag(:tag => 'li', :content => 'All', :attributes => {:class => 'active_tab'})
    assert_tag(:tag => 'a', :content => 'uno')
#    @user.update_recent_group_id("") # cheating
    
    @user.reload
#    puts "TEST: recent_group_id after: #{@user.recent_group_id}".red
    assert(@user.recent_group_id == nil)
    
    puts "--Sign the user out"
    get_via_redirect 'users/sign_out'
  end
  
  
  
  test 'search.present, tab.present, tab == all, recent_group_id.nil' do
    # sign in
    @user = User.new(:email => "test@test.com", :password => "abcdef", :password_confirmation => "abcdef", :recent_group_id => nil)
    @user.save!
    post_via_redirect 'users/sign_in', "email" => "test@test.com", "password" => "abcdef"
    
#    puts "TEST: recent_group_id before: #{@user.recent_group_id}".red
    get '/calls', {:tab => 'all', :search => 'uno'}
    
    # assert that the all tab is active
    assert_tag(:tag => 'li', :content => 'All', :attributes => {:class => 'active_tab'})
    assert_tag(:tag => 'a', :content => 'uno')
#    puts "TEST: recent_group_id after: #{@user.recent_group_id}".red
    assert(@user.recent_group_id == nil)

    puts "--Sign the user out"
    get_via_redirect 'users/sign_out'
  end
  
  test 'params[:search].nil? && params[:tab].nil? && current_user.recent_group_id.nil?' do
    #  controller #12 should: should go to 'all' tab, set recent to 'all'
    
  end
  
  
  test 'delete tab that\'s someone\'s recent_group_id' do
    # create new group, save!
    # create new user with that recent group id
    # destroy the group
    # get the calls page
      # shouldn't error, should show the All tab as active
    flunk("not built yet")
  end
  
  
end
