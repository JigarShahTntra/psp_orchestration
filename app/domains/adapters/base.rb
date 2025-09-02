module Adapters
  class Base
    def initialize(psp:, mapping: nil)
      @psp = psp
      @mapping = mapping
    end

    def authorize(_payment)
      raise NotImplementedError
    end

    def capture(_payment)
      raise NotImplementedError
    end

    def refund(_payment)
      raise NotImplementedError
    end

    def reconcile(_params = {})
      raise NotImplementedError
    end
  end
end

