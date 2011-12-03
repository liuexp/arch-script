rm tmpheader
curl -s --dump-header tmpheader http://phycai.sjtu.edu.cn/wis/default.aspx>> /dev/null

curl -s -b tmpheader  --data "__VIEWSTATE=dDwyNjIxNzg1MDY7dDw7bDxpPDE%2BOz47bDx0PDtsPGk8MT47PjtsPHQ8cDxwPGw8VGV4dDs%2BO2w8MjAxMeW5tDnmnIg45pelJm5ic3BcOyZuYnNwXDsmbmJzcFw7Jm5ic3BcOzIwMTEtMjAxMiDlrablubQg56ysIDEg5a2m5pyfIOesrFw8Zm9udCBjb2xvcj0jZmYwMDAwXD4mbmJzcFw7MSZuYnNwXDtcPC9mb250XD7lkaggICAgXDxmb250IGNvbG9yPSNmZjAwMDBcPuaYn%2Bacn%2BWbm1w8L2ZvbnRcPjs%2BPjs%2BOzs%2BOz4%2BOz4%2BOz77BXClzU8%2Ft1Fq9geIOTe5%2FjQKvw%3D%3D&Menu1%3Ausername=5100309243&Menu1%3Apassword=5100309243&Menu1%3Auser=2&Menu1%3ALoginHavier=+%E7%99%BB+%E5%BD%95+" --dump-header tmpheader -L "http://phycai.sjtu.edu.cn/wis/default.aspx?ReturnUrl=%2fwis%2fstudent%2fstudentcoursehost.aspx%3fcourteaconnid%3d1037&amp;courteaconnid=1037" >> /dev/null

curl -s -b tmpheader --referer "http://phycai.sjtu.edu.cn/wis/course/coursework.aspx?columnid=M21" "http://phycai.sjtu.edu.cn/wis/course/coursework.aspx?columnid=M21" |grep -i '^[^<]*<span id=\"Menu2' | tr -d '\n' |sed -n -e 's/<span id=\"Menu2_DataGrid1__[^\"]\+\"><b><font color=\"#000099\">\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)[^\"]*\"Menu2_DataGrid1__[^\"]\+\">\(<span id=\"Menu2_DataGrid1__[^\"]\+\">\)\?\([^<]\+\).*/\n \1\t \3\n /gp' |sed -e 's/\&nbsp\;/\ /g'
rm tmpheader
