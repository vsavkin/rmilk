require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm

  class Task
    attr_reader :id, :text, :list_name, :tags
    attr_accessor :milk_task

    def initialize(id, text, list_name, milk_task = nil, tags = {})
      @id = id
      @text = text
      @list_name = list_name
      @milk_task = milk_task
      @tags = tags
    end

    def complete!
      @milk_task.complete!
    end

    def delete!
      @milk_task.delete!
    end

    def postpone!
      execute_milk "rtm.tasks.postpone"
    end

    def uncomplete!
      execute_milk "rtm.tasks.uncomplete"
    end

    def priority=(priority)
      execute_milk "rtm.tasks.setPriority", {:priority => priority}
    end

    def priority
      milk_task.priority 
    end

    def due=(due)
      execute_milk "rtm.tasks.setDueDate", {:due => due}
    end

    def move_to(to_list_id)
      execute_milk "rtm.tasks.moveTo",
                   {:from_list_id => milk_task.list_id,
                    :to_list_id => to_list_id}
    end

    def to_s
      "#{@list_name}: #{@id} - #{@text}"
    end

    def ==(obj)
      id = obj.id && text == obj.text &&
              list_name == obj.list_name && tags == obj.tags
    end

    private
    def execute_milk(method, args = {})
      args[:method] = method
      args[:timeline] = Rufus::RTM::MilkResource.timeline
      args[:list_id] = milk_task.list_id
      args[:taskseries_id] = milk_task.taskseries_id
      args[:task_id] = milk_task.task_id
      res = Rufus::RTM.milk(args)
      raise res['err']['msg'] if !res['err'].nil?
    end
  end

end