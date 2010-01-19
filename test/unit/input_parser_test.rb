require File.dirname(__FILE__) + '/../test_helper'

class InputParserTest < Test::Unit::TestCase
  include ConsoleRtm
  
  def setup
    @parser = InputParser.new
  end

  def test_returns_empty_hash_if_input_is_empty
    @res = @parser.parse("")
    assert_equal 0, @res.size
  end

  def test_only_values
    @res = @parser.parse("Dog")
    assert_equal 'Dog', @res['first']
  end

  def test_skip_pars
    @res = @parser.parse('"Dog"')
    assert_equal 'Dog', @res['first']
  end

  def test_commands_without_values
    @res = @parser.parse("-a -bb")
    assert_not_nil @res['-a']
    assert_not_nil @res['-bb']
    assert_nil @res['-ccc']
  end

  def test_commands_with_values
    @res = @parser.parse("-a Hello -b Bye")
    assert_equal 'Hello', @res['-a']
    assert_equal 'Bye', @res['-b']
  end

  def test_commands_with_complex_values
    @res = @parser.parse("-a Hello Darling")
    assert_equal 'Hello Darling', @res['-a']
  end

  def test_sets_first_command
    @res = @parser.parse("-a Hello -b Bye")
    assert_equal '-a', @res['command']
  end

  def test_complex_example
    @res = @parser.parse("Dog -a Cats Hate Dogs -b")
    assert_equal 'Dog', @res['first']
    assert_equal 'Cats Hate Dogs', @res['-a']
    assert_not_nil @res['-b']
  end
end