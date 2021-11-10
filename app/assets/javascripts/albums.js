$(function() {
  if ($('div.labels').length > 0) {
    $('div.labels span.label_with_link').hover(
      () => {
        $(this).find('a.link_to_remove_label').show();
      },
      () => {
        $(this).find('a.link_to_remove_label').hide();
      }
    )
  }
});
