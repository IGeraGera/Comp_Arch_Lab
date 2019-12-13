#!/bin/bash
#This is a script for automating the benchmark testing process, while making the conf_script_jeng.ini file for reading results with read_results.sh
#Run it in Gem5 directroy with the benchmarks in the spec_cpu2006 directory under Gem5 

#Initiating variable for measuring iterations
iter=0

#Adding the first line of the conf_script_jeng.ini
echo "[Benchmarks]" >> conf_script_jeng.ini


# Adding names of tests in conf_script_jeng.ini and running tests
for dcache in {32,64,128}; do
	((iter+=1))
	filename="specsjeng1_dcache_"$dcache""
	echo $filename >> conf_script_jeng.ini
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size="$dcache"kB --l1i_size=64kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc=1 --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000
done

for icache in {32,64,128};do		
	((iter+=1))
	filename="specsjeng1_icache_"$icache""
	echo $filename >> conf_script_jeng.ini	
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size="$icache"kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc=1 --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000
done

for l2 in {512kB,1MB,2MB,4MB};do
	((iter+=1))
	filename="specsjeng1_l2_"$l2""
	echo $filename >> conf_script_jeng.ini	
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size="$l2" --l1i_assoc=1 --l1d_assoc=1 --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000
done

for assocl1i in {1,2,4,8};do	
	((iter+=1))
	filename="specsjeng1_assocl1i_"$assocl1i""
	echo $filename >> conf_script_jeng.ini
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size=512kB --l1i_assoc="$assocl1i" --l1d_assoc=1 --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000	
done

for assocl1d in {1,2,4,8};do	
	((iter+=1))
	filename="specsjeng1_assocl1d_"$assocl1d""
	echo $filename >> conf_script_jeng.ini
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc="$assocl1d" --l2_assoc=2 --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000	
done

for assocl2 in {1,2,4,8};do	
	((iter+=1))	
	filename="specsjeng1_assocl2_"$assocl2""
	echo $filename >> conf_script_jeng.ini
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc=1 --l2_assoc="$assocl2" --cacheline_size=64 --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000	
done

for line_size in {32,64,128};do
	((iter+=1))	
	filename="specsjeng1_linesize_"$line_size""
	echo $filename >> conf_script_jeng.ini
	./build/ARM/gem5.opt -d specsjeng_results/"$filename" configs/example/se.py --cpu-type=MinorCPU --caches --l2cache --l1d_size=32kB --l1i_size=64kB --l2_size=512kB --l1i_assoc=1 --l1d_assoc=1 --l2_assoc=2 --cacheline_size="$line_size" --cpu-clock=1GHz -c spec_cpu2006/458.sjeng/src/specsjeng -o "spec_cpu2006/458.sjeng/data/test.txt" -I 100000000		
done
echo "The total number of iterations is $iter"

#Moving conf.ini file into results file
mv conf_script_jeng.ini specsjeng_results/



inipath="specsjeng_results/conf_script_jeng.ini"
echo -e "[Parameters]\nsim_seconds\nsystem.cpu.cpi\nsystem.cpu.dcache.overall_miss_rate::total\nsystem.cpu.icache.overall_miss_rate::total\nsystem.l2.overall_miss_rate::total\n[Output]\nResults.txt" >> $inipath

