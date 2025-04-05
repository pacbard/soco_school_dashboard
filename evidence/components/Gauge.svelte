<script>
	export let value = null;
    export let name = null;
    export let colors = [[0.2, '#CE2F2C'], [0.4, '#EE7C37'], [0.60, '#F5BC42'], [0.80, '#41934C'], [1, '#4B6AC9']];

    import {ECharts} from '@evidence-dev/core-components';
</script>

<ECharts height="130px" config={
    {
    series: [
        {
        type: 'gauge',
        startAngle: 180,
        endAngle: 0,
        center: ['50%', '75%'],
        radius: '90%',
        min: 0.5,
        max: 5.5,
        splitNumber: -1,
        title: {
            offsetCenter: [0, '30%'],
            fontSize: 18
        },
        axisLine: {
            lineStyle: {
            width: 6,
            color: colors
            }
        },
        pointer: {
            icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z',
            length: '12%',
            width: 20,
            offsetCenter: [0, '-60%'],
            itemStyle: {
            color: 'auto'
            }
        },
        detail: {
            fontSize: 30,
            offsetCenter: [0, '-15%'],
            valueAnimation: true,
            formatter: function (value) {
            return value + '';
            },
            color: 'inherit'
        },
        data: [
            {
            value: value,
            name: name
            }
        ]
        }
    ]
    }
}
/>