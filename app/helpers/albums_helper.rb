module AlbumsHelper

  def labels_display(album)
    content_tag :div, class: 'labels' do
      album.labels.map { |label|
        concat content_tag(:span, class: 'label_with_link') {
          concat content_tag :span, label.name, class: 'label'
          concat link_to('x', remove_label_album_path(album, label_id: label),
                              method: :patch, class: 'link_to_remove_label', hidden: 'hidden')
        }
      }
    end
  end

  def form_to_put_label_for(album)
    labels = Albums::Label.all - album.labels
    form_with url: put_label_album_path(album), local: true, method: :patch do
      concat select_tag :label_id, options_from_collection_for_select(labels, :id, :name) , prompt: '-'
      concat submit_tag :label
    end
  end
end
