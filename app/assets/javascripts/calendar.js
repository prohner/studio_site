var lastItem = null;
var lastItemColor = null;
var lastItemBackgroundColor = null;

var lastDay = null;
var lastDayColor = null;
var lastDayBackgroundColor = null;

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

		eventSources: [
		{
			url: '/repeating_events',
			color: '#2d2d2d',
			textColor: 'white',
			ignoreTimezone: false,
			editable: false
		},
		{
			url: '/events',
			color: 'blue',
			textColor: 'white',
			ignoreTimezone: false
		}
		],
        
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
			
			//calendar_entry_form
			//setFormValues(event.title, event.description, event.start, event.id);
			//$("#calendar_url").html(event.url);
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
			var url = '/events/new?dt=' + date.getFullYear() + '/' + (date.getMonth()+1) + '/' + date.getDate();
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

function OLD_setFormValues(className, description, dateTime, id) {
	$("#calendar_entry_header").html(dateTime.toDateString());
	$("#calendar_the_working_day").val(dateTime.toDateString());
	$("#calendar_id").val(id);
	$("#class_name").val(className ? className : "");
	$("#class_description").val(description ? description : "");
	
	$("#calendar_submit_button").val(id ? "Update event" : "Add event");
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

