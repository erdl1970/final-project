var global_data = [];
var lang = {
        months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
        weekdays: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
        shortMonths: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
    };

var charts = [];
var titles = ['anual', 'mensual', 'semanal', 'diaria'];
$(function () {
    Highcharts.setOptions({lang: lang});
    var containers = ['year-container', 'month-container', 'week-container', 'day-container'];
    $.each(containers, function(index){
        chart = new Highcharts.Chart({
            chart: {
                renderTo: this.toString(),
                zoomType: 'x'
            },
            series: [{
                type: 'line',
                data: [],
                name: 'Potencia'
            }],
            title: {
                text: 'Potencia '+titles[index]
            },
            yAxis: {
                title: {
                    text: 'Potencia'
                }
            },
            xAxis: {
                title: {
                    text: 'Fecha'
                },
                type: 'datetime'
            },
            tooltip: {
                headerFormat: '<small>{point.x:%e de %B a las %H:%m}</small><br>',
                pointFormat: '<h1>{series.name}:{point.y:.2f} kw</h1>'
            }
        });
        charts.push(chart);
    });

    periods = ['year','month','week', 'day'];
    $.each(periods, function(index, period) {
        $.get('entities/Refrigerador/attributes/Potencia/measures?period='+period, function(measures) {
            data = []
            $.each(measures, function(index, measure ) {
              data[index]=[new Date(measure.created_at).getTime(), parseFloat(measure.value)]
            });
            charts[index].series[0].setData(data);
        });
    });
});