__author__ = "Padraic Corcoran"
__copyright__ = "Copyright 2024, Padraic Corcoran"
__email__ = "padraic.corcoran@scilifelab.uu.se"
__license__ = "GPL-3"


rule pbmarkdup:
    input:
        bam=get_pbmarkdup_input,
    output:
        bam="prealignment/pbmarkdup/{sample}_{type}_{processing_unit}_{barcode}.bam",
    params:
        extra=config.get("pbmarkdup", {}).get("extra", ""),
    log:
        "prealignment/pbmarkdup/{sample}_{type}_{processing_unit}_{barcode}.bam.log",
    benchmark:
        repeat(
            "prealignment/pbmarkdup/{sample}_{type}_{processing_unit}_{barcode}.bam.benchmark.tsv",
            config.get("pbmarkdup", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("pbmarkdup", {}).get("threads", config["default_resources"]["threads"])
    resources:
        mem_mb=config.get("pbmarkdup", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("pbmarkdup", {}).get("mem_per_cpu", config["default_resources"]["mem_per_cpu"]),
        partition=config.get("pbmarkdup", {}).get("partition", config["default_resources"]["partition"]),
        threads=config.get("pbmarkdup", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("pbmarkdup", {}).get("time", config["default_resources"]["time"]),
    container:
        config.get("pbmarkdup", {}).get("container", config["default_container"])
    message:
        "{rule}: mark duplicates in {input.bam}"
    shell:
        "pbmarkdup --num-threads {threads} "
        "{input.bam} "
        "{output.bam} --log-level INFO &> {log}"
