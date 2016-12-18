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
      return IRTree.new(nil, operator, tree, left, [right] + others)
    end

    def leaf_node?
      @atom && @operator.nil? && @left.nil? && @right.nil? && @others.nil?
    end

    def binary?
      @atom.nil? && @operator && @left && @right && @others.nil?
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
