rule annotate_reads:
	input:
		sam = rules.convert.output.bam,
		info = rules.simulate_integrations.output.sim_info
	output:
		annotated_info = "{outpath}/{exp}/sim_ints/{samp}.int-info.annotated.tsv",
	conda:
		"../envs/simvi.yml"
	container:
		"docker://szsctt/simvi:2"
	resources:
		mem_mb= lambda wildcards, attempt: attempt * 5000
	params:
		mean_frag_len = lambda wildcards: get_parameter(wildcards, '--mean-frag-len', 'frag_len'),
		sd_frag_len = lambda wildcards: get_parameter(wildcards, '--sd-frag-len', 'frag_std'),
		window_frac = "--window-frac 0.99"
		
	shell:
		"""
		python3 scripts/annotate_reads.py \
		 --sim-info {input.info} \
		 --sim-sam {input.sam} \
		 --output {output.annotated_info} \
		 {params} 
		"""