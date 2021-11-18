# add by Sty1ish
import pandas as pd

# GetValue 열 개수 구하기 자동화
def Readti(file):
    with open(file) as line:
        datafile = line.readlines()
    for i in datafile:
        if 'Number of populations' in i:
            length = int(i.replace("Number of populations:","").strip())-1
            break
    return GetValue(file, length)

# file, readline을 받아 VAlUESTART 이후 라인 읽고 df반환.
def GetValue(file,readline=2):
    f = open(file)
    value = []      # list
    startval = 0    # 식별자
    # load after VALUESTART DATA
    while True:
        line = f.readline()
        if not line:
            break
        if startval == 1:
            line = line.replace('\n', "").split('\t')
            if line[-1] == '':
                line.pop()
            value.append(line)
        if 'VALUESSTART' in line:
            startval = 1
    f.close()

    # 열 고르기, df화 시키기.
    colname = ['t'+str(i) for i in range(readline)]
    colname.insert(0, 'logprior');colname.insert(0, 'loglikelihood')

    treat_set = [] # df제작 임시 변수.
    for column in value:
        line = []
        for i, v in enumerate(reversed(column)):
            if i+1 <= readline+2: # enumerate는 0에서 시작이기에 계산시 1개가 더 많게 봐야함.
                line.insert(0, v)
            else:
                break
        treat_set.append(line)

    # df형 반환.
    df = pd.DataFrame(treat_set,columns=colname).apply(pd.to_numeric)
    return df


