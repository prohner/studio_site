var lastItem = null;
var lastItemColor = null;

var lastDay = null;
var lastDayColor = null;

$(document).ready(function() {

	// page is now ready, initialize the calendar...
	setFormValues(null, null, new Date(), null);

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
			ignoreTimezone: false
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
			setSelectedItemColor(this.childNodes[0], 'green');
			
			//calendar_entry_form
			setFormValues(event.title, event.description, event.start, event.id);
			
			return false;
		},

		select: function( startDate, endDate, allDay, jsEvent, view ){
			alert('hello from select function');
		},

		dayClick: function(date, allDay, jsEvent, view) {
			setFormValues(null, null, date, null);

			setSelectedItemColor(this, 'yellow');

		}

	})
});   

function setFormValues(className, description, dateTime, id) {
	$("#calendar_entry_header").html(dateTime.toDateString());
	$("#calendar_the_working_day").val(dateTime.toDateString());
	$("#calendar_id").val(id);
	$("#class_name").val(className ? className : "");
	$("#class_description").val(description ? description : "");
	
	$("#calendar_submit_button").val(id ? "Update event" : "Add event");
}

function setSelectedItemColor(el, newColor) {
	if (lastItem) {
		$(lastItem).css('background-color', lastItemColor);
	}

	lastItem = el;
	lastItemColor = $(el).css('background-color');
	$(el).css('background-color', newColor);
}

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

