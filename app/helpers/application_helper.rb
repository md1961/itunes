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

  def labels_display(album)
    content_tag :div, class: 'labels' do
      album.labels.sort.map { |label|
        concat content_tag(:span, class: 'label_with_link') {
          concat content_tag :span, label.name, class: 'label'
          concat link_to('x', remove_label_album_path(album, label_id: label),
                              method: :patch, class: 'link_to_remove_label', hidden: 'hidden')
        }
      }
    end
  end
end
