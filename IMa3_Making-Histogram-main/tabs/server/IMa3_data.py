import pandas


def ExData(file):
    ### first step ###
    f = open(file)
    indx = []

    for i, line in enumerate(f):
        if not line:
            break
        if 'HISTOGRAM GROUP' in line:
            indx.append(i)

    f.close()

    ### second step ###
    f = open(file)

    for i, line in enumerate(f):
        if not line:
            break
        if indx[0] < i < indx[1]:
            if 'Parameter' in line:
                group1_st = i
                g1_column = line.split()  # column
            if ' SumP' in line:
                # print(line)
                group1_fin = i
        elif indx[1] < i < indx[2]:
            if 'Parameter' in line:
                group2_st = i
                g2_column = line.split()  # column:26개
            if ' SumP' in line:
                # print(line)
                group2_fin = i
    f.close()

    ### third step ###
    f = open(file)
    g1_value = []
    g2_value = []
    column = []

    for i, line in enumerate(f):
        if not line:
            break
        if group1_st + 2 < i < group1_fin:
            g1_value.append(line.split())

        elif group2_st + 2 < i < group2_fin:
            g2_value.append(line.split())

    f.close()

    ### merge ###
    test = pandas.DataFrame(g1_value)
    test.columns = g1_column

    test1 = pandas.DataFrame(g2_value)
    test1.columns = g2_column

    df = pandas.merge(test, test1, on='Parameter', suffixes=['_', '_']).set_index('Parameter')
    return df

