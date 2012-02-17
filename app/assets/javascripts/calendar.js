var lastItem = null;
var lastItemColor = null;

var lastDay = null;
var lastDayColor = null;

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
		slotMinutes:30,

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
			
			if (lastItem) {
				$(lastItem).css('background-color', lastItemColor);
			}
			
			var divElement = this.childNodes[0];
			lastItem = divElement;
			lastItemColor = $(divElement).css('background-color');
			$(divElement).css('background-color', 'green');
			return false;
		},

		select: function( startDate, endDate, allDay, jsEvent, view ){
			alert('hello from select function');
		},

		dayClick: function(date, allDay, jsEvent, view) {
			var el = $("#calendar_entry_header");
			el.html(date.toDateString());

			el = $("#calendar_the_working_day");
			el.val(date.toDateString());

			// change the day's background color just for fun
			if (lastDay) {
				$(lastDay).css('background-color', lastDayColor);
			}
			lastDay = this;
			lastDayColor = $(this).css('background-color');
			$(this).css('background-color', 'yellow');
		}

	})
});   

function refreshCalendarForDay(day) {
	//alert('hello from refresh');
	$("#calendar").fullCalendar("refetchEvents");
}

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

