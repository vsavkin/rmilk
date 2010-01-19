require File.dirname(__FILE__) + '/../test_helper'

class RtmListRepositoryTest < Test::Unit::TestCase
  include ConsoleRtm

  def setup
    st = ContextStorage.new('rtm_console_tmp.store')
    @repo = flexmock(RtmListRepository.new(st))

    @lists = [OpenStruct.new(:list_id => 1, :name => 'Home'),
             OpenStruct.new(:list_id => 2, :name => 'Work')]
  end

  def teardown
    File.delete 'rtm_console_tmp.store'
  end

  def test_caching_list_when_query_by_id
    @repo.should_receive(:all_lists).once.and_return(@lists)
    assert_equal "Home", @repo.get_list_name_by_id(1)
    #we must execute it second time to check that we'll use cache
    assert_equal "Home", @repo.get_list_name_by_id(1)
  end

  def test_caching_list_when_query_by_name
    @repo.should_receive(:all_lists).once.and_return(@lists)
    assert_equal 1, @repo.get_list_id_by_name('Home')
    #we must execute it second time to check that we'll use cache
    assert_equal 1, @repo.get_list_id_by_name('Home')
  end

  def test_returns_nil_if_cant_find_list
    @repo.should_receive(:all_lists).twice.and_return(@lists)
    assert_equal nil, @repo.get_list_id_by_name('Bla')
    assert_equal nil, @repo.get_list_id_by_name('Blo')
  end
end