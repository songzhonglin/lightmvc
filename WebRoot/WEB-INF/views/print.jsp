<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>数据打印</title>
    <style type="text/css">
body{background:white;margin:0px;padding:0px;font-size:13px;text-align:left;}
.pb{font-size:13px;border-collapse:collapse;}
.pb th{font-weight:bold;text-align:center;border:1px solid #333333;padding:2px;}
.pb td{border:1px solid #333333;padding:2px;}
　　</style>
</head>
<body>
    <script type="text/javascript">
        document.write(window.dialogArguments);
        window.print();
    </script>
</body>
</html>