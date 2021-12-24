import xlwings
import operator

# 取字串長度
def len_byte(value):
    length = len(value)
    utf8_length = len(value.encode('utf-8'))
    length = (utf8_length - length) / 2 + length
    return int(length)

statusMap = {
    'A': '新增',
    'M': '修改',
    'D': '刪除',
}

statusColor = {
    'A': [198,224,180],
    'M': [251,231,162],
    'D': [248,203,173],
}

gitDiff = open("/getXsl/gitDiff.txt", "r")
gitList = gitDiff.readlines()
gitDiff.close()

# 初始化工作表
app = xlwings.App(visible=False,add_book=False)
wb = app.books.add()
sht = wb.sheets['工作表1']
sht['A1'].value = 'PROGRAM'
sht['B1'].value = 'PATH on TFS'
sht['C1'].value = 'NOTE'
sht['A1:C1'].color = 192,192,192
ATextLengths = {}
BTextLengths = {}

for i in range(len(gitList)):
    gitSplit = gitList[i].split('\t')
    status = gitSplit[0]
    name = gitSplit[1].replace('\n', '')

    rowIndex = i + 2

    sht['A' + str(rowIndex)].formula = '=TRIM(RIGHT(SUBSTITUTE(B' + str(rowIndex) +',"/",REPT(" ",LEN(B' + str(rowIndex) + '))),LEN(B' + str(rowIndex) + ')))'
    ATextLengths[rowIndex] = len_byte(name.split('/')[-1])

    sht['B' + str(rowIndex)].value = name
    BTextLengths[rowIndex] = len_byte(name)

    sht['C' + str(rowIndex)].value = statusMap[status]
    sht['C' + str(rowIndex)].color = statusColor[status]

# 設定欄寬
AMaxLenRow = max(ATextLengths.items(), key=operator.itemgetter(1))[0]
BMaxLenRow = max(BTextLengths.items(), key=operator.itemgetter(1))[0]
sht['A' + str(AMaxLenRow)].autofit()
sht['B' + str(BMaxLenRow)].autofit()

# 設定邊框

from appscript import k
sht['A1:C' + str(len(gitList) + 1)].api.get_border(which_border=k.border_top).line_style.set(k.continuous)
sht['A1:C' + str(len(gitList) + 1)].api.get_border(which_border=k.border_left).line_style.set(k.continuous)
sht['A1:C' + str(len(gitList) + 1)].api.get_border(which_border=k.border_right).line_style.set(k.continuous)
sht['A1:C' + str(len(gitList) + 1)].api.get_border(which_border=k.border_bottom).line_style.set(k.continuous)

wb.save('programlist.xlsx')
app.quit()