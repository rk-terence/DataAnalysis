import csv, random
file_name = 'train.csv'
train_file_name, test_file_name = [], []
for i in range(10):
    train_file_name.append('train' + str(i + 1) + '.csv')
    test_file_name.append('test' + str(i + 1) + '.csv')
lines = len(open(file_name, 'rU').readlines())
num, limt_num, train_list, test_list = 0, (int)(lines/10*2), [], []

for i in range(lines):
    if random.randint(1, 10) > 8 and num <= limt_num:
        test_list.append(i)
        num += 1
    else:
        train_list.append(i)

for i in range(10):
    train, test = [], []
    with open(file_name) as f:
        reader = csv.reader(f)
        content = [row for row in reader]
        title = []
        for tmp in range(len(content[0]) - 10):
            title.append('x' + str(tmp + 1))
        title.append('y')
        train.append(title)
        test.append(title)
        for rows in range(len(content)):
            if rows in train_list:
                train.append(content[rows][:len(content[0]) - 10 + i + 1])
            else:
                test.append(content[rows][:len(content[0]) - 10 + i + 1])
    with open(train_file_name[i], 'w', newline='') as f_train:
        writer = csv.writer(f_train)
        for row in train:
            writer.writerow(row)
    f_train.close()
    with open(test_file_name[i], 'w', newline='') as f_test:
        writer = csv.writer(f_test)
        for row in test:
            writer.writerow(row)
    f_test.close()