(function() {
  $(function() {

    if ($('div.albums_labels_edit').length > 0) {
      const labelId = $('#label_id').data('label-id');

      $('input[name="toggle_label"]').on('change', function(e) {
        const checkBox = e.target;
        const albumId = checkBox.dataset.albumId;
        const action = checkBox.checked ? 'add_album' : 'remove_album';
        const url = "/albums/labels/" + labelId + "/" + action;
        $.ajax({
          type: 'PATCH',
          url: url,
          data: {album_id: albumId},
          success: function(e) {}
        });
      });
    }

  });
}).call(this);
