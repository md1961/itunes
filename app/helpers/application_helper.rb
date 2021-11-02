module ApplicationHelper

  def rating_display(ratable)
    value = ratable.rating || 0
    num_stars = value / 20
    '☆' * num_stars
  end

  def time_display(time_in_ms)
    (time_in_ms / 1000.0).divmod(60).yield_self { |min, sec|
      "#{min}:#{sec.round.to_s.rjust(2, '0')}"
    }
  end
end
