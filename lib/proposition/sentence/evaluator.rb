

module Proposition
  class Evaluator

    def self.is_compound?(sentence)
      return sentence.is_a? CompoundSentence
    end

    def self.is_atomic?(sentence)
      return sentence.is_a? AtomicSentence
    end


    def self.evaluate(sentence, model)
      if is_atomic?(sentence)
        if sentence.truth != nil
          sentence.truth
        else
          #get the truth value of the symbol from the model
          model[sentence.symbol]
        end
      elsif sentence.is_unary?
        apply_operator(model, sentence.sentence, Logic::NOT)
      else
        apply_operator(model, sentence.left, sentence.operator, sentence.right)
      end
    end

    def self.apply_operator(model, left, operator, right = nil)
      case operator
      when Logic::NOT
        !(evaluate(left, model))
      when Logic::AND
        evaluate(left, model) && evaluate(right, model)
      when Logic::OR
        evaluate(left, model) || evaluate(right, model)
      when Logic::XOR
        a_result = evaluate(left, model) || evaluate(right, model)
        negated_b = CompoundSentence.new(left, Logic::AND, right).negate
        negated_b_result = evaluate(negated_b, model)
        a_result && negated_b_result

      when Logic::IMPLICATION
        not_left = !evaluate(left, model)
        right = evaluate(right, model)
        not_left || right

      when Logic::BICONDITIONAL
        xor = CompoundSentence.new(left, Logic::XOR, right)
        !evaluate(xor, model)

      else
        raise "unimplemented operator"
      end
    end
  end
end
