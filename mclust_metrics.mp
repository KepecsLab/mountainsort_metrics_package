{
	"processors":[
		{
			"name":"kepecs.mclust_metrics",
			"version":"0.21",
			"description":"",
			"inputs":[
				{"name":"timeseries_filt"},
				{"name":"firings"}
			],
			"outputs":[
				{"name":"cluster_metrics_out"}
			],
			"parameters":[
				{"name":"clip_size","optional":false}
			],
			"exe_command":"$(basepath)/run_matlab.sh $(basepath)/mclust_metrics \"mclust_metrics('$timeseries_filt$','$firings$','$cluster_metrics_out$',$clip_size$);\""
		}
	]
}
