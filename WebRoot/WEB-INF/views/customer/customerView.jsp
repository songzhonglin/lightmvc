<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %> 
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>客气信息详情</title>
</head>
<body>
<style>
.container{ position:relative;}
</style>
<style>
.izImage2{border:0;width:400px;}
.izViewer2{width:200px;height:180px;position:absolute;left:210px;top:0;display:none; border:1px solid #999;}
.handle2{display:none;opacity:0.6;filter:alpha(opacity=60);background:#E6EAF3; cursor:crosshair;}
</style>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
		<table class="grid">
			<tr>
					<td style="width: 80px;">姓名:</td>
					<td style="width: 130px;">
						${customer.custName}
					</td>
					<td style="width: 80px;">性别:</td>
					<td style="width: 130px;">
						${customer.custSex == 0 ?'男':'女'}
					</td>
			</tr>
			<tr>
					<td>年龄:</td>
					<td>
						${customer.custAge}
					</td>
					<td>联系方式:</td>
					<td>
						${customer.custPhone}
					</td>
				</tr>
				<tr>
					<td>身份证号码:</td>
					<td>
						${customer.idCard}
					</td>
					<td>微信号:</td>
					<td>
						${customer.custWebchat}
					</td>
				</tr>
				<tr>
					<td>QQ号:</td>
					<td>
						${customer.custQq}
					</td>
					<td>
						创建时间:
					</td>
					<td>
						<fmt:formatDate value="${customer.createDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/>					
					</td>
				</tr>
				<tr>
					<td>地址:</td>
					<td  colspan="3">
						${customer.custAddress}
					</td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3">
						${customer.remark}
					</td>
				</tr>
			<tr>
				<td>
							个人图片:
				</td>
				<td colspan="3">
					<div class="container"> 
						<img id="idImage2" class="izImage2" src="${ctx}/${customer.imgPath}" style="width: 200px;height: 180px;"/>
						<div id="idViewer2" class="izViewer2"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<script>

(function(){

var iz = new ImageZoom( "idImage2", "idViewer2", {
	mode: "handle", handle: "idHandle3", scale: 2, delay: 0
});
iz.reset({ originPic: o.originPic, zoomPic: o.zoomPic });
})()

</script>

</body>
</html>
