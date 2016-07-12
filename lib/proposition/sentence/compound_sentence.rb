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

    def deep_copy
      Marshal.load(Marshal.dump(self))
    end

    def negate
      return @left.deep_copy if @operator == Logic::NOT

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
      if @operator == Logic::NOT
        "(#{@operator} #{@left.in_text})"
      else
        "(#{@left.in_text} #{@operator} #{@right.in_text})"
      end
    end

    def push_not_down
      if @operator == Logic::NOT
        @left.negate.push_not_down
      else #this is a compound, non-unary sentence
        left = @left.push_not_down
        right = @right.push_not_down
        CompoundSentence.new(left, @operator, right)
      end
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

      if self.is_unary?
        self.push_not_down.push_operator_down(operator)
      elsif @operator == operator
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
      if @operator != Logic::NOT
        new_left = CompoundSentence.new(sentence, operator, @left)
        new_right = CompoundSentence.new(sentence, operator, @right)
        CompoundSentence.new(new_left, @operator, new_right)
      else
        self.push_not_down.distribute(sentence, operator)
      end
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
      if is_unary? # if sentence.is_unary? => operator is not, recurse on left sub
        return @left.eliminate_operator(@operator)
      elsif @operator == operator # sentence is binary compound
        case operator
        when Logic::IMPLICATION
          negated_recursed_left = @left.eliminate_operator(operator).negate
          recursed_right = @right.eliminate_operator(operator)
          return CompoundSentence.new(negated_recursed_left, Logic::OR, recursed_right)
        when Logic::XOR
          biconditional = CompoundSentence.new(@left, Logic::BICONDITIONAL, @right)
          eliminated = biconditional.eliminate_operator(Logic::BICONDITIONAL)
          return eliminated.negate
        when Logic::BICONDITIONAL
          recursed_left = @left.eliminate_operator(operator)
          recursed_right = @right.eliminate_operator(operator)

          compound_left = CompoundSentence.new(recursed_left.negate, Logic::OR, recursed_right)
          compound_right = CompoundSentence.new(recursed_left, Logic::OR, recursed_right.negate)

          return CompoundSentence.new(compound_left, Logic::AND, compound_right)
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

    private

    def rotate
      if self.is_unary?
        self.deep_copy
      else
        CompoundSentence.new(@right.deep_copy, @operator, @left.deep_copy)
      end
    end
  end
end
