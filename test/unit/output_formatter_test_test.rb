require File.dirname(__FILE__) + '/../test_helper'

class OutputFormatterTest < Test::Unit::TestCase
  include ConsoleRtm

  def setup
    @f = OutputFormatter.new(false)
    @tasks = [OpenStruct.new(:text => 'text1'), OpenStruct.new(:text => 'text2')]
  end

  def test_output_is_empty_line_if_task_list_is_empty
    @f.format_tasks([])
    assert_equal "", @f.result
  end

  def test_output_of_not_empty_task_list
    @f.format_tasks(@tasks)
    assert_equal "0 text1\n1 text2", @f.result
  end

  def test_can_clean_result
    @f.format_tasks(@tasks)
    assert_equal "0 text1\n1 text2", @f.result
    @f.clean_output!
    assert_equal "", @f.result
  end

  def test_format_history
    @f.format_history(["aa", "bb"])
    assert_equal "0 aa\n1 bb", @f.result
  end
end