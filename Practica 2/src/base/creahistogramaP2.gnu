reset
n=10 #number of intervals. Aumentar o disminuir si se quiere más o menos granularidad en el histograma
a=0.7 # el parametro de la distribucion trapezoidal. Cambiar por el valor utilizado para generar los datos
max=1.0	#max value
min=0.0	#min value
width=(max-min)/n	#interval width
#function used to map a value to the intervals
hist(x,width)=width*floor(x/width)+width/2.0
set term png	#output terminal and file
#set term wxt	#output terminal and file
set output "histo.png"
set xrange [min:max]
set yrange [0:]
#to put an empty boundary around the
#data inside an autoscaled graph.
#set offset graph 0.05,0.05,0.05,0.0
set xtics min,(max-min)/10,max
set boxwidth width*0.9
set style fill solid 0.5	#fillstyle
set tics out nomirror
set xlabel "valores del generador"
set ylabel "Frecuencias normalizadas"
#count and plot
f(x)= a+2*(1-a)*x
#plot "kkk.txt" u (hist($1,width)):(1.0) smooth freq w boxes lc rgb"black" notitle
plot "kk07.txt" u (hist($1,width)):(1.0) smooth fnormal w boxes lc rgb"grey" notitle, f(x)*width lc rgb"black" notitle
