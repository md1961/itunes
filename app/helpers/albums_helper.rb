module AlbumsHelper

  def time_display(time_in_ms)
    (time_in_ms / 1000.0).divmod(60).yield_self { |min, sec|
      "#{min}:#{sec.round.to_s.rjust(2, '0')}"
    }
  end
end
