class Hash

  def total_symbolize_keys!                                                     # symbolizes keys even if there is an array
    internal_symbolize!(self)
  end

  private

  def internal_symbolize!(h)
    case h
    when Array
      h.each{ |e|
        internal_symbolize!(e)
      }
    when Hash
      h.symbolize_keys!
      h.each{ |k,v|
        internal_symbolize!(v)
      }
    end
    h
  end

end
