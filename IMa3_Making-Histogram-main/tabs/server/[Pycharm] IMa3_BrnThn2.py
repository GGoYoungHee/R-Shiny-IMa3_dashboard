import os

def BrnThn(input_dir,out_dir,Brn=0,Thn=0):
    input_file=open(input_dir)
    out_file=open(out_dir,mode='at')

    i=0
    while True:
        line=input_file.readline()
        i+=1
        if not line: break
    
        if i <= 128: 
            out_file.write(line)

        if i>128+Brn:
            if Thn==0:
                out_file.write(line)
            elif (i-Brn)%Thn==0:
                out_file.write(line)

    input_file.close()
    out_file.close()



'''
Test Code
### If file directory(input_dir, out_dir) has \, Please change the "\" to "/" ###

# Burn-in: 5, Thinin: 4
BrnThn('D:/KGU_Labs_BayesianRandom/300_sym_OSK_recom_IMa3_run6_2.out.ti','D:/KGU_Labs_BayesianRandom/Brn5_Thn4.out.ti',Brn=5,Thn=4)

# Only Burn-in, Not Thining
BrnThn('D:/KGU_Labs_BayesianRandom/300_sym_OSK_recom_IMa3_run6_2.out.ti','D:/KGU_Labs_BayesianRandom/OnlyBrn10.out.ti',Brn=10)

# No brun-in. Only 10 Thining
BrnThn('D:/KGU_Labs_BayesianRandom/300_sym_OSK_recom_IMa3_run6_2.out.ti','D:/KGU_Labs_BayesianRandom/OnlyThn10.out.ti',Thn=10)
'''
'''
input_file=open('C:/Users/rhtn2/OneDrive/바탕 화면/연구조교/02. Rshiny project/300_sym_OSK_recom_IMa3_run6_2.out (1).ti')
valuestart=0
while True:
        line=input_file.readline()
        valuestart+=1
        if line=='VALUESSTART\n': break
'''