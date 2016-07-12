require "proposition/version"
require 'active_support'

module Proposition
  autoload  :Sentence, 'proposition/sentence/sentence'
  autoload  :NArySentence, 'proposition/sentence/n_ary_sentence'
  autoload  :Lexer, 'proposition/lexer/lexer'
  autoload  :Parser, 'proposition/lexer/parser'
  autoload  :Token, 'proposition/lexer/token'
  autoload  :Processor, 'proposition/operators/processor'
  autoload  :AtomicSentence, 'proposition/sentence/atomic_sentence'
  autoload  :CompoundSentence, 'proposition/sentence/compound_sentence'
  autoload  :Logic, 'proposition/sentence/logic'
  autoload  :Evaluator, 'proposition/sentence/evaluator'
end
