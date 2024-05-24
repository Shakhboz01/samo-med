$(document).on('turbo:load', function() {
  $("input").focus(function() {
    $(this).select();
  });
  $(function(){$(".datepicker").datepicker({dateFormat: 'dd-mm-yy'})});
  $('#searchInput').focus()
  document.getElementById('searchInput').addEventListener('input', function() {
    var input, filter, table, tr, nameAttr, i;
    input = this.value.toUpperCase();
    table = document.getElementById('buyers-list');
    tr = table.getElementsByTagName('tr');
    for (i = 0; i < tr.length; i++) {
      nameAttr = tr[i].getAttribute('data-buyer-name');
      if (nameAttr) {
        if (nameAttr.toUpperCase().startsWith(input)) {
          tr[i].style.display = '';
        } else {
          tr[i].style.display = 'none';
        }
      }
    }
  });
});
