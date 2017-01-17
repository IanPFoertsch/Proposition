module Proposition
  module Parser
    class IRTreeTransformer
      def self.transform(ir_tree)
        if ir_tree.leaf_node?
          Proposition::AtomicSentence.new(ir_tree.atom.string)
        elsif ir_tree.unary?
          transformed_child = transform(ir_tree.children[0])
          Proposition::Not.new(transformed_child)
        else
          #TODO: Add transformation for Implication, BICONDITIONAL
          #and Xor operators to And and Or sentences
          nary_to_binary_sentence(ir_tree.children, clazz_name(ir_tree))
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
    end
  end
end
