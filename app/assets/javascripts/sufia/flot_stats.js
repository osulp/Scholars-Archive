$(function() {
  if (typeof sufia_item_stats === "undefined") {
    return;
  }

  function weekendAreas(axes) {
    var markings = [],
      d = new Date(axes.xaxis.min);

    // go to the first Saturday
    d.setUTCDate(d.getUTCDate() - ((d.getUTCDay() + 1) % 7))
    d.setUTCSeconds(0);
    d.setUTCMinutes(0);
    d.setUTCHours(0);

    var i = d.getTime();

    // when we don't set yaxis, the rectangle automatically
    // extends to infinity upwards and downwards

    do {
      markings.push({ xaxis: { from: i, to: i + 2 * 24 * 60 * 60 * 1000 } });
      i += 7 * 24 * 60 * 60 * 1000;
    } while (i < axes.xaxis.max);

    return markings;
  }

  var options = {
    xaxis: {
      mode: "time",
      tickLength: 5
    },
    yaxis: {
      tickDecimals: 0,
      min: 0
    },
    series: {
      lines: {
        show: true,
        fill: true
      },
      points: {
        show: false,
        fill: true
      }
    },
    selection: {
      mode: "x"
    },
    grid: {
      hoverable: true,
      clickable: true,
      markings: weekendAreas
    },
    colors: ['#385E86', "#C34500"]
  };

  var plot = $.plot("#usage-stats", sufia_item_stats, options);

  $("<div id='tooltip'></div>").css({
    position: "absolute",
    display: "none",
    border: "1px solid #bce8f1",
    padding: "2px",
    "background-color": "#d9edf7",
    opacity: 0.80
  }).appendTo("body");

  $("#usage-stats").bind("plothover", function (event, pos, item) {
    if (item) {
      date = new Date(item.datapoint[0]);
      months = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]
      $("#tooltip").html("<strong>" + item.series.label + ": " + item.datapoint[1] + "</strong><br/>" + months[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear())
            .css({top: item.pageY+5, left: item.pageX+5})
            .fadeIn(200);
    } else {
      $("#tooltip").fadeOut(100)
    }
  });

  var overview = $.plot("#overview", sufia_item_stats, {
    series: {
      lines: {
        show: true,
        lineWidth: 1
      },
      shadowSize: 0
    },
    xaxis: {
      ticks: [],
      mode: "time",
      minTickSize: [1, "day"]
    },
    yaxis: {
      ticks: [],
      min: 0,
      autoscaleMargin: 0.1
    },
    selection: {
      mode: "x"
    },
    legend: {
      show: false
    },
    colors: ['#385E86', "#C34500"]
  });

  $("#usage-stats").bind("plotselected", function(event, ranges) {
    plot = $.plot("#usage-stats", sufia_item_stats, $.extend(true, {}, options, {
      xaxis: {
        min: ranges.xaxis.from,
        max: ranges.xaxis.to
      }
    }));
    overview.setSelection(ranges, true);
  });

  $("#overview").bind("plotselected", function(event, ranges) {
    plot.setSelection(ranges);
  });

  selectPrevMonthsBtn = $('<button class="btn btn-primary">Select Last 3 Months</button>').attr('id', 'select_preset');
  selectPrevMonthsBtn.click(function(){
    setDefaultPlotSelection(plot);
  });
  $("#overview").after(selectPrevMonthsBtn);

  setDefaultPlotSelection(plot);
});

function setDefaultPlotSelection(plot) {
  // Set 3 month range (from 3 months ago to yesterday)
  d_from = new Date();
  d_from.setMonth(d_from.getMonth()-3);
  d_to = new Date();
  d_to.setDate(d_to.getDate()-1);

  // Set default selection
  plot.setSelection({
    xaxis: {
      from: d_from,
      to: d_to
    }
  });
}

function setGraphLabels(graph) {
  titleId = graph.container+'-title';
  $(titleId).remove();
  title = $('<div><h3>'+graph.title+'</h3></div>').attr('id',titleId.substring(1,titleId.length)).addClass("graph-title");
  $(graph.container).prepend(title); 
}
