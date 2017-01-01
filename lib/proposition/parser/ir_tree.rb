module Proposition
  class IRTree
    attr_reader :atom, :operator, :left, :right, :children

    def initialize(atom, operator = nil, children = [])
      @atom = atom
      @operator = operator
      if children.is_a?(Array)
        @children = children
      else
        @children = [children]
      end
    end


    def append(appendee)
      if leaf_node?
        if appendee.leaf_node?
          raise ArgumentError.new("Cannot append two leaf nodes without an operator")
        end
        IRTree.new(nil, appendee.operator, [deep_copy] + appendee.children)
      else
        IRTree.new(nil, operator, children + [appendee])
      end
    end

    #Distinct from 'append' in the sense that it appends "from the left"
    #In particular for inserting a unary sentence into the optional 'tail'
    #of the sentence
    def left_append(appendee)
      if appendee.leaf_node?
        raise ArgumentError.new("Left_append called with a leaf node operand, only supports nodes with children")
      end
      IRTree.new(nil, operator, appendee.children + children)
    end

    def left_concatenate(appendee)

    end

    def leaf_node?
       atom && children.empty?
    end

    def binary?
      children.length == 2
    end

    def n_ary?
      children.length >= 3
    end

    def operator
      deep_copy(@operator)
    end

    def children
      @children.map(&:deep_copy)
    end

    def deep_copy(subject = nil)
      Marshal.load(Marshal.dump(subject || self))
    end
  end
end
