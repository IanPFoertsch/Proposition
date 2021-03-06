require "proposition/version"
require "active_support/core_ext/string"
require "active_support/core_ext/array"


module Proposition
  autoload  :And, 'proposition/sentence/binary/and'
  autoload  :AtomicSentence, 'proposition/sentence/atomic_sentence'
  autoload  :BinarySentence, 'proposition/sentence/binary/binary_sentence'
  autoload  :Conjunction, 'proposition/sentence/n_ary/conjunction'
  autoload  :Clause, 'proposition/sentence/n_ary/clause'
  autoload  :Disjunction, 'proposition/sentence/n_ary/disjunction'
  autoload  :Evaluator, 'proposition/sentence/evaluator'
  autoload  :KnowledgeBase, 'proposition/knowledge_base'
  autoload  :Logic, 'proposition/sentence/logic'
  autoload  :Not, 'proposition/sentence/not'
  autoload  :Sentence, 'proposition/sentence/sentence'
  autoload  :Processor, 'proposition/operators/processor'
  autoload  :Or, 'proposition/sentence/binary/or'
  autoload  :ConjunctiveNormalForm, 'proposition/sentence/n_ary/conjunctive_normal_form'
  autoload  :NArySentence, 'proposition/sentence/n_ary/n_ary_sentence'

  module Parser
    autoload  :Atom, 'proposition/parser/token/token'
    autoload  :BinaryOperator, 'proposition/parser/token/token'
    autoload  :IRTree, 'proposition/parser/ir_tree'
    autoload  :IRTreeTransformer, 'proposition/parser/ir_tree_transformer'
    autoload  :Lexer, 'proposition/parser/lexer'
    autoload  :Operator, 'proposition/parser/token/token'
    autoload  :NAryOperator, 'proposition/parser/token/token'

    autoload  :Parenthesis, 'proposition/parser/token/token'
    autoload  :Parser, 'proposition/parser/parser'
    autoload  :UnaryOperator, 'proposition/parser/token/token'
    autoload  :Terminal, 'proposition/parser/token/token'
    autoload  :Token, 'proposition/parser/token/token'
  end
end
