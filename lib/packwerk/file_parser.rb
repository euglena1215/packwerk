# typed: strict
# frozen_string_literal: true

module Packwerk
  module FileParser
    extend T::Helpers
    extend T::Sig

    requires_ancestor { Kernel }

    interface!

    @parsers = T.let([], T::Array[Class])

    sig { params(base: Class).void }
    def self.included(base)
      @parsers << base
    end

    sig { returns(T::Array[FileParser]) }
    def self.all
      # Require each parser class in advance because it cannot be obtained unless it is required.
      Dir[File.join(__dir__, "parsers", "*.rb")].each { |file| require file }

      T.unsafe(@parsers).map(&:new)
    end

    sig { params(base: Class).void }
    def self.remove(base)
      @parsers.delete(base)
    end

    sig { abstract.params(io: File, file_path: String).returns(T.untyped) }
    def call(io:, file_path:)
    end

    sig { abstract.params(path: String).returns(T::Boolean) }
    def match?(path:)
    end
  end
end
