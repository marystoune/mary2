
$(document).ready(function(){

/*  setInterval(function getTransactions(){

  			var last_tx_hash = $('.dynamic td:first a').attr('href');

        $.ajax({
          type: 'POST',
          url: 'get_tx',
          data: 'last_tx_hash=' + last_tx_hash,
          success: function(data) {
            setFields(data);
          }
        });
  
  },1000);

*/
  function setFields(data) {

		for (var i = 0; typeof(data[i]) == 'object'; i++) {
			$('.dynamic tr:last').remove();
			
			var new_row = '<tr style="display: none;"><td><a href=/tx/' + 
										data[i].tx_hash + 
										'>' +
										data[i].tx_hash.substr(0, 26) +
										'...' +
										'</a></td><td class="hidden-xs">' +
										data[i].timestamp +
										'</td><td class="text-right"><span>' +
										data[i].amount/100000000.0 + 
										'</span> QWC' +
										'</td></tr>'

    	$(new_row).insertBefore('.dynamic tr:eq(0)').show('slow');
		};
  
  };


});

