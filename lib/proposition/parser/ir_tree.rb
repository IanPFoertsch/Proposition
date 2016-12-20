module Proposition
  class IRTree
    attr_reader :atom, :operator, :left, :right, :others

    def initialize(atom, operator = nil, left = nil, right = nil, others = [])
      @atom = atom
      @operator = operator
      @left = left
      @right = right
      @others = others
    end

    def left_concatenate(tree)
      other_children = others.empty? ? [right] : [right] + others
      if others.empty? && right.nil?
        other_children = []
      elsif others.empty?
        other_children = [right]
      else
        other_children = []
      end
      return IRTree.new(nil, operator, tree, left, other_children)
    end

    def leaf_node?
      @atom && @operator.nil? && @left.nil? && @right.nil? && @others.empty?
    end

    def binary?
      @atom.nil? && @operator && @left && @right && @others.empty?
    end

    def n_ary?
      !@others.nil
    end

    def operator
      deep_copy(@operator)
    end

    private

    def deep_copy(subject)
      Marshal.load(Marshal.dump(subject))
    end
  end
end
