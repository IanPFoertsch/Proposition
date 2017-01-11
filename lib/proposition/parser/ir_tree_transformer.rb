require "active_support/core_ext/string"
module Proposition
  class IRTreeTransformer
    def self.transform(ir_tree)
      if ir_tree.leaf_node?
        AtomicSentence.new(ir_tree.atom.string)
      elsif ir_tree.unary?
        transformed_child = transform(ir_tree.children[0])
        NegatedSentence.new(transformed_child)
      elsif ir_tree.binary?
        #TODO: Add transformation for Implication, BICONDITIONAL
        #and Xor operators to And and Or sentences
        child_nodes = ir_tree.children
        left_child = transform(child_nodes[0])
        right_child = transform(child_nodes[1])
        clazz_name(ir_tree).new(left_child, right_child)
      end
    end

    def self.clazz_name(ir_tree)
      clazz = ir_tree.operator.string.classify
      "#{self.name.split("::").first}::#{clazz}".constantize
    end
  end
end
