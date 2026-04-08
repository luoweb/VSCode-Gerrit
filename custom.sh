#!/bin/bash

baseDir=$(cd `dirname $0`;pwd)
cd $baseDir
execStartTime=`date +%Y%m%d-%H:%M:%S`

echo "${execStartTime} Exe Dir: $baseDir"
xsed='sed -i'
system=`uname`
if [ "$system" == "Darwin" ]; then
  echo "This is macOS"
  xsed="sed -i .bak"
else
  echo "This is Linux"
  xsed='sed -i'
fi

echo "########## ui custom ########## "

echo "readme custom"
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Work In Progress",#"title": "进行中",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Your Turn",#"title": "您负责的",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Outgoing Reviews",#"title": "我发起的评审",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Ingoing Reviews",#"title": "待我审核的评审",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "CCed",#"title": "在代码评审里被抄送",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Recently Closed",#"title": "近期关闭",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#"title": "Recently Closed",#"title": "近期关闭",#g'
find ${baseDir}/../ -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.json" | grep -v node_modules | grep -v ".bak" | grep -v Start | xargs $xsed 's#No change selected#未选中任何变更#g'

echo "ui custom end"