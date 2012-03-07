var lastItem = null;
var lastItemColor = null;
var lastItemBackgroundColor = null;

var lastDay = null;
var lastDayColor = null;
var lastDayBackgroundColor = null;

var remoteServerName;
remoteServerName = "http://studio-site.herokuapp.com";
remoteServerName = "http://0.0.0.0:3000";
remoteServerName = "";


$(document).ready(function() {
	var repeatingEventsSourceUrl = remoteServerName + '/repeating_events.js?id=1';
	var eventsSourceUrl = remoteServerName + '/events.js?id=1';

	console.log("Should use: " + repeatingEventsSourceUrl);
	console.log("Should use: " + eventsSourceUrl);
	// page is now ready, initialize the calendar...
	$('#calendar').fullCalendar({
		// put your options and callbacks here
		editable: true,
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		slotMinutes:30,

		loading: function(bool) {
			if (bool) {
				$('#loading').show();
			} else {
				$('#loading').hide();
			};
		},

		eventSources: [
		{
			url: repeatingEventsSourceUrl,
			color: 'green',
			textColor: 'white',
			ignoreTimezone: true,
			editable: true,
			crossDomain: true,
			jsonp: true
		},
		{
			url: eventsSourceUrl,
			//color: 'blue',
			textColor: 'white',
			ignoreTimezone: true,
			crossDomain: true,
			jsonp: true
		}
		],
		
		//eventRender: function(event, element) {
		//	$(element).css('background-color', "#0f0");
		//},
        
		//disableDragging: true, 
		timeFormat: 'h:mm t{ - h:mm t} ',
		dragOpacity: "0.5",

		//http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
		eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
			updateEvent(event);
		},

		// http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
		eventResize: function(event, dayDelta, minuteDelta, revertFunc){
			updateEvent(event);
		},

		// http://arshaw.com/fullcalendar/docs/mouse/eventClick/
		eventClick: function(event, jsEvent, view){
			// would like a lightbox here.
			setSelectedItemColor(this.childNodes[0], 'blue', 'yellow');
			
			console.log(event.url);
			$.ajax({url: 			event.url,
					dataType: 		"json", 
					type: 			"GET",  
					processData: 	false, 
					contentType:	"application/json",
					complete: function(jqXHR, textStatus) {
							//console.log("Got:" + jqXHR.responseText);
							eval(jqXHR.responseText);
						}
					});
			
			return false;
		},

		select: function( startDate, endDate, allDay, jsEvent, view ){
			alert('hello from select function');
		},

		dayClick: function(date, allDay, jsEvent, view) {
			setSelectedItemColor(this, 'blue', 'yellow');
			var url = remoteServerName + '/events/choose?dt=' + date.getFullYear() + '/' + (date.getMonth()+1) + '/' + date.getDate();
			console.log(url);
			$.ajax({url: 			url,
					dataType: 		"json", 
					type: 			"GET",  
					processData: 	false, 
					contentType:	"application/json",
					complete: function(jqXHR, textStatus) {
							//console.log("Got:" + jqXHR.responseText);
							eval(jqXHR.responseText);
						}
					});

		}

	})
});   

function ajaxComplete(e, xhr, settings) {
		console.log(xhr.responseText);
		eval(xhr.responseText);
}

function setSelectedItemColor(el, newColor, newBackgroundColor) {
	if (lastItem) {
		$(lastItem).css('background-color', lastItemBackgroundColor);
		$(lastItem).css('color', lastItemColor);
	}

	lastItem = el;
	lastItemBackgroundColor = $(el).css('background-color');
	lastItemColor = $(el).css('color');
	$(el).css('background-color', newBackgroundColor);
	$(el).css('color', newColor);
}

function refreshCalendarForDay(day) {
	//alert('hello from refresh');
	$("#calendar").fullCalendar("refetchEvents");
}

function updateEvent(the_event) {
	$.update(
		remoteServerName + "/events/" + the_event.id,
		{ 
			event: { 
				title: the_event.title,
				starts_at: "" + the_event.start,
				ends_at: "" + the_event.end,
				description: the_event.description
			}
		}
		
	,
	function (reponse) { 
		alert('successfully updated task.'); 
	}
	);
};

