require File.dirname(__FILE__) + '/../test_helper'

class ContextStorageTest < Test::Unit::TestCase
  include ConsoleRtm

  def setup
    @st = ContextStorage.new('rtm_console_tmp.store', 2)
  end

  def teardown
    File.delete 'rtm_console_tmp.store'
  end

  def test_can_save_and_get_list_name
    @st.save_list_name(1, "Home")
    @st.save_list_name(2, "Work")
    assert_equal "Home", @st.get_list_name(1)
    assert_equal "Work", @st.get_list_name(2)
    assert_equal nil, @st.get_list_name(3)
  end

  def test_can_save_and_get_list_id
    @st.save_list_name(1, "Home")
    @st.save_list_name(2, "Work")
    assert_equal 1, @st.get_list_id("Home")
    assert_equal 2, @st.get_list_id("Work")
    assert_equal nil, @st.get_list_id("Income")
  end

  def test_shares_state_between_instances
    @st.save_list_name(1, "Home")
    st2 = ContextStorage.new('rtm_console_tmp.store')
    assert_equal 1, st2.get_list_id("Home")
  end

  def test_can_save_and_get_list_of_tasks
    tasks = [Task.new(1, "text", "Home"), Task.new(2, "text2", "Work")]
    @st.save_tasks tasks
    tasks_restored = @st.get_tasks
    assert_equal tasks, tasks_restored
  end

  def test_can_save_command_history
    @st.add_to_history "one"
    @st.add_to_history "two"
    assert_equal ['two', 'one'], @st.get_history
    
    @st.add_to_history "three"
    assert_equal ['three', 'two'], @st.get_history
  end
end