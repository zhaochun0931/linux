bash --version












# higher bash version

for i in {1..10}
do
echo $i
done

for i in {1..10..3}
do
echo $i
done

1
4
7
10






# C loop style

for ((i=1; i<10; i++))
do
echo $i
done






# old bash version, the seq was out of date

for i in $(seq 10)
do
echo $i
done
