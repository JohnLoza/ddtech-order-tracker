let colors = [
  'rgba(236, 64, 122, 0.5)',  // pink 400
  'rgba(239, 83, 80, 0.5)',   // red 400
  'rgba(171, 71, 188, 0.5)',  // purple 400
  'rgba(126, 87, 194, 0.5)',  // deep purple 400
  'rgba(92, 107, 192, 0.5)',  // indigo 400
  'rgba(66, 165, 245, 0.5)',  // blue 400
  'rgba(41, 182, 246, 0.5)',  // light blue 400
  'rgba(38, 198, 218, 0.5)',  // cyan 400
  'rgba(38, 166, 154, 0.5)',  // teal 400
  'rgba(102, 187, 106, 0.5)', // green 400
  'rgba(156, 204, 101, 0.5)', // light green 400
  'rgba(212, 225, 87, 0.5)',  // lime 400
  'rgba(255, 238, 88, 0.5)',  // yelow 400
  'rgba(255, 202, 40, 0.5)',  // amber 400
  'rgba(255, 167, 38, 0.5)',  // orange 400
  'rgba(255, 112, 67, 0.5)',  // deep orange 400
  'rgba(141, 110, 99, 0.5)',  // brown 400
  'rgba(120, 144, 156, 0.5)', // blue grey 400
  'rgba(229, 57, 53, 0.5)',   // red 600
  'rgba(216, 27, 96, 0.5)',   // pink 600
  'rgba(142, 36, 170, 0.5)',  // purple 600
  'rgba(94, 53, 177, 0.5)',   // deep purple 600
  'rgba(57, 73, 171, 0.5)',   // indigo 600
  'rgba(30, 136, 229, 0.5)',  // blue 600
  'rgba(3, 155, 229, 0.5)',   // light blue 600
  'rgba(0, 172, 193, 0.5)',   // cyan 600
  'rgba(0, 137, 123, 0.5)',   // teal 600
  'rgba(67, 160, 71, 0.5)',   // green 600
  'rgba(124, 179, 66, 0.5)',  // light green 600
  'rgba(192, 202, 51, 0.5)',  // lime 600
  'rgba(253, 216, 53, 0.5)',  // yellow 600
  'rgba(255, 179, 0, 0.5)',   // amber 600
  'rgba(251, 140, 0, 0.5)',   // orange 600
  'rgba(244, 81, 30, 0.5)',   // deep orange 600
  'rgba(109, 76, 65, 0.5)',   // brown 600
  'rgba(84, 110, 122, 0.5)',  // blue grey 600
]

let chart_options = {
  scales: {
    yAxes: [{
      ticks: {
        beginAtZero: true,
      }
    }]
  }
}

window.randomColor = function() {
  return colors[Math.floor(Math.random() * colors.length)];
}

window.getColors = function(json) {
  arr = new Array();
  for(indx = 0; indx < Object.keys(json).length; indx++) {
    arr.push(randomColor());
  }
  return arr;
}

window.initChart = function(target, label, type) {
  target = document.getElementById(target);
  const ctx = target.getContext('2d');
  const json = JSON.parse(target.dataset.json);
  const chart_type = target.dataset.chartType;

  let chart_data = {
    labels: Object.keys(json),
    datasets: [{
      label: label,
      data: Object.values(json),
      borderWidth: 2,
      backgroundColor: getColors(json),
    }]
  }

  if(chart_type == 'line') {
    let color = randomColor();
    chart_data.datasets[0].backgroundColor = color;
    chart_data.datasets[0].borderColor = color;
    chart_data.datasets[0].fill = false;
  }

  let chart = new Chart(ctx, {
    type: chart_type,
    data: chart_data,
    options: chart_options,
  });
}

