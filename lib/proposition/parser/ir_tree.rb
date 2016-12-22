module Proposition
  class IRTree
    attr_reader :atom, :operator, :left, :right, :children

    def initialize(atom, operator = nil, children = [])
      @atom = atom
      @operator = operator
      @children = children
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
