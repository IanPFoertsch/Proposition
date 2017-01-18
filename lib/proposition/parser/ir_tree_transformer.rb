module Proposition
  module Parser
    class IRTreeTransformer
      TRANSFORMED_OPERATORS = ["<=>", "=>", "xor"]

      def self.transform(ir_tree)
        if ir_tree.leaf_node?
          Proposition::AtomicSentence.new(ir_tree.atom.string)
        elsif ir_tree.unary?
          transformed_child = transform(ir_tree.children[0])
          Proposition::Not.new(transformed_child)
        else
          if TRANSFORMED_OPERATORS.include?(ir_tree.operator.string)
            implication_transformation(ir_tree)
          else
            nary_to_binary_sentence(ir_tree.children, clazz_name(ir_tree))
          end
        end
      end

      def self.nary_to_binary_sentence(children, clazz)
        if children.empty?
          ArgumentError.new("nary_to_binary_sentence called with empty array")
        elsif children.size == 1
          return transform(children.first)
        elsif children.size == 2
          left = transform(children.first)
          right = transform(children.last)
          return clazz.new(left, right)
        else #more than 2 children in the array
          left_children, right_children = split_children(children)
          left = nary_to_binary_sentence(left_children, clazz)
          right = nary_to_binary_sentence(right_children, clazz)
          return clazz.new(left, right)
        end
      end

      def self.clazz_name(ir_tree)
        clazz = ir_tree.operator.string.classify
        "#{self.name.split("::").first}::#{clazz}".constantize
      end

      def self.split_children(children)
        children.in_groups(2).map(&:compact)
      end

      def self.implication_transformation(ir_tree)
        #TODO: assert implication sentences are binary in the parser
        #Implication maps to ~a or b
        left = ir_tree.children.first
        right = ir_tree.children.last
        recursed_left = transform(left)
        recursed_right = transform(right)

        negated_left = Proposition::Not.new(recursed_left)
        Proposition::Or.new(negated_left, recursed_right)
      end
    end
  end
end
