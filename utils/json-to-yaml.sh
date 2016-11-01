for i in $(find . -name '*.json');do  python -c 'import sys,json,yaml;print(yaml.safe_dump(json.loads(sys.stdin.read()), default_flow_style=False))' < $i > ${i/json/yaml};done

