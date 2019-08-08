import configparser
import yaml
import util_functions

PROJECT_DIR = config["all"]["project_dir"]
BARCODE_FP = PROJECT_DIR + "/barcodes.txt"
SAMPLE_IDS = util_functions.get_sample(BARCODE_FP)
CLADE_LIST = config["panphlan"]["clades"]
DECONTAM_DIR = PROJECT_DIR + "/sunbeam_output/qc/decontam"
PANPHLAN_DIR = PROJECT_DIR + "/PanPhlAn_output"
MAP_RESULT_DIR = PANPHLAN_DIR + "/map_result"

workdir: PROJECT_DIR

include: "rules/target/target.rules"
include: "rules/map/map.rules"
include: "rules/profile/profile.rules"

rule all:
    input: TARGET_ALL

onsuccess:
        print("Workflow finished, no error")
        shell("mail -s 'Workflow finished successfully' " + config["all"]["admin_email"] + " < {log}")

onerror:
        print("An error occurred")
        shell("mail -s 'An error occurred' " + config["all"]["admin_email"] + " < {log}")
