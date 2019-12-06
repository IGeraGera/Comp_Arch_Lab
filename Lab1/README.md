# README

Αυτό το repository έχει δημιουργηθεί στο πλαίσιο του μαθήματος Αρχιτεκτονική Υπολογιστών και αποτελείται από τα αρχεία που απαιτούνται για την απάντηση των ερωτημάτων του φυλλαδίου. Ακολουθεί:

### Αναφορά 1ου Εργαστηρίου Αρχιτεκτονικής Υπολογιστών

## Μερος Πρώτο(Part 1)

## Πρώτο και Δευτερο Ερώτημα

### Κυρίως μερος

Από το αρχείο **starter_se.py** καταγράφονται τα βασικά χαρακτηριστικά του συστήματος και επαληθεύονται από τα αρχεία **config.ini** και **config.json** τα οποία βρίσκονται στον φάκελο **part1** και είναι αποτελέσματα της πρώτης εξομοίωσης με το το αρχείο **starter_se.py** σε λειτουργία **MinorCPU** με την εντολή:

    ./build/ARM/gem5.opt configs/example/arm/starter_se.py --cpu="minor" "tests/test-progs/hello/bin/arm/linux/hello"

Σε όποιο σημείο αναφέρεται γραμμή μόνο είναι από το αρχείο **config.ini**

* Είδος εκτέλεσης **CPU=Μinor** επαληθευση από γραμμες 66-67  
**[system.cpu_cluster.cpus]
type=MinorCPU**
* **cache_line_size = 64** επαλήθευση από αρχείο config.ini γραμμή 15
* **clk_domain = SrcClockDomain(clock="1GHz",voltage_domain=self.voltage_domain)** και επαληθεύεται από το  
**[system.clk_domain]
type=SrcClockDomain
clock=1000**
στην γραμμή 44-46 του config.ini
Είναι *1/(1000 * 1 * 10^-12) =1GHz*
* **mem_mode = timing**  επαλήθευση από την γραμμη 24 του config.ini
* mem_range -> από 0 εώς 2147483647 επαλήθευση από την γραμμή 25 του confing.ini
* **CPU clock = 4Gz (default)** επαληθευεται από την γραμμή 60 του confing.ini
**[system.cpu_cluster.clk_domain]
type=SrcClockDomain
clock=250**
Είναι *1/(250 * 1 * 10^-12) =1GHz*

 Οι βασικές Cache του συστήματος για CPU=minor ειναι οι devices.L1I, devices.L1D, devices.WalkCache, devices.L2 όπου από το αρχείο config.ini είναι αντίστοιχα  

* Η instruction cache που αναφέρεται στην γραμμη 871 που είναι 48Κb size=49152  
* H dataCache που βρίσκονται τα αντίστοιχα πεδία στην γραμμή 169 με μέγεθος 32Κb size=32768
* H walkCache
* H L2 που βρίσκεται στην γραμμη 1123 με μέγεθος 1Mb size=1048576

Yπάρχει το memory bus το οποίο στο αρχείο config.ini βρίσκεται στην γραμμή 1418 και είναι τύπου Coherent CrossBar.

Το **mem-type = "DDR3_1600_8x8"(default)**
Υπάρχουν 2 ctrls για DRAM με 2 channel(default)στις γραμμες 1236 και 1327 όπου έχουν έυρος 2GB(Default) range=0:2147483647:0:1048704 (γραμμή 1295 και 1386)

### Πηγές

Για την ολοκλήρωση του πρώτου και δεύτερου μέρος ούτως ώστε να βρεθούν τα βασικά χαρακτηριστικά όπως ζητηθηκαν στον GEM5 χρησιμοποιηθήκαν οι ακόλουθες πηγές:

* <http://learning.gem5.org/book/part2/parameters.html#simple-parameters>
* <http://learning.gem5.org/book/part1/simple_config.html>
* <http://learning.gem5.org/book/presentation_notes/part1.html>
* <http://learning.gem5.org/book/part1/gem5_stats.html>

***

## Μέρος 2(Part 2)

## Τρίτο ερώτημα

Περιγραγή In-order Αρχιτεκτονικών

Το μοντέλο CPU in-order στον Gem5 δημιουργήθηκε για παρέχει ένα γενικό framework έτσι ώστε να προσομοιώνει in-order pipelines με μια οιαδήποτε αρχιτεκτονική ISA και οποιεσδήποτε περιγραφές για διοχέτευση(Pipelining).[1](http://gem5.org/InOrder) Τα κύρια μοντέλα Ιn-order επεξεργαστών είναι:

* Minor CPU
* SimpleCPU
  * BaseSimpleCPU
  * AtomicSimpleCPU
  * TimingSimpleCPU
* High-Perfomance In-order (HPI) CPU [2  (Slide 5)](http://www.gem5.org/wiki/images/c/cf/Summit2017_starterkit.pdf)

### Minor CPU

To μοντέλο Minor CPU είναι είναι ένα In-Order μοντέλο επεξεργαστή το οποίο έχει σταθερό αγωγό 4ων επιπέδων αλλα προσαρμοζόμενες δομές δεδομένων και συμπεριφορά εκτέλεσης [3](http://www.gem5.org/docs/html/minor.html). Τα 4 επίπεδα  εκτέλεσης είναι fetch1, fetch2, decode και execute [4](https://nitish2112.github.io/post/gem5-minor-cpu/). Η χρήση του ενδεικνύεται για μοντελοποίηση επεξεργαστών με  in-order συμεριφορά και επιτρέπει της εμφάνιση και οπτικοποίηση των εντολών στον αγωγό με την χρήση των κατάλληλων εργαλείων.

### SimpleCPU

Το SimpleCPU είναι ένα μοντελο επεξεργαστή το οποίo χρησιμοποιείται όταν δεν υπάρχει η άμεση ανάγκη για ένα λεπτομερές μοντέλο. Χρησιμοποιείται για γρήγορες προσομοιώσεις αγνοώντας κάποιες λεπτομέρειες.

Στο BaseSimpleCPU ορίζονται κάποιες βασικές συναρτήσεις για διαχείρηση διακοπών, παραλαβή requests, pre-execution setup κτλ. Επειδή ειναι βασικό μοντέλο(Βase) εκτελεί την μια εντολή μετά την άλλη χωρίς διοχέτευση(pipelining).  
Το BaseSimpleCPU δεν μπορεί να χρησιμοποιηθεί από μόνο του. Πρέπει να κληθεί μια από τις κλάσεις που κληρονομούνται από αυτό. Το **AtomicSimpleCPU ή TimingSimpleCPU**. Το ΑtomicSimpleCPU χρησιμοποιεί atomic access memory που είναι πιο γρήγορο ενώ το TimingSimpleCPU χρησιμοποιεί timing memory access που είναι πιο ρεαλιστικός ο χρονισμός ενώ ταυτόχρονα οι αριθμητικές εντολές εκτελούνται σε εναν κύκλο ρολογιού.[5](http://gem5.org/SimpleCPU)

*Η χρήση και των δύο(Atomic και Timing) δεν επιτρέπεται*.

[6 Arm Research Starter Kit: System Modeling using gem5  Αuthors: A Tousi C Zhu(2017)](https://raw.githubusercontent.com/arm-university/arm-gem5-rsk/master/gem5_rsk.pdf)

### HPI

Το HPI εξελίχθηκε από το MinorCPU ούτως ώστε να υπάρχει μια πιο αντιπροσωπευτική μοτελοποίηση της αρχιτεκτονικής ARM. Χρησιμοποιεί τα ίδια 4 επίπεδα εκτέλεσης που χρησιμοποιεί και το MinorCPU αλλά υπάρχουν κάποιες βελτιστοποιήσεις όσον αφορά το σύστημα διαχείρισης διακοπών του ΑRM.  
[6 Arm Research Starter Kit: System Modeling using gem5 Αuthors: A Tousi C Zhu(2017)](https://raw.githubusercontent.com/arm-university/arm-gem5-rsk/master/gem5_rsk.pdf)

***

### Υποερώτημα Α

Για την προσομοίωση χρησιμοποιήθηκε το πρόγραμμα **csample** το οποίο βρίσκεται στον φάκελο **Part2**. Είναι ένα εξαιρετικά απλό πρόγραμμα το οποίο περιέχει κάποιες πράξεις, καποιες εκχωρήσεις, εκτυπωσεις με printf και την συνάρτηση sleep() για 2ms.  
Έγινε compile με την κάτωθεν εντολή

    arm-linux-gnueabihf-gcc --static csample.c -o csample

H πρώτη προσομοίωση έγινε με τύπο CPU Minor και το αρχείο με τα αποτελέσμαατα μετνομάστηκε σε **MinorStats.txt** και βρίσκεται στον φάκελο **Part2**. Συνολικά έγιναν 36791000 ticks με Realtime 0.05s, Simulation Instruction rate 203080 ανα δευτερόλεπτο και Simulation Tick Rate 715625659 με 10422 Instructions.
H δεύτερη προσομοίωση έγινε με τύπο CPU TimingSimpleCPU και το αρχείο Stats.txt μετονομάστηκε σε **SimpleCPUStats.txt** και βρίσκεται στον φάκελο **Part2**. Συνολικά έγιναν 41574000 Ticks, ο Realtime της προσομοίωσης είναι 0,02s, το Simulation Instruction rate 564548 ανα δευτερόλεπτο και Simulation Tick Rate 2255282778 με με 10358 Instructions.

### Υποερώτημα Β

Παρατηρούμε ότι στην προσομοίωση *TimingSimpleCPU* ο χρόνος εκτέλεσης είναι γρηγορότερος κατα *3ms*. Αυτό είναι λογικό καθως το *TimingSimpleCPU* είναι *BaseSimpleCPU* και είναι γρηγορότερο. Τα ticks στο *TimingSimpleCPU* είναι περισσότερα όπως και το Tick rate/s. Παρατηρούμε επίσης ότι ο αριθμός εντολών(Instructions και Ops)στον επεξεργαστή είναι λιγότερος στο *SimpleCPU** αλλά όχι κατά πολύ και αυτό είναι λογικό καθως παραλείπει κάποιες εντολές. Τέλος το Instruction rate και το Simulation Tick Rate του SimpleCPU είναι σαφώς μεγαλύτερο. Αυτό πιστεύω έχει να κάνει με τον πιο απλοικό τρόπο λειτουργίας του *TimingSimpleCPU* καθώς εκτελεί σε ένα κύκλο μια εντολή.


### Υποερώτημα Γ

Για το τρίτο ερώτημα επιλέχθηκε να γίνει αλλάγη στην μνημη επιλέγοντας την *LPDDR3_1600_1x32* και αλλαγή στην ταχύτητα του ρολογιού του επεξεργαστη επιλέγοντας ταχύτητα *500MHz*.Τα αποτελέσματα των εξομοιώσεων βρίσκονται στο **LPDDR_500MHz_MinorStats.txt** και **LPDDR_500MHz_SimpleTimingStats.txt** στον φάκελο **Part2**.

Οι εντολές που χρησιμοποιήθηκαν είναι οι

    ./build/ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU --cpu-clock=500MHz --mem-type=LPDDR3_1600_1x32 --caches -c /home/ioannis/architecture/csample
και

    ./build/ARM/gem5.opt configs/example/se.py --cpu-type=MinorCPU --cpu-clock=500MHz --mem-type=LPDDR3_1600_1x32 --caches -c /home/ioannis/architecture/csample

Παρατηρείται πως με την μέθοδο *SimpleTimingCPU* χρειάστηκαν 94588000 ticks μέχρι το τέλος,Realtime 0.05s, εξομοιώθηκαν 10358 instructions με tick rate 5936505227 ανα δευτερόλεπτο και instruction rate 653679 ανα δευτερόλεπτο. Ενώ μετην μέθοδο *MinorCPU* χρειάστηκαν 68234000 ticks μέχρι το τέλος, Realtime 0.02s, εξομοιώθηκαν 10422 instructions με tick rate 1394694638 ανα δευτερόλεπτο και instruction rate 213407 ανα δευτερόλεπτο.  
Σε σχέση με τις προηγούμενες μετρήσεις και στις 2 περιπτώσεις ο αριθμός των instruction προφανώς και έμειναν σταθερές επίσης σταθερός έμεινε ο realtimw χρόνος προσομοίωσης γιατί δεν αλλάξαμε το global clock αλλα το clock του επεξεργαστή.  
Παρατειρείται ότι τα ticks διπλασιάστηκαν περίπου λόγω επεγεργαστή και το tick rate σεδόν διπλασιάστηκε για να αντισταθμίσει την αλλαγή της μισης ταχύτητας επεξεργαστή. Τέλος το instruction rate αυξήθηκε ελαφρώς λόγω μνήμης(?) και η χρήση μνήμης έμεινε σταθερή.

***

## Κριτική

Πιστεύω πως ήταν μια πολύ καλή πρώτη επαφή με το Gem5 και με ασκήσεις οι οποίες είναι διαισθητικές που σε καθοδηγούν στο χαοτικό αυτό περιβάλλον.  
Σαν άτομο όμως που ήμουν και στην παρουσίαση και είχα ήδη μια κάποια ιδέα για το τι συμβαίνει με τον Gem5 και που να κοιτάξω για να βρώ τις πληροφορίες που έπρεπε για να καταγράψω στο πρώτο και δεύτερο θέμα, μου φάνηκε πολύ δύσκολο να τις εντοπίσω και στα 2 αρχεία για να επαληθευτούν, με αποτέλεσμα να πάρει πάρα μα πάρα πολύ ώρα καθώς το ένα που ήταν σε Python είχε κρυμμένες πληροφορίες, ενώ το άλλο είχε 1500 γραμμες. Το υλικό στην σελίδα του Gem5 είναι πάρα πολύ περιορισμένο και δεν έιχα συνειδητοποιήσει ότι έπρεπε να στραφώ στο scholar και να διαβάσω από paper για αναζήτηση υλικού. Ίσως θα ήταν καλό να είχε δωθεί όχι το τι ακριβως χρειαζόταν ώστε να το βρούμε έτοιμο αλλά κάποια βιβλιογραφία ακαδημαϊκής προελεύσεως που ακόμα και σε paper η συμπυκνωση και αναζήτηση πληροφορίας είναι χρήσιμη και ελαφρώς δύσκολη να γίνει σωστά.
