require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm
  class ContextStorage
    def initialize(file_name, history_size = 10)
      @history_size = history_size
      @store = PStore.new(file_name)
    end

    def save_list_name(list_id, list_name)
      @store.transaction do
        @store["list_id_#{list_id}"] = list_name
        @store["list_name_#{list_name}"] = list_id
      end
    end

    def get_list_name(list_id)
      @store.transaction do
        @store["list_id_#{list_id}"]
      end
    end

    def get_list_id(list_name)
      @store.transaction do
        @store["list_name_#{list_name}"]
      end
    end

    def save_tasks(tasks)
      @store.transaction do
        @store["tasks"] = tasks
      end
    end

    def get_tasks
      @store.transaction do
        @store["tasks"]
      end
    end

    def add_to_history(text)
      @store.transaction do
        h = @store["history"]
        (h ||= []) << text
        @store["history"] = h.last(@history_size)
      end
    end

    def get_history
      @store.transaction do
        @store["history"].reverse 
      end
    end

    def recreate
      path = @store.path
      File.delete path if File.exists? path
      @store = PStore.new(path)
    end
  end
end