module AlbumsHelper

  def labels_display(album)
    content_tag :div, class: 'labels' do
      album.labels.pluck(:name).map { |name|
        concat content_tag :span, name, class: 'label'
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
