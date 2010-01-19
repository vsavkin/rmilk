require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm

  class RtmTaskRepository
    def initialize(list_repository)
      @list_repository = list_repository
    end

    def get_tasks(filter)
      filter_str = filter.inject("") do |r, (k, v)|
        str = "#{k}:#{v}"
        r.empty? ? str : "#{r} and #{str}"
      end
      tasks = all_tasks_filtered(filter_str).collect do |t|
        list_name = @list_repository.get_list_name_by_id(t.list_id)
        Task.new(t.task_id, t.name, list_name, t)
      end
      tasks.sort {|a,b| a.priority <=> b.priority}
    end

    def add!(task)
      list_id = @list_repository.get_list_id_by_name(task.list_name)
      raise "invalid list name" if list_id.nil?
      new_added_task = Rufus::RTM::Task.add! task.text, list_id
      task.milk_task = new_added_task
      task
    end

    def move_task(task, list_name)
      list_id = @list_repository.get_list_id_by_name(list_name)
      raise "invalid list name" if list_id.nil?
      task.move_to list_id
    end

    private
    def all_tasks_filtered(filter_str)
      Rufus::RTM::Task.find(:filter => filter_str) rescue []
    end
  end

end