var site_root = "http://studio-site.herokuapp.com";
function ss_insert_terminology(id) {
   $.getJSON(site_root + '/styles/' + id + '.json', function(data) {
     var term_groups = [];
     
     var s = "";

     $.each(data, function(key, val) {
       s += '<span id="' + key + '" class=\"headline\">' + val.name + '</span><dl><span id="def_' + val.id + '"></span></dl></li>';
       term_groups.push(val.id);
     });

     var d = $("#json_target", parent.document.body); 
     d.html(s);

     for (var i = 0; i < term_groups.length; i++) {
        var term_group_id = term_groups[i];
        var span_name = 'def_' + term_group_id;
        var d = $("#" + span_name, parent.document.body); 

        $.getJSON(site_root + '/term_groups/' + term_group_id + '.json', function(data2) {
           $.each(data2, function(key2, val2) {
              var term_group_id = val2.term_group_id;
              var span_name = 'def_' + term_group_id;
              var d = $("#" + span_name, parent.document.body); 
              var s = '<dt><span class="ss_term">' + val2.term + '</span><span class="ss_term_translated">' + val2.term_translated + '</span></dt>';
              if (val2.description != null) {
                 s += '<dd><span class="ss_term_description">' + val2.description + '</span></dd>';
              }
              d.html(d.html() + s);
           });
        });
     }
   });
}
