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
      else #sentence is n-ary
        clazz = clazz_name(ir_tree)
        children = split_children(ir_tree.children)
        left_children = children.first
        right_children = children.last
        left = handle_sub_set(left_children, clazz)
        right = handle_sub_set(right_children, clazz)
        clazz.new(left, right)
      end
    end

    def self.handle_sub_set(children, clazz)
      #CASE: children is nil
      #CASE: 1 child in array
      #CASE: 2 or more children in array
      if children.size == 1
        return transform(children.first)
      elsif children.size == 2
        left = transform(children.first)
        right = transform(children.last)
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
