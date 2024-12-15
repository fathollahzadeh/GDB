## Author: Seyyid Hikmet Celik

import argparse
import codecs

parser = argparse.ArgumentParser(description='Create Configuration')
parser.add_argument('-f', '--filename', type=str, help='Specify file name to fix encoding', default='')
parser.add_argument('-i', '--index', type=int, help='Specify Query Index', default=0)
args = parser.parse_args()

with open(args.filename, 'r') as file:
    ql = [f"{args.index}|||"]
    for rl in file.readlines():
        ql.append(rl.strip())
    fixedstr = " ".join(ql)    

with open(args.filename, 'w') as file:    
    file.write(fixedstr)
