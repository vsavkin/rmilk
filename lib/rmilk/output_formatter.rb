module ConsoleRtm

  class OutputFormatter
    attr_reader :result

    def initialize(complex_formatter = true)
      @complex_formatter = complex_formatter
      @colors = {:red => "\033[31m",
                  :blue => "\033[34m",
                  :lightBlue => "\033[36m"}
    end

    def clean_output!
      @result = ''
    end

    def format_tasks(tasks)
      temp = []
      tasks.each_with_index do |e, i|
        temp << "#{get_priority_color e}#{i} #{e.text}#{get_end_color}"
      end
      if @complex_formatter then
        @result = "------\n" + temp.join("\n") + "\n------"
      else
        @result = temp.join("\n")
      end
    end

    def format_history(history)
      temp = []
      history.each_with_index do |e, i|
        temp << "#{i} #{e}"
      end
      @result = temp.join("\n")
    end

    def error(text)
      @result = text
    end

    def output(text)
      @result = text
    end

    private
    def get_priority_color(task)
      return "" unless @complex_formatter
      p = task.priority
      if p == "1" then return @colors[:red] end
      if p == "2" then return @colors[:blue] end
      if p == "3" then return @colors[:lightBlue] end
      return ''
    end

    def get_end_color
      return "" unless @complex_formatter
      "\033[0m"
    end
  end

end