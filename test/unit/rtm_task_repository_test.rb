require File.dirname(__FILE__) + '/../test_helper'

class RtmTaskRepositoryTest < Test::Unit::TestCase
  include ConsoleRtm

  def setup
    list_repo = flexmock("list_repo")
    list_repo.should_receive(:get_list_name_by_id).and_return("Home")
    list_repo.should_receive(:get_list_id_by_name).and_return(1)
    @repo = flexmock(RtmTaskRepository.new(list_repo))
  end

  def test_repo_creates_string_filter_expression
    @repo.should_receive(:all_tasks_filtered).with("status:completed and due:today").and_return([])
    @repo.get_tasks(:status => 'completed', :due => 'today')
  end

  def test_repo_returns_the_list_of_tasks
    t = OpenStruct.new(:task_id => 17, :name => "test", :list_id => 1)
    @repo.should_receive(:all_tasks_filtered).and_return([t])

    tasks = @repo.get_tasks(:list => 'Home')
    assert_equal 1,tasks.size
    assert_equal Task.new(17, 'test', 'Home'), tasks[0]
  end
end