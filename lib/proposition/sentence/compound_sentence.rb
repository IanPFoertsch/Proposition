module Proposition
  class CompoundSentence < Sentence
    attr_reader :left, :right, :operator

    def initialize(left, operator, right=nil)
      @operator = operator
      @left = left
      @right = right
    end

    def is_unary?
      @operator == Logic::NOT
    end

    def is_compound?
      true
    end

    def distribute_not
      negated_left = @left.negate
      negated_right = @right.negate
      operator = case @operator
      when Logic::AND
        Logic::OR
      when Logic::OR
        Logic::AND
      when Logic::XOR
        Logic::BICONDITIONAL
      when Logic::BICONDITIONAL
        Logic::XOR
      when Logic::IMPLICATION
        Logic::IMPLICATION
      end

      #Awkward handing here due to non-associativity of the IMPLICATION operator
      if operator == Logic::IMPLICATION
        #~(A => B) == (~B AND A)
        CompoundSentence.new(left.deep_copy, Logic::AND, negated_right)
      else
        #otherwise just return the new sentence
        CompoundSentence.new(negated_left, operator, negated_right)
      end
    end

    def ==(other)
      return false unless other.is_a?(CompoundSentence)
      if(@left == other.left && @operator == other.operator && @right == other.right)
        true
      else
        false
      end
    end

    def in_text
      "(#{@left.in_text} #{@operator} #{@right.in_text})"
    end

    def push_not_down
      left = @left.push_not_down
      right = @right.push_not_down
      CompoundSentence.new(left, @operator, right)
    end

    def push_or_down
      push_operator_down(Logic::OR)
    end


    def push_and_down
      push_operator_down(Logic::AND)
    end

    def push_operator_down(operator)
      if operator == Logic::XOR ||
        operator == Logic::BICONDITIONAL ||
        operator == Logic::IMPLICATION
        raise "push_operator_down called for #{operator}, should only be used for AND or OR"
      end

      if @operator == operator
        if !@right.is_atomic?
          distribute_and_push(operator)
        elsif !@left.is_atomic? && @right.is_atomic?
          return rotate.distribute_and_push(operator)
        else #otherwise both subsentences are atomic
          return self
        end
      else
        left = @left.push_operator_down(operator)
        right = @right.push_operator_down(operator)
        CompoundSentence.new(left, @operator, right)
      end
    end


    #distributes the input sentence and operator into this sentence,
    #forming a new compound sentence
    def distribute(sentence, operator)
      new_left = CompoundSentence.new(sentence, operator, @left)
      new_right = CompoundSentence.new(sentence, operator, @right)
      CompoundSentence.new(new_left, @operator, new_right)
    end

    #wrapper method for which sub-sentence we should distribute into which
    def distribute_and_push(operator)
      if @right.operator != @operator
        temp = @right.distribute(@left, @operator)
        new_left = temp.left.push_operator_down(operator)
        new_right = temp.right.push_operator_down(operator)
        CompoundSentence.new(new_left, temp.operator, new_right)
      elsif @left.operator != @operator
        rotate.distribute_and_push(operator)
      else
        left = @left.push_operator_down(operator)
        right = @right.push_operator_down(operator)
        CompoundSentence.new(left, @operator, right)
      end
    end

    def no_complex_operations?
      return false unless (
        @operator == Logic::AND ||
        @operator == Logic::OR ||
        @operator == Logic::NOT
      )
      return false unless @right ? @right.no_complex_operations? : true
      return @left.no_complex_operations?
    end

    #eliminate_operator is built to simplify sentences to
    #be composed entirely of AND, OR, and NOT, eliminating
    #XOR, IMPLICATION, and BICONDITIONAL
    def eliminate_operator(operator)
      if operator == Logic::AND || operator == Logic::NOT
        raise "eliminate_operator called for AND or OR, should only be used for
          XOR, IMPLICATION, or BICONDITIONAL"
      end
      if @operator == operator # sentence is binary compound
        case operator
        when Logic::IMPLICATION
          negated_recursed_left = @left.eliminate_operator(operator).negate
          recursed_right = @right.eliminate_operator(operator)
          return CompoundSentence.new(negated_recursed_left, Logic::OR, recursed_right)
        when Logic::XOR
          left = CompoundSentence.new(@left.deep_copy, Logic::OR, @right.deep_copy)
          right = CompoundSentence.new(@left.deep_copy, Logic::AND, @right.deep_copy).negate

          return CompoundSentence.new(left, Logic::AND, right).eliminate_operator(Logic::XOR)
        when Logic::BICONDITIONAL
          left = CompoundSentence.new(@left.deep_copy, Logic::AND, @right.deep_copy)
          right = CompoundSentence.new(@left.deep_copy, Logic::OR, @right.deep_copy).negate

          return CompoundSentence.new(left, Logic::OR, right).eliminate_operator(Logic::BICONDITIONAL)
        else
          raise "unimplimented elimination operation"
        end
      else
        return CompoundSentence.new(
          @left.eliminate_operator(operator),
          @operator,
          @right.eliminate_operator(operator)
        )
      end
    end

    def to_clause
      if is_unary?
        self.push_not_down.to_clause
      elsif contains_operator?(Logic::AND) ||
        contains_operator?(Logic::XOR) ||
        contains_operator?(Logic::IMPLICATION) ||
        contains_operator?(Logic::BICONDITIONAL)
        raise "to_clause called on sentence containing operator other than OR"
      else
        working_copy = self.push_not_down

        left_clauses = working_copy.left.to_clause.retrieve_atomic_components
        right_clauses = working_copy.right.to_clause.retrieve_atomic_components

        return NArySentence.new(Logic::OR, left_clauses + right_clauses)
      end
    end

    def contains_operator?(operator)
      right = @right ? @right.contains_operator?(operator) : false

      @operator == operator || right || @left.contains_operator?(operator)
    end


    def does_not_contain_operator?(operator)
      return false if @operator == operator
      return false if @right.does_not_contain_operator?(operator)
      return false if @left.does_not_contain_operator?(operator)
      true
    end

    private

    def unbalanced
      !@left.is_atomic? && @right.is_atomic?
    end

    def rotate
      if self.is_unary?
        self.deep_copy
      else
        CompoundSentence.new(@right.deep_copy, @operator, @left.deep_copy)
      end
    end
  end
end
