Plotly.d3.csv('chart-data.csv', function(rows){
    var trace = {
      type: 'scatter',                    // set the chart type
      mode: 'lines',  
	  legendgroup: "MSFT",
	  name: "MSTF",
      x: rows.map(function(row){          // set the x-data
        return row['Time'];
      }),
      y: rows.map(function(row){          // set the x-data
        return row['Price'];
      }),
      line: {                             // set the width of the line.
        width: 2
      }
    };

    var layout = {
		annotations: [{
    xref: 'paper',
    yref: 'paper',
    x: 1,
    xanchor: 'right',
    y: 0,
    yanchor: 'bottom',
    text: rows.map(function(row){          
        return row['Company'];
	})[0]+":USD",
	font: {
		family: 'Slabo 27px',
		size: 20
	},
    showarrow: false
	}],
      yaxis: {
		  title: "",
		  fixedrange: true,
		  showgrid: false
	  },      
      xaxis: {
		fixedrange: true,
        showgrid: false,                  // remove the x-axis grid lines
		tickmode: "array",
		tickvals: []
		
      },
      margin: {                           // update the left, bottom, right, top margin
        l: 44, b: 26, r: 8, t: 10, 
		pad: 10
      }
    };

    Plotly.plot(document.getElementById('chart'), [trace], layout, {displayModeBar: false, showLink: false});
});