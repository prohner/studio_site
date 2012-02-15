var lastItem = null;
var lastItemColor = null;

$(document).ready(function() {

	// page is now ready, initialize the calendar...

	$('#calendar').fullCalendar({
		// put your options and callbacks here
		editable: true,
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		slotMinutes:15,

		loading: function(bool) {
			if (bool) {
				$('#loading').show();
			} else {
				$('#loading').hide();
			};
		},

		eventSources: [{
			url: '/events',
			color: 'blue',
			textColor: 'white',
			ignoreTimezone: true
		}],
        
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
		},

		select: function( startDate, endDate, allDay, jsEvent, view ){
			alert('hello from select function');
		},

		dayClick: function(date, allDay, jsEvent, view) {
			var el = $("#calendar_entry_header");
			el.html(date.toDateString());

			el = $("#the_working_day");
			el.html(date.toDateString());

			// change the day's background color just for fun
			if (lastItem) {
				$(lastItem).css('background-color', lastItemColor);
			}
			lastItem = this;
			lastItemColor = $(this).css('background-color');
	        $(this).css('background-color', 'yellow');

		}

	})
});   


function updateEvent(the_event) {
	$.update(
		"/events/" + the_event.id,
		{ 
			event: { 
				title: the_event.title,
				starts_at: "" + the_event.start,
				ends_at: "" + the_event.end,
				description: the_event.description
			}
		},

	function (reponse) { 
		alert('successfully updated task.'); 
	}
	);
};

