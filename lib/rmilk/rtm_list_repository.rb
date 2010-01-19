require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm
  class RtmListRepository
    def initialize(context)
      @context = context
    end

    def get_list_name_by_id(id)
      if n = @context.get_list_name(id) then
        n
      else
        list = all_lists.find {|list| list.list_id == id}
        return nil if list == nil
        @context.save_list_name id, list.name and return list.name
      end
    end

    def get_list_id_by_name(name)
      if id = @context.get_list_id(name) then
        id
      else
        list = all_lists.find {|list| list.name == name}
        return nil if list == nil
        @context.save_list_name list.list_id, name and return list.list_id
      end
    end

    private
    def all_lists
      Rufus::RTM::List.find
    end
  end
end