module AlbumsHelper

  def form_to_put_label_for(album)
    labels = Albums::Label.all - album.labels
    form_with url: put_label_album_path(album), local: true, method: :patch do
      concat select_tag :label_id, options_from_collection_for_select(labels, :id, :name) , prompt: '-'
      concat submit_tag :label
    end
  end
end
