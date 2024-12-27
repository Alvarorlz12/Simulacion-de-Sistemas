# mkdir reto


datos_reto_1_rk="reto_1_rk.dat"
datos_reto_1_euler="reto_1_euler.dat"
datos_reto_2_rk="reto_2_rk.dat"
datos_reto_2_euler="reto_2_euler.dat"
img_reto_1_tiempo="reto/iniciales_450_90_tiempo.png"
img_reto_1_versus="reto/iniciales_450_90_versus.png"
img_reto_2_tiempo="reto/iniciales_100_20_tiempo.png"
img_reto_2_versus="reto/iniciales_100_20_versus.png"
img_reto_versus="reto/poblaciones.png"

# gnuplot -e "\
#     set terminal png; \
#     set output '$img_reto_1_tiempo'; \
#     set title 'Tiempo vs Poblaciones'; \
#     set xlabel 'Tiempo'; \
#     set ylabel 'Población'; \
#     set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5; \
#     set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5; \
#     set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1.5; \
#     set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1.5; \
#     plot '$datos_reto_1_rk' using 1:2 title 'Presas RK' with linespoints linestyle 1, \
#          '$datos_reto_1_rk' using 1:3 title 'Depredadores RK' with linespoints linestyle 2, \
#          '$datos_reto_1_euler' using 1:2 title 'Presas Euler' with linespoints linestyle 3, \
#          '$datos_reto_1_euler' using 1:3 title 'Depredadores Euler' with linespoints linestyle 4;"
# gnuplot -e "\
#     set terminal png; \
#     set output '$img_reto_1_tiempo'; \
#     set title 'Tiempo vs Poblaciones'; \
#     set xlabel 'Tiempo'; \
#     set ylabel 'Población'; \
#     set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1; \
#     set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1; \
#     set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1; \
#     set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1; \
#     plot '$datos_reto_1_rk' using 1:2 title 'Presas RK' with lines linestyle 1, \
#          '$datos_reto_1_rk' using 1:3 title 'Depredadores RK' with lines linestyle 2;"
gnuplot -e "\
    set terminal png; \
    set output '$img_reto_versus'; \
    set title 'Presas vs Depredadores'; \
    set xlabel 'Presas'; \
    set ylabel 'Depredadores'; \
    set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1; \
    set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1; \
    set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1; \
    set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1; \
    plot '$datos_reto_1_rk' using 2:3 title 'x=450, y=90' with lines linestyle 1,
         '$datos_reto_2_rk' using 2:3 title 'x=100, y=20' with lines linestyle 2;"
# gnuplot -e "\
#     set terminal png; \
#     set output '$img_reto_2_tiempo'; \
#     set title 'Tiempo vs Poblaciones | x=100 y=20'; \
#     set xlabel 'Tiempo'; \
#     set ylabel 'Población'; \
#     set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5; \
#     set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5; \
#     set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1.5; \
#     set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1.5; \
#     plot '$datos_reto_2_rk' using 1:2 title 'Presas RK' with linespoints linestyle 1, \
#          '$datos_reto_2_rk' using 1:3 title 'Depredadores RK' with linespoints linestyle 2;"
# gnuplot -e "\
#     set terminal png; \
#     set output '$img_reto_2_tiempo'; \
#     set title 'Tiempo vs Poblaciones | x=100 y=20'; \
#     set xlabel 'Tiempo'; \
#     set ylabel 'Población'; \
#     set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5; \
#     set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.5; \
#     set style line 3 lc rgb '#00ad00' lt 1 lw 2 pt 9 ps 1.5; \
#     set style line 4 lc rgb '#ad00ad' lt 1 lw 2 pt 11 ps 1.5; \
#     plot '$datos_reto_2_rk' using 1:2 title 'Presas RK' with linespoints linestyle 1, \
#          '$datos_reto_2_rk' using 1:3 title 'Depredadores RK' with linespoints linestyle 2, \
#          '$datos_reto_2_euler' using 1:2 title 'Presas Euler' with linespoints linestyle 3, \
#          '$datos_reto_2_euler' using 1:3 title 'Depredadores Euler' with linespoints linestyle 4;"