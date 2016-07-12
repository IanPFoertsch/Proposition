module Proposition
  class Lexer
    def self.tokenize(content, splitters)
      return content.split(splitters) if (splitters.is_a? String)

      working_copy = content
      splitters.each do |splitter|
        if working_copy.is_a?(Array)
          working_copy = recurse_over_array(working_copy, splitter)
        else
          working_copy = working_copy.split(splitter)
        end
      end
      working_copy
    end

    def self.recurse_over_array(content, splitter)
      working_copy = []
      content.each do |item|
        results = item.split(splitter)
        working_copy = working_copy + results
      end
      working_copy
    end
  end
end
