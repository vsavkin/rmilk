require File.dirname(__FILE__) + '/../import_rmilk.rb'

module ConsoleRtm

  class HelpMessage
    def initialize
      @messages = []
      @messages << '-l Inbox -d today -s completed'
      @messages << '-next'
      @messages << '-res'
      @messages << '-a New Task -t Inbox'
      @messages << '-history'
      @messages << '-hd 0'
      @messages << '-complete 0'
      @messages << '-uncomplete 0'
      @messages << '-postpone 0'
      @messages << '-delete 0'
      @messages << '-m 0 -l Home'
      @messages << '-e 0 -p 1 -d today'
    end

    def to_s
      @messages.join("\n")
    end
  end

  class Action
    def initialize(task_repo, list_repo, is_apply, &apply)
      @task_repo = task_repo
      @list_repo = list_repo
      @is_apply = is_apply
      @apply = apply
    end

    def apply?
      @is_apply.call
    end

    def apply!
      @apply.call
    end
  end

  class ConsoleUi
    def initialize(store, out)
      @store, @out = store, out
      @list_repo = RtmListRepository.new(store)
      @task_repo = RtmTaskRepository.new(@list_repo)

      @actions = []
      @input_parse = InputParser.new
      @help = HelpMessage.new     

      rule_when lambda {command?('-l') || command?('-d')} do
        criteria = {:status => 'incomplete'}
        if @args['-l'] then criteria[:list] = @args['-l'] end
        if @args['-d'] then criteria[:due] = @args['-d'] end
        if @args['-s'] then criteria[:status] = @args['-s'] end
        tasks = @task_repo.get_tasks(criteria)
        @store.save_tasks tasks
        @out.format_tasks tasks
      end

      rule_when lambda {command?('-next')} do
        criteria = {:status => 'incomplete', :list => ENV["NEXT_ACTIONS"]}
        tasks = @task_repo.get_tasks(criteria)
        @store.save_tasks tasks
        @out.format_tasks tasks
      end

      rule_when lambda {command?('-res')} do
        tasks = @store.get_tasks
        @out.format_tasks tasks
      end

      rule_when lambda {command?('-a')} do
        text = @args['-a']
        list_name = @args['-t'] ? @args['-t'] : ENV["DEFAULT_LIST"]
        @task_repo.add! Task.new(nil, text, list_name)     
      end

      rule_when lambda {command?('-history')} do
        h = @store.get_history
        @out.format_history h
      end

      rule_when lambda {command?('-hd')} do
        h = @store.get_history
        index = @args['-hd'].to_i
        process h[index]
      end

      rule_when lambda {command?('-complete')} do
        task('-complete').complete!
      end

      rule_when lambda {command?('-uncomplete')} do
        task('-complete').uncomplete!
      end

      rule_when lambda {command?('-postpone')} do
        task('-postpone').postpone!
      end

      rule_when lambda {command?('-delete')} do
        task('-delete').delete!
      end

      rule_when lambda {command?('-m')} do
        task = task('-m')
        @task_repo.move_task task, @args['-l']
      end

      rule_when lambda {command?('-e')} do
        task = task('-e')
        if @args['-p'] then
          task.priority = @args['-p']
        end
        if @args['-d'] then
          task.due = @args['-d']
        end
      end

      rule_when lambda {command?('-help')} do
        @out.output @help.to_s
      end

      rule_when lambda {true} do
        @out.error 'unprocessed input'
      end
    end

    def process(input)
      @deep ||= 1
      @deep += 1
      return "infinite recursion" if @deep > 10

      @out.clean_output!
      @store.add_to_history input
      @args = @input_parse.parse(input)
      action = @actions.find {|a| a.apply?}
      action.apply! rescue return $!
      @out.result
    end

    def rule_when(is_apply, &apply)
      @actions << Action.new(@task_repo, @list_repo, is_apply, &apply)
    end

    def task(args_key)
     index =  @args[args_key].to_i
     h = @store.get_tasks
     h[index]
    end

    def command?(name)
      @args['command'] == name
    end
  end

end