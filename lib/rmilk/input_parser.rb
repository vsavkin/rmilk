module ConsoleRtm

  class InputParser
    def parse(input)
      parts = input.split(' ').map {|e| preprocess e}
      res, last_command, first_command = {}, 'first', nil
      parts.each do |e|
        if command? e then
          res[e] = true
          last_command = e
          first_command ||= e
        else
          t = res[last_command]
          value_is_not_set = (t == true || t.nil?)
          res[last_command] = value_is_not_set ? e : "#{t} #{e}"
        end
      end
      res['command'] = first_command if !first_command.nil?
      res
    end

    private
    def command?(str)
      str[0, 1] == '-'
    end

    def preprocess(str)
      str[0, 1] == '"' && str[-1, 1] == '"' ? str[1..-2] : str
    end
  end

end