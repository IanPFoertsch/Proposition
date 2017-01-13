module Proposition
  class IRTreeTransformer
    def self.transform(ir_tree)
      if ir_tree.leaf_node?
        AtomicSentence.new(ir_tree.atom.string)
      elsif ir_tree.unary?
        transformed_child = transform(ir_tree.children[0])
        NegatedSentence.new(transformed_child)
      else
        #TODO: Add transformation for Implication, BICONDITIONAL
        #and Xor operators to And and Or sentences
        build_sub_sentences(ir_tree.children, clazz_name(ir_tree))
      end
    end

    def self.build_sub_sentences(children, clazz)
      #this is all at 1 level of recursion: we are trying to handle transforming
      #an n-ary sentence into a binary sentence by recursively spliting the
      #n_ary array and assembling a binary data structure from it, therefor maintining
      #an identical operator is proper.
      if children.empty?
        ArgumentError.new("build_sub_sentences called with empty array")
      elsif children.size == 1
        return transform(children.first)
      elsif children.size == 2
        left = transform(children.first)
        right = transform(children.last)
        return clazz.new(left, right)
      else #more than 2 children in the array
        left_children, right_children = split_children(children)
        left = build_sub_sentences(left_children, clazz)
        right = build_sub_sentences(right_children, clazz)
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
