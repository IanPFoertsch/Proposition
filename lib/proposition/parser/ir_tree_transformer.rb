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
          #reforcotr this double-nesting
          if TRANSFORMED_OPERATORS.include?(ir_tree.operator.string)
            case ir_tree.operator.string
            when "=>"
              return implication_transformation(ir_tree)
            when "xor"
              return xor_transformation(ir_tree)
            end
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

      def self.split_binary_children(ir_tree)
        left = ir_tree.children.first
        right = ir_tree.children.last
        [left, right]
      end

      def self.binary_recursion(ir_tree)
        left, right = split_binary_children(ir_tree)
        recursed_left = transform(left)
        recursed_right = transform(right)
        [recursed_left, recursed_right]
      end

      def self.implication_transformation(ir_tree)
        #TODO: assert implication sentences are binary in the parser
        #Implication maps to ~a or b
        left, right = binary_recursion(ir_tree)

        negated_left = Proposition::Not.new(left)
        Proposition::Or.new(negated_left, right)
      end

      def self.xor_transformation(ir_tree)
        left, right = binary_recursion(ir_tree)
        not_left = Proposition::Not.new(left)
        not_right = Proposition::Not.new(right)

        left_side = Proposition::And.new(left, not_right)
        right_side = Proposition::And.new(not_left, right)

        Proposition::Or.new(left_side, right_side)
      end

    end
  end
end
