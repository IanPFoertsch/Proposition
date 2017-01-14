require "proposition/version"
require "active_support/core_ext/string"
require "active_support/core_ext/array"


module Proposition
  autoload  :AtomicSentence, 'proposition/sentence/atomic_sentence'
  autoload  :Sentence, 'proposition/sentence/sentence'
  autoload  :Lexer, 'proposition/parser/lexer'
  autoload  :Parser, 'proposition/parser/parser'
  autoload  :Token, 'proposition/parser/token/token'
  autoload  :Atom, 'proposition/parser/token/atom'
  autoload  :Operator, 'proposition/parser/token/operator'
  autoload  :NAryOperator, 'proposition/parser/token/n_ary_operator'
  autoload  :UnaryOperator, 'proposition/parser/token/unary_operator'
  autoload  :Parenthesis, 'proposition/parser/token/parenthesis'
  autoload  :Processor, 'proposition/operators/processor'
  autoload  :IRTree, 'proposition/parser/ir_tree'
  autoload  :IRTreeTransformer, 'proposition/parser/ir_tree_transformer'
  autoload  :Logic, 'proposition/sentence/logic'
  autoload  :Evaluator, 'proposition/sentence/evaluator'
  autoload  :NegatedSentence, 'proposition/sentence/negated_sentence'
  autoload  :BinarySentence, 'proposition/sentence/binary/binary_sentence'
  autoload  :And, 'proposition/sentence/binary/and'
  autoload  :Or, 'proposition/sentence/binary/or'
  autoload  :Conjunction, 'proposition/sentence/n_ary/conjunction'
  autoload  :Disjunction, 'proposition/sentence/n_ary/disjunction'
  autoload  :Clause, 'proposition/sentence/n_ary/clause'
  autoload  :ConjunctiveNormalForm, 'proposition/sentence/n_ary/conjunctive_normal_form'
  autoload  :NArySentence, 'proposition/sentence/n_ary/n_ary_sentence'
end
