#! /bin/bash

# In this script the EDAP calculation is automated by using the modified print_energy.py
# that instead of energy, calculated EDAP. 

#Setting Path to the benchmark directories
benches_path="../Benches/*/*/"

# Iterating through directories
for i in $benches_path; do
	#Creating the same file structure in Results instead of Benches
	results_path="${i/"../Benches/"/""}"
	mkdir -p $results_path
	# Running GEM5ToMcPat.py to create the cpu .xml file.
	./GEM5ToMcPAT.py "$i"stats.txt"" "$i"config.json"" inorder_arm.xml -o "$results_path"my_cpu.xml""
	# Running the McPat and exporting the results in a txt in the file created above
	./../../../../my_mcpat/mcpat/mcpat  -infile "$results_path"my_cpu.xml"" -print_level 5 > "$results_path"results.txt""
	# Isolating benchmark name and printing the name in the EDAP_Results.txt
	file_name=$(basename $results_path )	
	echo -n $file_name >> EDAP_results.txt
	echo -n "	" >> EDAP_results.txt
	# Running the modified Script and printing the results in the EDAP_Results.txt
	EDAP=$(./print_energy.py "$results_path"results.txt"" "$i"stats.txt"")
	echo $EDAP >> EDAP_results.txt		
done
